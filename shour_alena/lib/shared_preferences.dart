import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();
  late SharedPreferences _prefs;

  SharedPrefsHelper._internal();

  factory SharedPrefsHelper() => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<void> clear() => _prefs.clear();


  Future<void> saveCompanyData({
    required String name,
    required String industry,
    required String description,
    required String location,
    required String email,
  }) async {
    await _prefs.setString('company_name', name);
    await _prefs.setString('company_industry', industry);
    await _prefs.setString('company_description', description);
    await _prefs.setString('company_location', location);
    await _prefs.setString('company_email', email);
  }


  Map<String, String?> loadCompanyData() {
    return {
      'name': _prefs.getString('company_name'),
      'industry': _prefs.getString('company_industry'),
      'description': _prefs.getString('company_description'),
      'location': _prefs.getString('company_location'),
      'email': _prefs.getString('company_email'),
    };
  }
}
