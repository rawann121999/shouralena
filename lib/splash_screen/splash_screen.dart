import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    player.play(AssetSource('sounds/logo.mp3'));

    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: SplashContent()),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/images/logo.jpg',
              height: 230,
              width: 230,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "شُور علينا",

            style: GoogleFonts.almarai(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1B),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "ما نعطيك كلام نعطيك تجربة",

            style: GoogleFonts.almarai(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1B),
            ),
          ),
        ],
      ),
    );
  }
}
