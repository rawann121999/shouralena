import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/rawan_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
             backgroundColor: const Color.fromARGB(255, 252, 254, 254),
      body: Column(
       
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 100),
          Center(
    
            child: Text(
              "مرحبًا بك في تطبيق شُور علينا",
              style: GoogleFonts.almarai(
                fontSize: 25,
                fontWeight: FontWeight.bold,
      color: Color(0xFF1B1B1B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
               
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Text(
              "شُور علينا هي منصة استشارية متخصصة، تهدف إلى ربط أصحاب الشركات الناشئة بخبرات المتقاعدين و المتقاعدات ، من خلال تقديم استشارات عملية مبنية على تجارب واقعية في مختلف المجالات.",

              style: GoogleFonts.almarai(
                fontSize: 18,

                  color: Color(0xFF1B1B1B),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46.0),
            child: Text(
              "✨نؤمن بأن التقاعد لا يعني نهاية العطاء✨",
              style: GoogleFonts.almarai(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46.0),
            child: Text(
              "من خلال هذا التطبيق يمكن للشركات الناشئة استشارة اشخاص لديهم خبرة حقيقة والاستفادة من تجارب طويلة في ميادين العمل💡"
              " لا تبدأ من الصفر ... شُور علينا يوصلك بخبرة سنين👍 ",
              style: GoogleFonts.almarai(
                fontSize: 18,

                color: Color(0xFF1B1B1B),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46.0),
            child: Text(
              " و يمكن لكل المتقاعدين/المتقاعدات مشاركة خبرتهم المهنية الطويلة مقابل رمزي لكل استشارة📞"
              " استثمر خبرتك ، وخل تجربتك مصدر دخل جديد !😉",
              style: GoogleFonts.almarai(
                fontSize: 18,

                color: Color(0xFF1B1B1B),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          SizedBox(height: 60),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر الشركة
              SizedBox(
                width: 190,
                height: 60,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/companySignin');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: RawanColors.oudBlack, width: 1),
                   
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),

                  child: Text(
                    "للشركات الناشئة",

                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,

                      color: RawanColors.oudBlack,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // زر المتقاعد
              SizedBox(
                width: 190,
                height: 60,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/expertSignin');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: RawanColors.oudBlack, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "للمتقاعدين/المتقاعدات",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,

                      color: RawanColors.oudBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
