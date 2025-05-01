import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static String? roomCode;

  //Luu SharedPreferences
  static Future<void> saveRoomCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('roomCode', code);
    roomCode = code;
  }

  static Future<void> loadRoomCode() async {
    final prefs = await SharedPreferences.getInstance();
    roomCode = prefs.getString('roomCode');
  }

  static Future<void> clearRoomCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('roomCode');
    roomCode = null;
  }
}
