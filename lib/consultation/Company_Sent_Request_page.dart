import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/consultation/Chat_room_page.dart';
import 'package:shour_alena/core/rawan_colors.dart';


class CompanySentRequestsPage extends StatelessWidget {
  const CompanySentRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        title: Text(
          'طلباتي',
          style: GoogleFonts.almarai(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('consultation_requests')
            .where('companyId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'ما عندك طلبات بعد',
                style: GoogleFonts.almarai(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();
              final status = (data['status'] ?? 'pending').toString();
              final roomId = (data['roomId'] ?? '').toString();

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'للتخصص: ${data['specialization'] ?? '-'}',
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'التفاصيل: ${data['requestDetails'] ?? ''}',
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'accepted'
                                  ? Colors.green.withOpacity(.15)
                                  : status == 'rejected'
                                  ? Colors.red.withOpacity(.15)
                                  : Colors.grey.withOpacity(.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status == 'accepted'
                                  ? 'تم القبول'
                                  : status == 'rejected'
                                  ? 'تم الرفض'
                                  : 'بانتظار الرد',
                              style: GoogleFonts.almarai(
                                color: status == 'accepted'
                                    ? Colors.green[800]
                                    : status == 'rejected'
                                    ? Colors.red[800]
                                    : Colors.grey[800],
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (status == 'accepted' && roomId.isNotEmpty)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: RawanColors.grenn,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChatRoomPage(roomId: roomId),
                                  ),
                                );
                              },
                              child: const Text('فتح الجلسة'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
