import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shour_alena/core/rawan_colors.dart';

class CompanyConsultationRequestPage extends StatefulWidget {
  const CompanyConsultationRequestPage({super.key});

  @override
  State<CompanyConsultationRequestPage> createState() =>
      _CompanyConsultationRequestPageState();
}

class _CompanyConsultationRequestPageState
    extends State<CompanyConsultationRequestPage> {
  final _formKey = GlobalKey<FormState>();

  String industry = 'الإدارة العامة';
  String title = '';
  String requestDetails = '';
  String budget = '';
  bool _isSending = false;

  final specializations = const [
    'الإدارة العامة',
    'تكنولوجيا',
    'تعليم',
    'تجارة',
    'صحة',
    'مالية',
    'قانون',
    'أخرى',
  ];

  Future<String> _getCompanyName(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('companies')
        .doc(uid)
        .get();
    return (doc.data()?['name'] ?? 'شركة').toString();
  }

  Future<void> _sendRequest() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSending = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      print('🔥 start send request');
      await FirebaseFirestore.instance.collection('consultation_requests').add({
        'companyId': uid,
        'companyName': await _getCompanyName(uid),
        'specialization': industry,
        'title': title,
        'requestDetails': requestDetails,
        'budget': budget,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'expertId': null,
      });
      print('✅ end send request');

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب بنجاح')));
      Navigator.pop(context);
    } catch (e) {
      print('❌ Firestore error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل الإرسال: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RawanColors.pineGreen,
        title: Text(
          'طلب استشارة',
          style: GoogleFonts.almarai(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: industry,
                items: specializations
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => industry = val ?? industry),
                decoration: const InputDecoration(labelText: 'التخصص'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'عنوان الاستشارة'),
                onSaved: (v) => title = v?.trim() ?? '',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'وصف الاستشارة'),
                maxLines: 4,
                onSaved: (v) => requestDetails = v?.trim() ?? '',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الميزانية المقترحة (اختياري)',
                ),
                onSaved: (v) => budget = v?.trim() ?? '',
              ),
              const SizedBox(height: 24),
              _isSending
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: RawanColors.grenn,
                      ),
                      onPressed: _sendRequest,
                      child: Text(
                        'إرسال الطلب',
                        style: GoogleFonts.almarai(
                          fontSize: 17,
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




