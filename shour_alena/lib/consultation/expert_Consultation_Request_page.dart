
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/consultation/Chat_room_page.dart';
import 'package:shour_alena/core/rawan_colors.dart';

class ExpertConsultationRequestsPage extends StatelessWidget {
  const ExpertConsultationRequestsPage({super.key});


  String _norm(String s) => s.trim().toLowerCase();

  Stream<QuerySnapshot<Map<String, dynamic>>> _requestsStream() async* {
    final uid = FirebaseAuth.instance.currentUser!.uid;


    final expertDoc =
        await FirebaseFirestore.instance.collection('retirees').doc(uid).get();
    final expertData = expertDoc.data() ?? {};
    final specialization = _norm((expertData['specialization'] ?? '').toString());

    print('[expert] specialization="$specialization"');


    final all = await FirebaseFirestore.instance
        .collection('consultation_requests')
        .get();
    print('[debug] all requests count=${all.docs.length}');

    if (specialization.isEmpty) {
      print('[warn] expert has no specialization');
      yield* const Stream.empty();
      return;
    }

    yield* FirebaseFirestore.instance
        .collection('consultation_requests')
        .where('specializationNorm', isEqualTo: specialization)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> _reject(String reqId) async {
    await FirebaseFirestore.instance
        .collection('consultation_requests')
        .doc(reqId)
        .update({
      'status': 'rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _acceptAndCreateRoom(
    BuildContext context, {
    required String requestId,
    required String companyId,
  }) async {
    final expertId = FirebaseAuth.instance.currentUser!.uid;

 
    await FirebaseFirestore.instance
        .collection('consultation_requests')
        .doc(requestId)
        .update({
      'status': 'accepted',
      'acceptedBy': expertId,
      'acceptedAt': FieldValue.serverTimestamp(),
    });


    final roomRef = await FirebaseFirestore.instance
        .collection('consultation_rooms')
        .add({
      'requestId': requestId,
      'companyId': companyId,
      'expertId': expertId,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
    });


    await FirebaseFirestore.instance
        .collection('consultation_requests')
        .doc(requestId)
        .update({'roomId': roomRef.id});

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم القبول وإنشاء جلسة التواصل')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatRoomPage(roomId: roomRef.id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        title: Text(
          'طلبات الاستشارة',
          style: GoogleFonts.almarai(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _requestsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد طلبات في تخصصك حالياً',
                style: GoogleFonts.almarai(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();

              final companyId = (data['companyId'] ?? '').toString();
              final status = (data['status'] ?? 'pending').toString();

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'الشركة: ${data['companyName'] ?? 'غير معروف'}',
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'التخصص المطلوب: ${data['specialization'] ?? '-'}',
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'التفاصيل: ${data['requestDetails'] ?? ''}',
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
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
                          if (status == 'pending') ...[
                            TextButton(
                              onPressed: () => _reject(d.id),
                              child: const Text(
                                'رفض',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: RawanColors.grenn,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => _acceptAndCreateRoom(
                                context,
                                requestId: d.id,
                                companyId: companyId,
                              ),
                              child: const Text('قبول'),
                            ),
                          ],
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



