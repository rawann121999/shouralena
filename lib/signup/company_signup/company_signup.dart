import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/Rawan_colors.dart';
import 'package:shour_alena/signin/company_signin/company_signin.dart';

class CompanySignup extends StatefulWidget {
  @override
  _CompanySignupState createState() => _CompanySignupState();
}

class _CompanySignupState extends State<CompanySignup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isCreating = false;

  Future<void> signUpWithEmail() async {
    setState(() => isCreating = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user?.uid;
      print("✅ تم إنشاء الحساب - UID: \$uid");

    
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CompanySignin()),
      );
    } catch (e) {
      print("❌ خطأ في إنشاء الحساب: \$e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل إنشاء الحساب: \${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isCreating = false);
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
            color: const Color.fromARGB(255, 249, 247, 247),
          ),
        ),
        backgroundColor: RawanColors.grenn,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                '✨ نورتنا، خلينا نبدأ مع بعض',
                textAlign: TextAlign.center,
                style: GoogleFonts.almarai(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "الإيميل",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "كلمة المرور",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),

             ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                backgroundColor: RawanColors.grenn,
              ),


              onPressed: isCreating ? null : signUpWithEmail,
              child: isCreating
                  ? const CircularProgressIndicator()
                  : Text(
                      "إنشاء حساب",
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 247, 245, 245),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
