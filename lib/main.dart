import 'package:dummy1/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs!.setString('token', token);
  }

  static Future<String?> getToken() async {
    return _prefs!.getString('token');
  }

  static Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    await _prefs!.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool?> getIsLoggedIn() async {
    return _prefs!.getBool('isLoggedIn');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool?>(
        future: MySharedPreferences.getIsLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            return WelcomeScreen(isLoggedIn: isLoggedIn);
          }
        },
      ),
    );
  }
}
