import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/consultation/expert_Consultation_Request_page.dart';
import 'package:shour_alena/core/rawan_colors.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_menu_page/add_experience_page/view_experience_page/view_experience_page.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_menu_page/expert_menu_page.dart';
import 'package:shour_alena/signup/expert_signup/expert_profile_form/expert_profile_form.dart';

class ExpertHomePage extends StatefulWidget {
  const ExpertHomePage({super.key});

  @override
  State<ExpertHomePage> createState() => _ExpertHomePageState();
}

class _ExpertHomePageState extends State<ExpertHomePage> {
  Future<DocumentSnapshot> fetchExpertProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('retirees').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExpertMenuPage()),
            );
          },
        ),
        title: Text(
          'الصفحة الرئيسية',
          style: GoogleFonts.almarai(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                MaterialPageRoute(builder: (_) => const ExpertProfileForm()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/expertSignin');
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchExpertProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' ... لا توجد بيانات ',
                    style: GoogleFonts.almarai(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 30),
                Text(
                  'مرحبًا، ${data['name']} 👋',
                  style: GoogleFonts.almarai(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B1B1B),
                  ),
                  textAlign: TextAlign.right,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child:
                                  data['profileImage'] != null &&
                                      data['profileImage'].toString().isNotEmpty
                                  ? Image.network(
                                      data['profileImage'],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '📌 التخصص: ${data['specialization']}',
                                      style: GoogleFonts.almarai(
                                        fontSize: 15,
                                        color: const Color(0xFF1B1B1B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '📅 سنوات الخبرة: ${data['experienceYears']}',
                                      style: GoogleFonts.almarai(
                                        fontSize: 15,
                                        color: const Color(0xFF1B1B1B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '📧 ${data['email']} : البريد الإلكتروني',
                                      style: GoogleFonts.almarai(
                                        fontSize: 15,
                                        color: const Color(0xFF1B1B1B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ViewExperiencesPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RawanColors.grenn,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.visibility, size: 20),
                            label: Text(
                              'عرض الخبرات',
                              style: GoogleFonts.almarai(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  '📝 : نبذه عنك ',
                  style: GoogleFonts.almarai(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B1B1B),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                Text(
                  data['bio'] ?? '',
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    color: const Color(0xFF1B1B1B),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 70),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RawanColors.grenn,
                    foregroundColor: RawanColors.oudBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExpertConsultationRequestsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.work_outline, color: Colors.white),
                  label: Text(
                    'عرض الطلبات الواردة',
                    style: GoogleFonts.almarai(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 242, 240, 240),
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
