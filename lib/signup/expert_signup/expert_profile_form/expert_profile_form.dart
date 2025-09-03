import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shour_alena/core/rawan_colors.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_home_page.dart';

class ExpertProfileForm extends StatefulWidget {
  const ExpertProfileForm({super.key});

  @override
  State<ExpertProfileForm> createState() => _ExpertProfileFormState();
}

class _ExpertProfileFormState extends State<ExpertProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String specialization = '';
  String experienceYears = '';
  String email = '';
  String bio = '';

  File? selectedImageFile;
  String? selectedImageUrl;

  Future<void> uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final file = File(pickedFile.path);
    final filePath = 'experts/$uid/profile.jpg';
    final supabase = Supabase.instance.client;

    try {
      await supabase.storage
          .from('profile-pictures')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      final imageUrl = supabase.storage
          .from('profile-pictures')
          .getPublicUrl(filePath);

      setState(() {
        selectedImageFile = file;
        selectedImageUrl = imageUrl;
      });

      await FirebaseFirestore.instance.collection('retirees').doc(uid).update({
        'profileImage': imageUrl,
      });

      print('✅ تم رفع الصورة وتحديث الرابط');
    } catch (e) {
      print('❌ خطأ أثناء رفع الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        title: Text(
          'الملف الشخصي',
          style: GoogleFonts.almarai(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (selectedImageFile != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(selectedImageFile!),
                ),
             
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                onSaved: (val) => name = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'التخصص'),
                onSaved: (val) => specialization = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'سنوات الخبرة'),
                keyboardType: TextInputType.number,
                onSaved: (val) => experienceYears = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => email = val ?? '',
                validator: (val) =>
                    val!.contains('@') ? null : 'البريد غير صالح',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'نبذة عنك'),
                maxLines: 3,
                onSaved: (val) => bio = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
               const SizedBox(height: 50),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label:  Text("رفع صورة الملف الشخصي",
                   style: GoogleFonts.almarai(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RawanColors.grenn,
                  foregroundColor: Colors.white,
                ),
                onPressed: uploadProfileImage,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RawanColors.grenn,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection('retirees')
                          .doc(uid)
                          .set({
                            'name': name,
                            'specialization': specialization,
                            'experienceYears': experienceYears,
                            'email': email,
                            'bio': bio,
                            'createdAt': Timestamp.now(),
                            'profileImage': selectedImageUrl ?? '',
                          });

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('expert_profile_completed', true);

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExpertHomePage(),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('فشل حفظ البيانات: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'حفظ البيانات',
                  style: GoogleFonts.almarai(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
