import 'package:cloud_firestore/cloud_firestore.dart';

class HomeFB{

  static Future<List<Map<String, dynamic>>> getquizzes() async {
    List<Map<String, dynamic>> allquiz=[];
    await FirebaseFirestore.instance.collection("quizzes").get().then((querySnapshot) {
      querySnapshot.docs.forEach((quiz) {
        Map<String, dynamic> myquiz=quiz.data();
        myquiz["quizid"]=quiz.reference.id;
        allquiz.add(myquiz);
      });
    });
    return allquiz;
  }
}


