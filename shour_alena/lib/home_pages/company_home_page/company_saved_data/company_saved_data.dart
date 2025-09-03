import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanySavedDataPage extends StatefulWidget {
  const CompanySavedDataPage({super.key});

  @override
  State<CompanySavedDataPage> createState() => _CompanySavedDataPageState();
}

class _CompanySavedDataPageState extends State<CompanySavedDataPage> {
  Map<String, String?> companyData = {
    'name': '',
    'industry': '',
    'description': '',
    'location': '',
    'email': '',
  };

  @override
  void initState() {
    super.initState();
    loadCompanyData();
  }

  Future<void> loadCompanyData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      companyData = {
        'name': prefs.getString('company_name'),
        'industry': prefs.getString('company_industry'),
        'description': prefs.getString('company_description'),
        'location': prefs.getString('company_location'),
        'email': prefs.getString('company_email'),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بيانات الشركة المحفوظة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('📝 اسم الشركة: ${companyData['name'] ?? '—'}'),
            const SizedBox(height: 8),
            Text('🏢 المجال: ${companyData['industry'] ?? '—'}'),
            const SizedBox(height: 8),
            Text('📄 النبذة: ${companyData['description'] ?? '—'}'),
            const SizedBox(height: 8),
            Text('📍 الموقع: ${companyData['location'] ?? '—'}'),
            const SizedBox(height: 8),
            Text('✉️ البريد الإلكتروني: ${companyData['email'] ?? '—'}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loadCompanyData,
              child: const Text('🔄 تحديث البيانات'),
            ),
          ],
        ),
      ),
    );
  }
}
