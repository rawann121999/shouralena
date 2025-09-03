import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/Rawan_colors.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_menu_page/add_experience_page/add_experience_page.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_menu_page/change_password_page/change_password_page.dart';

class ExpertMenuPage extends StatelessWidget {
  const ExpertMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: RawanColors.grenn,
     
        
       
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30,),
          onPressed: () {
            Navigator.pop(context); // يرجع للهوم بيج
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: 50),
ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
              },
              icon: const Icon(Icons.lock),
              label:  Text('تغيير كلمة المرور',
              style: GoogleFonts.almarai(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              
              ),
              
              style: ElevatedButton.styleFrom(
                backgroundColor: RawanColors.grenn,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
),
         
          const SizedBox(height: 30),

          

ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExperiencePage()),
    );
  },
  icon: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.assessment, size: 20),
      SizedBox(width: 5),
      Icon(Icons.school, size: 20),
    ],
  ),
  label: Text(
    'إضافة الخبرات + الشهادات',
    style: GoogleFonts.almarai(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: RawanColors.grenn,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50),
  ),
),
        ]
      )
    );
  }
}
