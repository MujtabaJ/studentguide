import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class AppStore {
  AppStore(this._prefs);

  static const _key = 'student_guide_v1';
  final SharedPreferences _prefs;

  AppData load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const AppData();
    try {
      return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const AppData();
    }
  }

  Future<void> save(AppData data) async {
    await _prefs.setString(_key, jsonEncode(data.toJson()));
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }

  String exportJson(AppData data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data.toJson());
  }

  AppData importJson(String raw) {
    return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
