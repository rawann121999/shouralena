import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatelessWidget {
  final String roomId;
  const ChatRoomPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final messagesQuery = FirebaseFirestore.instance
        .collection('consultation_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true);

    final ctrl = TextEditingController();

    Future<void> send() async {
      final text = ctrl.text.trim();
      if (text.isEmpty) return;
      ctrl.clear();

      await FirebaseFirestore.instance
          .collection('consultation_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
            'senderId': uid,
            'text': text,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await FirebaseFirestore.instance
          .collection('consultation_rooms')
          .doc(roomId)
          .update({'lastMessage': text});
    }

    return Scaffold(
      appBar: AppBar(title: const Text('جلسة التواصل')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesQuery.snapshots(),
              builder: (_, snap) {
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                final msgs = snap.data!.docs;
                if (msgs.isEmpty)
                  return const Center(child: Text('ابدأ المحادثة…'));
                return ListView.builder(
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i].data() as Map<String, dynamic>;
                    final me = m['senderId'] == uid;
                    return Align(
                      alignment: me
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: me ? Colors.green[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(m['text'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك…',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: send, child: const Text('إرسال')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
