import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kbc_quiz_app/views/login.dart';
import 'package:kbc_quiz_app/views/home.dart';
import 'package:kbc_quiz_app/services/localDB.dart';
import 'package:kbc_quiz_app/services/firedb.dart';
import 'package:kbc_quiz_app/views/profile.dart';

class SideNav extends StatelessWidget {
  dynamic name, money, rank, level, proURL;
  SideNav(this.name, this.money, this.rank, this.level, this.proURL);
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Material(
        color: const Color.fromRGBO(128, 0, 128, 1),
        child: ListView(
          // padding:  EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
              child: Row(children: [
                CircleAvatar(radius: 30, backgroundImage: NetworkImage(proURL)),
                const SizedBox(width: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name , style: const TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Text("Rs.$money" , style: const TextStyle(color: Colors.white , fontSize: 15),),

                    ],
                  ),
                )
              ],),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Leaderboard - $rank th Rank" , style: const TextStyle(color: Colors.white ,fontSize: 19,fontWeight: FontWeight.bold,))
              ),
            ),

            const SizedBox(height: 24,),
            const Divider(thickness: 1,indent: 10,endIndent: 10,),
            const SizedBox(height: 24,),
            listItem(
                context: context,
                path:  MaterialPageRoute(builder: (BuildContext context) => Home()),
                label : "DAILY QUIZ",
                icon : Icons.quiz
            ),
            listItem(
                context: context,
                path:  MaterialPageRoute(builder: (BuildContext context) => Home()),
                label : "Leaderboard",
                icon : Icons.leaderboard
            ),
            listItem(
                context: context,
                path:  MaterialPageRoute(builder: (BuildContext context) => Home()),
                label : "How To Use",
                icon : Icons.question_answer
            ),
            listItem(
                context: context,
                path:  MaterialPageRoute(builder: (BuildContext context) => Home()),
                label : "About Us",
                icon : Icons.face
            ),
            ListTile(
              leading: const Icon(Icons.logout,color: Colors.white,),
              hoverColor: Colors.white60,
              title: const Text("Log Out",style: TextStyle(color: Colors.white),),
              onTap: () async {
                await LocalDB().saveLoginData(false);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget listItem({
    required String label,
    required IconData icon,
    required BuildContext context,
    required MaterialPageRoute path
  }){
    final color = Colors.white;
    final hovercolor = Colors.white60;

    return ListTile(
      leading: Icon(icon , color: color,),
      hoverColor: hovercolor,
      title: Text(label , style: TextStyle(color: color)),
      onTap: () async {
        Navigator.pushReplacement(context, path);
      },
    );
  }


}