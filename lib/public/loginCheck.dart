
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

Future<bool> loginCheck() async {
  String? value = await storage.read(key: 'login');
  return value != null;
}