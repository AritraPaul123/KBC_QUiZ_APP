import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:kbc_quiz_app/services/firedb.dart';
import 'package:kbc_quiz_app/views/quiz_ques.dart';

import 'home.dart';

class Win extends StatefulWidget {
  late String quizmoney, quizid;
  Win(this.quizmoney, this.quizid);
  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
  @override
  late ConfettiController confettiController;
  final player2=AudioPlayer();
  updateMoney() async {
    await FireDB().updateAmount(int.parse(widget.quizmoney));
  }

  Future<bool?> showWarning() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text("Do You Want To Quit The Game?"),
                content: Text("You Will Win Rs.${widget.quizmoney}"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await FireDB().updateAmount(int.parse(widget.quizmoney));
                      Navigator.pop(context, true);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: const Text("QUIT"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("CANCEL"))
                ]));
  }
  playwin(){
    player2.play(AssetSource("sounds/CORRECT.mp3"));
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    playwin();
    updateMoney();
    setState(() {
      initController();
    });
    confettiController.play();
  }

  void initController() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final willpop = await showWarning();
        return willpop ?? false;
      },
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/win.png"), fit: BoxFit.cover)),
        child: Scaffold(
          floatingActionButton: ElevatedButton(
            child: const Text("Share With Friends"),
            onPressed: () {},
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "CONGRATULATIONS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                    ),
                    const Text(
                      "Your Answer is correct",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "You Won",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Rs.${widget.quizmoney}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/cheque.jpg",
                              ),
                              fit: BoxFit.fill)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        player2.stop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Q_question(
                                    widget.quizid,
                                    (int.parse(widget.quizmoney) * 2)
                                        .toString())));
                      },
                      child: const Text("NEXT"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        player2.pause();
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                      "Do You Want To Quit The Game?"),
                                  content: Text(
                                      "You Will Win Rs.${widget.quizmoney}"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        player2.stop();
                                        player2.dispose();
                                        await FireDB().updateAmount(
                                            int.parse(widget.quizmoney));
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home()));
                                      },
                                      child: const Text("QUIT"),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          player2.resume();
                                          Navigator.pop(context);
                                        },
                                        child: const Text("CANCEL"))
                                  ],
                                ));
                      },
                      child: const Text("QUIT GAME"),
                    ),
                  ],
                ),
                winning_animation(confettiController, pi / 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Align winning_animation(controller, double blastdirection) {
  return Align(
    alignment: Alignment.topCenter,
    child: ConfettiWidget(
      confettiController: controller,
      emissionFrequency: 0.2,
      gravity: 0.6,
      blastDirection: blastdirection,
      numberOfParticles: 8,
      maxBlastForce: 30,
      minBlastForce: 10,
      maximumSize: Size(40, 30),
      shouldLoop: false,
      blastDirectionality: BlastDirectionality.explosive,
    ),
  );
}
// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// class Win extends StatefulWidget {
//   const Win({ Key? key }) : super(key: key);
//
//   @override
//   _WinState createState() => _WinState();
// }
//
// class _WinState extends State<Win> {
//
//   late ConfettiController confettiController;
//
//   @override
//   void initState() {
//
//     super.initState();
//     setState(() {
//       initController();
//     });
//     confettiController.play();
//   }
//
//
//   void initController() {
//     confettiController =
//         ConfettiController(duration: const Duration(seconds: 1));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/win.png" ) , fit: BoxFit.cover)),
//       child: Scaffold(
//           floatingActionButton: ElevatedButton(child: Text("Share With Friends"), onPressed: (){},),
//           backgroundColor : Colors.transparent,
//           body : Stack(
//             children: [
//               Container(
//                   child : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children : [
//                         Text("CONGRATULATIONS!" , style: TextStyle(fontSize: 30, fontWeight : FontWeight.bold,)),
//                         Text("YOUR ANSWER IS CORRECT" , style: TextStyle(fontSize: 17 , fontWeight : FontWeight.w500,)),
//                         SizedBox(height: 15,),
//                         Text("You Won",style: TextStyle(fontSize: 15 , fontWeight : FontWeight.w400,)),
//                         Text("Rs.5,40,000",style: TextStyle(fontSize: 35 , fontWeight : FontWeight.w700,)),
//                         SizedBox(height: 25,),
//                         Container(
//                             padding: EdgeInsets.all(20),
//                             child: Image.asset("assets/images/cheque.jpg")) ,
//                         ElevatedButton(child: Text("Next"), onPressed: (){},)
//                       ]
//                   )
//               ),
//               buildConfettiWidget(confettiController, pi / 2),
//
//             ],
//           )
//       ),
//     );
//   }
//
//
//   Align buildConfettiWidget(controller, double blastDirection){
//     return Align(alignment: Alignment.topCenter,
//       child: ConfettiWidget(
//         maximumSize: Size(40,30),
//         shouldLoop: false,
//         confettiController: controller,
//         blastDirection: blastDirection,
//         blastDirectionality: BlastDirectionality.explosive,
//         maxBlastForce: 20,
//         minBlastForce: 8,
//         emissionFrequency: 0.2,
//         numberOfParticles: 8,
//         gravity: 0.01,
//       ),
//     );
//   }
//
//
// }
