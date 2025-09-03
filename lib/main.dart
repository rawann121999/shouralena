import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shour_alena/Splash_screen/splash_screen.dart';
import 'package:shour_alena/firebase_options.dart';
import 'package:shour_alena/home_pages/company_home_page/company_home_page.dart';
import 'package:shour_alena/home_pages/company_home_page/company_saved_data/company_saved_data.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_home_page.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_saved_data/expert_saved_data.dart';
import 'package:shour_alena/signin/company_signin/company_signin.dart';
import 'package:shour_alena/signin/expert_signin/expert_signin.dart';
import 'package:shour_alena/signup/company_signup/company_profile_form/company_profile_form.dart';
import 'package:shour_alena/signup/company_signup/company_signup.dart';
import 'package:shour_alena/signup/expert_signup/expert_signup.dart';
import 'package:shour_alena/welcome_screen/welcome_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferences.getInstance(); 
  await Supabase.initialize(
  url: 'https://mhjdcrdcnmjkwpqhuzyu.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1oamRjcmRjbm1qa3dwcWh1enl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzNDI4OTYsImV4cCI6MjA2OTkxODg5Nn0.qpsIgOVcIUhGae5sIVRa4DqSWSCLZh7Wl0ip_oUReGY',

  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/companySignin': (context) =>  CompanySignin(),
        '/expertSignin': (context) =>   ExpertSignin(),
       '/ExpertHomePage' :(context) =>  ExpertHomePage(),
       '/ExpertSignup' : (context) =>  ExpertSignup(),
       '/CompanySignup' :(context) => CompanySignup(),
       '/CompanyProfileForm': (context) =>CompanyProfileForm(),
         '/CompanyHomepage': (context) => CompanyHomePage(),
         '/CompanySavedData': (context) => const CompanySavedDataPage(),
         '/ExpertSavedDataPage': (context) => const ExpertSavedDataPage(),





      },
    );
  }
}
