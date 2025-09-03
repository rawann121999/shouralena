import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/rawan_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewExperiencesPage extends StatelessWidget {
  const ViewExperiencesPage({super.key});


  String? _pathFromSupabasePublicUrl(String url) {
    const marker = '/storage/v1/object/public/profile-pictures/';
    final i = url.indexOf(marker);
    if (i == -1) return null;
    return url.substring(i + marker.length);
  }

  Future<void> _deleteExperience(
    BuildContext context,
    String docId,
    String? certificateUrl,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final supabase = Supabase.instance.client;

    try {

      if (certificateUrl != null && certificateUrl.isNotEmpty) {
        final path = _pathFromSupabasePublicUrl(certificateUrl);
        if (path != null && path.isNotEmpty) {
          await supabase.storage.from('profile-pictures').remove([path]);
        }
      }


      await FirebaseFirestore.instance
          .collection('retirees')
          .doc(uid)
          .collection('experiences')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف الخبرة بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحذف: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        title: Text(
          'عرض الخبرات',
          style: GoogleFonts.almarai(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('retirees')
            .doc(uid)
            .collection('experiences')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد خبرات مضافة',
                style: GoogleFonts.almarai(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final exp = doc.data();
              final docId = doc.id;
              final experienceText = (exp['experience'] ?? '').toString();
              final certificateUrl = (exp['certificateUrl'] ?? '').toString();
return Card(
                margin: const EdgeInsets.only(bottom: 20),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 4,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // أيقونة الحذف
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _deleteExperience(context, docId, certificateUrl);
            },
          ),
        ),

        // النص
        Text(
          experienceText,
          style: GoogleFonts.almarai(
            fontSize: 16,
            color: RawanColors.oudBlack,
          ),
          textAlign: TextAlign.right,
        ),

        const SizedBox(height: 12),
        if (certificateUrl.isNotEmpty) ...[
          const Divider(height: 1),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  certificateUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
    

                        const SizedBox(height: 8),

 
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: const EdgeInsets.all(12),
                                  backgroundColor: Colors.black,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: InteractiveViewer(
                                      clipBehavior: Clip.none,
                                      child: Image.network(
                                        certificateUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.fullscreen, size: 18),
                            label: const Text('عرض بالحجم الكامل'),
                            style: TextButton.styleFrom(
                              foregroundColor: RawanColors.grenn,
                            ),
                          ),
                        ),
                      ],
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
