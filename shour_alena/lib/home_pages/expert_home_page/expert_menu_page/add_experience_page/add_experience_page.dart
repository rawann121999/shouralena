import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shour_alena/core/Rawan_colors.dart';
import 'package:shour_alena/home_pages/expert_home_page/expert_menu_page/add_experience_page/view_experience_page/view_experience_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddExperiencePage extends StatefulWidget {
  const AddExperiencePage({super.key});

  @override
  State<AddExperiencePage> createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final TextEditingController _experienceController = TextEditingController();
  File? _certificateImage;

  Future<void> _pickCertificateImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _certificateImage = File(pickedFile.path);
        print('مسار الصورة : ${pickedFile.path}');
      });
    }
  }

  


// ...
final supabase = Supabase.instance.client;

Future<void> _submitExperience() async {
  final experienceText = _experienceController.text.trim();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (experienceText.isEmpty || _certificateImage == null || uid == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('يرجى تعبئة الخبرة وإرفاق الشهادة')),
    );
    return;
  }

  try {

    final fileName = 'certificate_${DateTime.now().millisecondsSinceEpoch}.png';
    final path = '$uid/certificates/$fileName';


    await supabase.storage
        .from('profile-pictures')
        .upload(path, _certificateImage!, fileOptions: const FileOptions(
          contentType: 'image/png',
          upsert: false,
        ));


    final publicUrl = supabase.storage
        .from('profile-pictures')
        .getPublicUrl(path);

  
    await FirebaseFirestore.instance
        .collection('retirees')
        .doc(uid)
        .collection('experiences')
        .add({
          'experience': experienceText,
          'certificateUrl': publicUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

      if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة الخبرة والشهادة بنجاح'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        
        ),

    );
    Navigator.pushReplacement(
      context, MaterialPageRoute(
        builder: (_) => const ViewExperiencesPage())
        );


    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        title: Text(
          '📋  إضافة خبرة + شهادة',
          style: GoogleFonts.almarai(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ' : تفاصيل الخبرة ',
                style: GoogleFonts.almarai(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: RawanColors.pineGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _experienceController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: '... اكتب تفاصيل الخبرة هنا ',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white30,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: RawanColors.grenn),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ': إرفاق الشهادة ',
                style: GoogleFonts.almarai(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: RawanColors.pineGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickCertificateImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: RawanColors.grenn),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white38,
                ),
                child: _certificateImage == null
                    ? const Center(
                        child: Text(
                          '  📋 اضغط لاختيار الشهادة',
                          style: TextStyle(
                            color: RawanColors.grenn,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Image.file(_certificateImage!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 70),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RawanColors.grenn,
                  foregroundColor: RawanColors.oudBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submitExperience,
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'حفظ الخبرة والشهادة',
                  style: GoogleFonts.almarai(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 242, 240, 240),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
