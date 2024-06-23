import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:kbc_quiz_app/services/firedb.dart';
import 'package:kbc_quiz_app/services/home_fb.dart';
import 'package:kbc_quiz_app/services/localDB.dart';
import 'package:kbc_quiz_app/views/quiz_intro.dart';
import 'package:kbc_quiz_app/widgets/lifeline.dart';

import '../widgets/sidenavbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Map<String ,dynamic> topPlayer;
  bool isloading=true;
   List quizzes=[];
  dynamic name="NA", money="NA", rank="NA", level="NA", proURL="NA";
  Future <void> sidenavinfo() async {
    FireDB instance = FireDB();
    await instance.getUser();
    // await LocalDB.getRank().then((value) {
    //   setState(() {
    //     rank=jsonDecode(value.toString());
    //   });
    // });
    setState(() {
      name = instance.username;
      money = instance.money;
      rank= instance.rank;
      proURL = instance.proURL;
    });
  }
  getTopPlayer() async {
    await FirebaseFirestore.instance.collection("users").orderBy("money",descending: true).get().then((value) {
      setState(() {
        topPlayer=value.docs.elementAt(0).data();
      });
    });
  }
  getquiz() async{
    await HomeFB.getquizzes().then((returned_quizzes) {
      setState(() {
        quizzes=returned_quizzes;
        isloading=false;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sidenavinfo();
    getquiz();
    getTopPlayer();
  }
  @override

  Widget build(BuildContext context) {
    return isloading ? const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("KBC QUIZ APP"),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    ) : RefreshIndicator(
      onRefresh: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
      },
      child: Scaffold(
        drawer: SideNav(name, money, level, rank, proURL),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("KBC- Quiz App",style: TextStyle(fontWeight: FontWeight.w500),),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 2000,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 1),
              child: Column(
                children: [
                  CarouselSlider(
                      items: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: NetworkImage(
                                  "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                ),
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                      options: CarouselOptions(
                          height: 220,
                          aspectRatio: 16 / 9,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          scrollDirection: Axis.horizontal)),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(backgroundColor: Colors.purple,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.red,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.greenAccent,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.orange,radius: 35,)
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    child: Image.network(
                                        "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(width: 5),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    child: Image.network(
                                        "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    child: Image.network(
                                        "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(width: 5),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    child: Image.network(
                                        "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Stack(
                        children: [
                          Card(
                            elevation: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                               height: 120,
                               width: MediaQuery.of(context).size.width,
                              child: Image.network(fit: BoxFit.cover,
                                  "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Richest Players In The World",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                        const SizedBox(height: 19),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(topPlayer["photoURL"]),radius: 45,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topPlayer["name"].toString().length > 18 ? "${topPlayer["name"].toString().substring(0,18)}..." : topPlayer["name"],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                                Text("Player ID:${topPlayer["uid"].toString().substring(0,10)}",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                                Text("Rs.${topPlayer["money"]}",style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child:const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Unlock New Quizzes",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>QIntro(quizzes[0]["about_quiz"],quizzes[0]["duration"],quizzes[0]["quiz_thumbnail"],quizzes[0]["quiz_name"],quizzes[0]["topic"],quizzes[0]["quizid"],quizzes[0]["quiz_price"])));
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      child: Image.network(quizzes[0]["quiz_thumbnail"]),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(width: 5),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>QIntro(quizzes[1]["about_quiz"],quizzes[1]["duration"],quizzes[1]["quiz_thumbnail"],quizzes[1]["quiz_name"],quizzes[1]["topic"],quizzes[1]["quizid"],quizzes[1]["quiz_price"])));
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      child: Image.network(quizzes[1]["quiz_thumbnail"]),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    child: Image.network(
                                        "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(width: 5),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    child: Image.network(
                                        "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Stack(
                        children: [
                          Card(
                            elevation: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(fit: BoxFit.cover,
                                  "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 23),
                  CarouselSlider(
                      items: [
                        Container(
                          margin:const EdgeInsets.symmetric(horizontal: 10),
                          decoration:const BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  "https://plus.unsplash.com/premium_photo-1706625669518-664f071e02af?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                ),
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                      options: CarouselOptions(
                          height: 200,
                          aspectRatio: 16 / 9,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          scrollDirection: Axis.horizontal)),
                  const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(backgroundColor: Colors.purple,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.red,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.greenAccent,radius: 35,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(backgroundColor: Colors.purple,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.red,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.greenAccent,radius: 35,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(backgroundColor: Colors.purple,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.red,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.greenAccent,radius: 35,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(backgroundColor: Colors.purple,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.red,radius: 35,),
                        CircleAvatar(backgroundColor: Colors.greenAccent,radius: 35,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("v1.0 Made By Aritra Paul",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
