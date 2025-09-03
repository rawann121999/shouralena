import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/consultation/Company_Sent_Request_page.dart';
import 'package:shour_alena/core/Rawan_colors.dart';
import 'package:shour_alena/home_pages/company_home_page/company_menu_page/company_change_password/company_change_password.dart';

class CompanyMenuPage extends StatelessWidget {
  const CompanyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: RawanColors.grenn,
     
        
       
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30,),
          onPressed: () {
            Navigator.pop(context); 
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
                  MaterialPageRoute(builder: (_) => const CompanyChangePassword()));
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
SizedBox(height: 25),
 ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompanySentRequestsPage(),
                ),
              );
            },
            icon: const Icon(Icons.assignment),
            label: Text(
              '  عرض طلبات الاستشارة ',
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
      ),
    );
  }
}
