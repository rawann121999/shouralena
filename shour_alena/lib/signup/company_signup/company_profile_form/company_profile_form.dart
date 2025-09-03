import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shour_alena/core/rawan_colors.dart';
import 'package:shour_alena/home_pages/company_home_page/company_home_page.dart';

class CompanyProfileForm extends StatefulWidget {
  const CompanyProfileForm({super.key});

  @override
  State<CompanyProfileForm> createState() => _CompanyProfileFormState();
}

class _CompanyProfileFormState extends State<CompanyProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String industry = 'الإدارة العامة';
  String description = '';
  String location = '';
  String email = '';

  final industries = [
    'الإدارة العامة',
    'تكنولوجيا',
    'تعليم',
    'تجارة',
    'صحة',
    'مالية',
    'قانون',
    'أخرى',
  ];

  Future<void> saveCompanyDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_name', name);
    await prefs.setString('company_industry', industry);
    await prefs.setString('company_description', description);
    await prefs.setString('company_location', location);
    await prefs.setString('company_email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.grenn,
        title: Text('معلومات الشركة',
         style: GoogleFonts.almarai(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 248, 246, 246),
        ),
        ),
        
        
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الشركة'),
                onSaved: (val) => name = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: industry,
                items: industries
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (val) => setState(() => industry = val ?? industry),
                decoration: const InputDecoration(labelText: 'المجال'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'نبذة عن الشركة'),
                maxLines: 3,
                onSaved: (val) => description = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'المدينة / الدولة',
                ),
                onSaved: (val) => location = val ?? '',
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                ),
                onSaved: (val) => email = val ?? '',
                validator: (val) => val!.contains('@') ? null : 'بريد غير صالح',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                      backgroundColor:
                          RawanColors.grenn, 
                      foregroundColor: RawanColors.oudBlack, 
                      
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
                      await saveCompanyDataLocally(); 
                      print('✅ تم حفظ البيانات ');

             
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        final uid = user.uid;

                        await FirebaseFirestore.instance
                            .collection('companies')
                            .doc(uid)
                            .set({
                              'name': name,
                              'industry': industry,
                              'description': description,
                              'location': location,
                              'email': email,
                              'createdAt': Timestamp.now(),
                            })
                            .timeout(const Duration(seconds: 8));

                        print('✅ تم الحفظ في Firebase');
                      }

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CompanyHomePage(),
                          ),
                        );
                      }
                    } catch (e) {
                      print(
                        '⚠️ تم حفظ البيانات محليًا، لكن فشل حفظ Firebase: $e',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم حفظ البيانات محليًا، لكن لم تُرسل للسيرفر',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text('حفظ البيانات',
                 style: GoogleFonts.almarai(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 243, 241, 241),
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
