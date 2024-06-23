import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kbc_quiz_app/services/localDB.dart';
import 'package:kbc_quiz_app/widgets/sidenavbar.dart';

class FireDB{
  dynamic username="NA";
  dynamic money="NA";
  dynamic level="NA";
  dynamic rank="NA";
  dynamic proURL="NA";
  dynamic user;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  

   createNewUser(String name, String email, String photoURL, String uid) async{
    final User? current_user=_auth.currentUser;

    if(await getUser()){
      print("USER ALREADY EXISTS");

    }else{
      return await FirebaseFirestore.instance.collection("users").doc(current_user!.uid).set({
        "name" : name,
        "email" : email,
        "photoURL" : photoURL,
        "uid" : uid,
        "money" : "55555",
        "level" : "0",
        "rank" : "--"
      }).then((value) async {
        print("User Registered Successfully");
        await LocalDB().saveUserID(current_user.uid);
        await LocalDB().saveUserName(current_user.displayName!);
        await LocalDB().saveLevel("0");
        await LocalDB.saveMoney("Rs.0.0");
        await LocalDB.saveRank("--");
        await LocalDB().saveProURL(current_user.photoURL!);
      }

      );
    }
  }
  Future<bool> getUser() async {
     try {
       final User? current_user = _auth.currentUser;
       await FirebaseFirestore.instance.collection("users").doc(
           current_user?.uid).get().then((value) async
       {
         user = value.data();
         print(user);
       });
       if (user.toString() == "null") {
         return false;
       }
       else {
         username = user["name"];
         money = user["money"];
         level = user["level"];
         rank = user["rank"];
         proURL = user["photoURL"];
         return true;
       }
     }catch(e){
       print(e);
       return false;
     }
  }
  Future<bool> quizunlockstatus(String quizid) async {
     bool unlocked=false;
     final User? current_user = _auth.currentUser;
    return await FirebaseFirestore.instance.collection("users").doc(current_user?.uid).collection("unlocked_quizzes").doc(quizid).get().then((value) {
      unlocked=value.data().toString()!="null";
      return unlocked;
      });
  }
  Future<bool> quizbuy(String quizid, int quizprice) async {
     bool haveEnoughMoney=false;
     final User? current_user = _auth.currentUser;
     await FirebaseFirestore.instance.collection("users").doc(current_user?.uid).get().then((value) {
       haveEnoughMoney= quizprice<=int.parse(value.data()!["money"]);
     });
     if(haveEnoughMoney){
       await FirebaseFirestore.instance.collection("users").doc(current_user?.uid).collection("unlocked_quizzes").doc(quizid).set({
         "unlocked_time": DateTime.now()
       });
       print("Quiz Is Unlocked");
       return true;
     }
     else{
       return false;
     }
  }
  updateAmount(int amount) async {
     if(amount!=2500){
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance.collection("users")
        .doc(current_user?.uid)
        .get()
        .then((value) async {
      await FirebaseFirestore.instance.collection("users").doc(
          current_user?.uid).update(
          {"money": (int.parse(value.data()?["money"]) + amount).toString()}
      );
      await LocalDB.saveMoney((int.parse(value.data()?["money"]) + amount).toString());
    });
  }
  }
  updateRank(int rank) async {
      final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance.collection("users").doc(
            current_user?.uid).update(
            {"rank" : rank.toString()}
        );
        await LocalDB.saveRank(rank.toString());
  }
}
class QuizCreator{
    static Future<Map> genquestion(String quizid, String queMoney) async {
      late Map queData;
      await FirebaseFirestore.instance.collection("quizzes").doc(quizid).collection("questions").where("money",isEqualTo: queMoney).get().then((value) {
        final _random=new Random();
        queData=value.docs.elementAt(_random.nextInt(value.docs.length)).data();
      });
      return queData;
    }
}

