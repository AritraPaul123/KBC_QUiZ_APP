import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kbc_quiz_app/services/Questionmodel.dart';
import 'package:kbc_quiz_app/services/firedb.dart';
import 'package:kbc_quiz_app/services/localDB.dart';
import 'package:kbc_quiz_app/views/home.dart';
import 'package:kbc_quiz_app/views/losing.dart';
import 'package:kbc_quiz_app/views/winner.dart';
import 'package:overlay_support/overlay_support.dart';

import '../widgets/lifeline.dart';

class Q_question extends StatefulWidget {
  late String quizid, quizMoney;
  Q_question(this.quizid, this.quizMoney);
  @override
  State<Q_question> createState() => _Q_questionState();
}

class _Q_questionState extends State<Q_question> {
  @override
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final player4=AudioPlayer();
  final player=AudioPlayer();
  late int second=100, maxseconds=100;
  Timer? timer;
  QuestionModel questionModel=new QuestionModel();
  late List Options=[];
  bool opt1lock=false; bool opt2lock=false; bool opt3lock=false; bool opt4lock=false;
  genQue() async{
    await QuizCreator.genquestion(widget.quizid, widget.quizMoney).then((queData) {
      setState(() {
        questionModel.question=queData["question"];
        questionModel.AnsYTLink=queData["YTLink"];
        questionModel.correctAnswer=queData["correctAns"];
        Options=[queData["opt1"],queData["opt2"],queData["opt3"],queData["opt4"]];
        Options.shuffle();
        questionModel.option1=Options[0];
        questionModel.option2=Options[1];
        questionModel.option3=Options[2];
        questionModel.option4=Options[3];
        second=int.parse(queData["duration"]);
        maxseconds=int.parse(queData["duration"]);
      });
    });
  }
  playtimer(){
    player4.play(AssetSource("sounds/TIMER.mp3"));
  }
  playlock(){
    player4.stop();
    player.stop();
    final player1=AudioPlayer();
    player1.play(AssetSource("sounds/LOCK_SCREEN.mp3"));
    Future.delayed(Duration(seconds: 3),(){
      player1.stop();
    });
  }
  playlocal() async {
    player.play(AssetSource("sounds/QUESTION.mp3"));
    player.onPlayerComplete.listen((event){
      playtimer();
    });
  }
  quetimer() async{
    timer=Timer.periodic(const Duration(seconds: 1),(_){
      setState(() => second--);
      if(second==0){
        timer?.cancel();
        timer?.cancel();
        player4.stop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Lose(widget.quizMoney=="2500" ? "0" : (int.parse(widget.quizMoney)~/2).toString(), questionModel.correctAnswer)));
      }
    });
    }
    Future<bool?> showWarning() async {
    showDialog(context: context, builder: (context)=>AlertDialog(
        title: const Text("Do You Want To Quit The Game"),
        content: Text("You Will Win Rs.${widget.quizMoney=="2500" ? "0" : (int.parse(widget.quizMoney)/2).toString()}"),
        actions: [
          TextButton(onPressed: () async {
            await FireDB().updateAmount(widget.quizMoney=="2500" ? 0 : int.parse(widget.quizMoney)~/2);
            Navigator.pop(context, true);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          },
            child: const Text("QUIT"),
          ),
          TextButton(onPressed: (){Navigator.pop(context, false);}, child: const Text("CANCEL"))
        ]
    ));
    }
  pausetimer(){
    timer?.cancel();
    player4.stop();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genQue();
    quetimer();
    playlocal();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"))),
      child: WillPopScope(
        onWillPop: () async {
          final willpop=await showWarning();
          return willpop?? false;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: ElevatedButton(child: Text("QUIT GAME",style: TextStyle(fontSize: 18,color: Colors.white),),
            onPressed: (){
              showDialog(context: context, builder: (context)=>AlertDialog(
                title: const Text("Do You Want To Quit The Game?"),
                content: Text("You Will Win Rs.${widget.quizMoney=="2500" ? "0" : (int.parse(widget.quizMoney)/2).toString()}"),
                actions: [
                  TextButton(onPressed: () async {
                    await FireDB().updateAmount(widget.quizMoney=="2500" ? 0 : int.parse(widget.quizMoney)~/2);
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                  },
                      child: const Text("QUIT"),
                  ),
                  TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("CANCEL"))
                ],
              ));
            },
              style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              backgroundColor: Colors.purple, // Background color
            ),),
          appBar: AppBar(backgroundColor: Colors.purple,title: Text("Rs.${widget.quizMoney}",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white),),centerTitle: true,),
          drawer: Lifeline(questionModel.question, questionModel.option1, questionModel.option2, questionModel.option3, questionModel.option4, questionModel.correctAnswer, widget.quizid, widget.quizMoney, questionModel.AnsYTLink),
          onDrawerChanged: (value){
            if(value){
              timer?.cancel();
              pausetimer();
                   Future.delayed(const Duration(seconds: 7),() async {
                    _scaffoldKey.currentState?.openEndDrawer();
                 });
            }else{
              playtimer();
              quetimer();
            }
          },
            key: _scaffoldKey,
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30,),
                SizedBox(height: 100,width: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: second/maxseconds,
                        backgroundColor: Colors.green,
                        color: Colors.purple,
                        strokeWidth: 8,
                      ),
                      Center(child: Text(second.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.white),
                  child: Text(questionModel.question,textAlign: TextAlign.center,style: TextStyle(fontSize: 30,),),
                ),//question
                const SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    showSimpleNotification(Text("Double Press To Lock"),background: Colors.grey);
                  },
                  onDoubleTap: () {
                    timer?.cancel();
                    playlock();
                    setState(() {
                      opt1lock=true;
                      opt2lock=false;
                      opt3lock=false;
                      opt4lock=false;
                    });
                      Future.delayed(const Duration(seconds: 10), () {
                        if(opt1lock) {
                          (questionModel.option1 == questionModel.correctAnswer)
                              ? Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Win(widget.quizMoney, widget.quizid)))
                              : Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Lose(widget.quizMoney,
                                      questionModel.correctAnswer)));
                        }
                      });
                    },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(14),
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(34),color: opt1lock? Colors.yellow.withOpacity(0.6) : Colors.grey.withOpacity(0.6)),
                    child: Text("A. ${questionModel.option1}",textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),//option1
                const SizedBox(height: 4,),
                InkWell(
                  onTap: (){showSimpleNotification(Text("Double Press To Lock"),background: Colors.grey);},
                  onDoubleTap: () {
                    timer?.cancel();
                    playlock();
                    setState(() {
                      opt1lock=false;
                      opt2lock=true;
                      opt3lock=false;
                      opt4lock=false;
                    });
                      Future.delayed(Duration(seconds: 10), () {
                        if(opt2lock) {
                          (questionModel.option2 == questionModel.correctAnswer)
                              ? Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Win(widget.quizMoney, widget.quizid)))
                              : Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Lose(widget.quizMoney,
                                      questionModel.correctAnswer)));
                        }
                      });
                    },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(14),
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(34),color: opt2lock? Colors.yellow.withOpacity(0.6) : Colors.grey.withOpacity(0.6)),
                    child: Text("B. ${questionModel.option2}",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),//option2
                const SizedBox(height: 4,),
                InkWell(
                  onTap: (){
                    showSimpleNotification(Text("Double Press To Lock"),background: Colors.grey,position: NotificationPosition.bottom);
                  },
                  onDoubleTap: () {
                    timer?.cancel();
                    playlock();
                    setState(() {
                      opt1lock=false;
                      opt2lock=false;
                      opt3lock=true;
                      opt4lock=false;
                    });
                      Future.delayed(Duration(seconds: 10), () {
                        if(opt3lock) {
                          (questionModel.option3 == questionModel.correctAnswer)
                              ? Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Win(widget.quizMoney, widget.quizid)))
                              : Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Lose(widget.quizMoney,
                                      questionModel.correctAnswer)));
                        }
                      });
                     },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(14),
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(34),color: opt3lock? Colors.yellow.withOpacity(0.6) : Colors.grey.withOpacity(0.6)),
                    child: Text("C. ${questionModel.option3}",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),//option3
                const SizedBox(height: 4,),
                InkWell(
                  onTap: (){showSimpleNotification(Text("Double Press To Lock"),background: Colors.grey);},
                  onDoubleTap: () {
                    timer?.cancel();
                    playlock();
                    setState(() {
                      opt1lock=false;
                      opt2lock=false;
                      opt3lock=false;
                      opt4lock=true;
                    });
                      Future.delayed(const Duration(seconds: 10), () {
                        if(opt4lock) {
                          (questionModel.option4 == questionModel.correctAnswer)
                              ? Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Win(widget.quizMoney, widget.quizid)))
                              : Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Lose(widget.quizMoney,
                                      questionModel.correctAnswer)));
                        }
                      });

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(34),color: opt4lock? Colors.yellow.withOpacity(0.6) : Colors.grey.withOpacity(0.6)),
                    child: Text("D. ${questionModel.option4}",textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),//option4
              ],
            ),
          )
        ),
      ),
    );
  }
}

