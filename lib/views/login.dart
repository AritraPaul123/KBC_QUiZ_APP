import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:kbc_quiz_app/services/firedb.dart';
import '../services/localDB.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kbc_quiz_app/services/internetcon.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:kbc_quiz_app/services/auth.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  signout() async {
    await LocalDB().saveLoginData(false);
  }
  void initState(){
    // TODO: implement initState
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      showSimpleNotification(
          connected ? Text("Connected To Internet") : Text("No Internet"),
          background: Colors.green);
    });
    // if(widget.logout_val==true){
    //     signout();
    // }
  }
  Future<User?> _handleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential authResult =
        await _auth.signInWithCredential(credential);
        User? user = authResult.user;
        return user;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<String> signOut() async
  {
    await googleSignIn.signOut();
    await _auth.signOut();
    // await LocalDB().saveUserID("null");
    print("SUCCESS");
    return "SUCCESS";
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/kbc.png"),
          SizedBox(
            height: 35,
          ),
          Text("Welcome \n To,KBC Quiz App",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
            height: 12,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
            ),
            onPressed: () async {
              User? user = await _handleSignIn();
                if (user != null) {
                  print('Signed in: ${user.displayName}');
                  await LocalDB().saveLoginData(true);
                  await FireDB().createNewUser(user.displayName.toString(), user.email.toString(), user.photoURL.toString(), user.uid.toString());
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));

                } else {
                  print('Sign in failed');
                }
            },
            child:const Text(
              "Continue With Google",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,),
            onPressed: () async {
            await signOut();
          },
            child:const Text("Sign Out",style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "By continuing, you agree with our terms and conditions.",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}

