import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/Rawan_colors.dart';
import 'package:shour_alena/home_pages/company_home_page/company_home_page.dart';
import 'package:shour_alena/signup/company_signup/company_profile_form/company_profile_form.dart';

class CompanySignin extends StatefulWidget {
  @override
  _CompanySigninState createState() => _CompanySigninState();
}

class _CompanySigninState extends State<CompanySignin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInWithEmail() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final String uid = credential.user!.uid;
      print('📌 تسجيل دخول بـ UID: \$uid');

    
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('companies')
          .doc(uid)
          .get();

      int retryCount = 0;
      while (retryCount < 3 && !doc.exists) {
        print(
          '🕐 المحاولة رقم: \${retryCount + 1} - لم يتم العثور على البيانات بعد',
        );
        await Future.delayed(const Duration(seconds: 2));
        doc = await FirebaseFirestore.instance
            .collection('companies')
            .doc(uid)
            .get();
        retryCount++;
      }

      if (!mounted) return;

      if (doc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompanyHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompanyProfileForm()),
        );
      }
    } catch (e) {
      print("❌ خطأ في تسجيل الدخول: \$e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في تسجيل الدخول: \${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 240, 239),
      appBar: AppBar(
         automaticallyImplyLeading:true,
       
         
        backgroundColor:RawanColors.grenn,
        title: Text(
          " 🔐 تسجيل الدخول ",
          style: GoogleFonts.almarai(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 248, 246, 246),
          ),
        ),
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 140),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                ' 🎯 مرحباً بروّاد الأعمال وصانعي التغيير  ',
                textAlign: TextAlign.center,
                style: GoogleFonts.almarai(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1B1B),
                ),
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "الإيميل",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "كلمة المرور",
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
        
            SizedBox(height: 40),
           ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                backgroundColor: RawanColors.grenn,
              ),
        
              onPressed: signInWithEmail,
              child: Text(
                "تسجيل الدخول",
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 250, 246, 246),
                ),
              ),
            ),
            SizedBox(height: 40),
            RichText(
              text: TextSpan(
                text: 'ليس لديك حساب؟ ',
                style: GoogleFonts.almarai(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'اضغط هنا',
                    style: TextStyle(
                      color: RawanColors.pineGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, "/CompanySignup");
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
