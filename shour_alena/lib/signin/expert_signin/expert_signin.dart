
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/Rawan_colors.dart';

class ExpertSignin extends StatefulWidget {
  @override
  _ExpertSigninState createState() => _ExpertSigninState();
}

class _ExpertSigninState extends State<ExpertSignin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      Navigator.pushReplacementNamed(context,'/ExpertHomePage');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
   
      appBar: 
      AppBar(
         backgroundColor: RawanColors.grenn,
      title: Text(" 🔐 تسجيل الدخول ",
      style: GoogleFonts.almarai(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 252, 250, 250),
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

           child:  Text(' 🕊️ عودًا حميدًا لعطاء جديد ',
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
              decoration: InputDecoration(labelText: "الإيميل",
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),

              
              ),
           
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "كلمة المرور",
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
              child: Text("تسجيل الدخول",
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
                     
                        Navigator.pushNamed(context, "/ExpertSignup");
                      }
                          )
              

                ]
                        )
            ),
          ]
            ),
        ),
      );
  }
}
