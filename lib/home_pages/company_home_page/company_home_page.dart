import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shour_alena/core/Rawan_colors.dart';
import 'package:shour_alena/home_pages/company_home_page/company_menu_page/company_menu_page.dart';
import 'package:shour_alena/signup/company_signup/company_profile_form/company_profile_form.dart';
import 'package:shour_alena/consultation/company_consultation_request_page.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  Future<DocumentSnapshot> fetchCompanyProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('companies').doc(uid).get();
  }

  Future<List<Map<String, dynamic>>> fetchCompanyReviews() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('company_reviews')
        .where('companyId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> _uploadCompanyImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final file = File(picked.path);
    final filePath =
        'companies/$uid/profile.jpg'; // داخل نفس البكت: profile-pictures

    final supabase = Supabase.instance.client;

    try {

      await supabase.storage
          .from('profile-pictures')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));


      final publicUrl = supabase.storage
          .from('profile-pictures')
          .getPublicUrl(filePath);


      await FirebaseFirestore.instance.collection('companies').doc(uid).update({
        'profileImage': publicUrl,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ تم تحديث صورة الشركة')));


      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ فشل رفع الصورة: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 244),
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompanyMenuPage()),
            );
          },
        ),
        title: Text(
          'الصفحة الرئيسية',
          style: GoogleFonts.almarai(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 248, 246, 246),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'تعديل البيانات',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompanyProfileForm()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/companySignin');
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchCompanyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('لا توجد بيانات للشركة.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final profileImage = (data['profileImage'] ?? '').toString();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'مرحباً ، ${data['name']}👋',
                    style: GoogleFonts.almarai(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

     
                Card(
                  color: RawanColors.lightgrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Stack(
                          children: [
                            ClipOval(
                              child: profileImage.isNotEmpty
                                  ? Image.network(
                                      profileImage,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.apartment,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                            ),
                           
                            
                      
                          ],
                        ),
                        const SizedBox(width: 16),
     
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '📌 المجال: ${data['industry']}',
                                  style: GoogleFonts.almarai(
                                    fontSize: 14,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '🌍 الموقع: ${data['location']}',
                                  style: GoogleFonts.almarai(
                                    fontSize: 14,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ' 📩 ${data['email']} :البريد الإلكتروني',
                                  style: GoogleFonts.almarai(
                                    fontSize: 14,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // نبذة عن الشركة
                Text(
                  ': 📝 نبذه عن الشركة',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.almarai(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  (data['description'] ?? '').toString(),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.almarai(
                    fontSize: 14,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),

                const SizedBox(height: 90),

                // التقييمات
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '⭐ التقييمات',
                    style: GoogleFonts.almarai(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchCompanyReviews(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final reviews = snapshot.data;
                    if (reviews == null || reviews.isEmpty) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '  ... لا توجد تقييمات بعد ',
                          style: GoogleFonts.almarai(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 124, 124, 124),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: reviews.map((review) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.green[700],
                            ),
                            title: Text('⭐ ${review['rating'].toString()}'),
                            subtitle: Text(
                              (review['comment'] ?? '').toString(),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 50),

                // زر طلب استشارة
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RawanColors.grenn,
                      foregroundColor: RawanColors.oudBlack,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CompanyConsultationRequestPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'طلب استشارة',
                      style: GoogleFonts.almarai(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 242, 240, 240),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
