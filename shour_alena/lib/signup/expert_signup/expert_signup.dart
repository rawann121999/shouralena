
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/Rawan_colors.dart';

class ExpertSignup extends StatefulWidget {
  @override
  _ExpertSignupState createState() => _ExpertSignupState();
}

class _ExpertSignupState extends State<ExpertSignup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUpWithEmail() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, '/ExpertHomePage');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إنشاء الحساب: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 243, 245, 245),
      appBar: AppBar(
        title: Text(
          "📝 إنشاء حساب جديد",
          style: GoogleFonts.almarai(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 248, 245, 245),
          ),
        ),
              backgroundColor: RawanColors.grenn,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                '✨ نورتنا، خلينا نبدأ مع بعض',
                textAlign: TextAlign.center,
                style: GoogleFonts.almarai(
                  fontSize: 25,
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
                prefixIcon: Icon(Icons.lock),
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

              onPressed: signUpWithEmail,
              child: Text(
                "إنشاء حساب",
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 246, 240, 240),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
