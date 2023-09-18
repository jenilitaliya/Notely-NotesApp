import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notely/CommonFiles/drawer.dart';
import 'View/home_Screen.dart';
import 'View/Authentication/login_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

final box = GetStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: theme == false ? ThemeMode.dark : ThemeMode.light,
      home: //RegistrationScreen(),
          box.read("uId") != null ? const HomeScreen() : const LogInScreen(),
    );
  }
}
