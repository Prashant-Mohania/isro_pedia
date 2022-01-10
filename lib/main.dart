import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isro_pedia/screens/AuthPage/signin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ISRO PEDIA",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SignIn(),
    );
  }
}
