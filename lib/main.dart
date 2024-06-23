import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz_app/services/localDB.dart';
import 'package:kbc_quiz_app/views/firebase_options.dart';
import 'package:kbc_quiz_app/views/losing.dart';
import 'package:kbc_quiz_app/views/profile.dart';
import 'package:kbc_quiz_app/views/quiz_intro.dart';
import 'package:kbc_quiz_app/views/quiz_ques.dart';
import 'package:kbc_quiz_app/views/winner.dart';
import 'package:overlay_support/overlay_support.dart';
import 'views/login.dart';
import 'views/home.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn= false;

  getLoggedInState() async {
    await LocalDB().getLoginData().then((value) {
        setState(() {
          isLoggedIn=jsonDecode(value!.toString());
        });
    }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isLoggedIn? const Home(): Login()),
    );
  }
}
