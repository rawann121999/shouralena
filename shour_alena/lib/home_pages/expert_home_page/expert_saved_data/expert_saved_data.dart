import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_home_page.dart';
import 'package:shour_alena/signup/expert_signup/expert_profile_form/expert_profile_form.dart';

class ExpertSavedDataPage extends StatefulWidget {
  const ExpertSavedDataPage({super.key});

  @override
  State<ExpertSavedDataPage> createState() => _ExpertSavedDataPageState();
}

class _ExpertSavedDataPageState extends State<ExpertSavedDataPage> {
  @override
  void initState() {
    super.initState();
    checkIfProfileCompleted();
  }

  Future<void> checkIfProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('expert_profile_completed') ?? false;

    if (!mounted) return;

    if (isCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExpertHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExpertProfileForm()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
