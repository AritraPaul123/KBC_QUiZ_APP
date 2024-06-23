import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz_app/services/firedb.dart';
import 'package:kbc_quiz_app/views/quiz_ques.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/localDB.dart';

class QIntro extends StatefulWidget {
  dynamic quizname, quizImgURL,quizAbout, quizTopic, quizDuration, quizid, quizprice;
 QIntro(this.quizAbout, this.quizDuration, this.quizImgURL, this.quizname, this.quizTopic, this.quizid, this.quizprice);
  @override
  State<QIntro> createState() => _QIntroState();
}

class _QIntroState extends State<QIntro> {
  bool unlockstate=false;
  bool isloading=false;
  Future<void> unlockstatus() async{
      await FireDB().quizunlockstatus(widget.quizid).then((value) {
        setState(() {
          unlockstate=value!;
        });
      });
  }
  saveLifeline() async{
    final player=AudioPlayer();
    await LocalDB.saveAud(true);
    await LocalDB.save50(true);
    await LocalDB.savejoker(true);
    await LocalDB.saveexpert(true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Q_question(widget.quizid, widget.quizprice)));
    player.play(AssetSource("sounds/KBC_INTRO.mp3"));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unlockstatus();
  }
  @override
  Widget build(BuildContext context) {
    return isloading? const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        ),
      )
    ): Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton(child:Text(unlockstate ? "START GAME": "UNLOCK QUIZ",style: TextStyle(fontSize: 18,color: Colors.black87),), style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.blueAccent, // Background color
      ),
      onPressed: () async{
        if(unlockstate){
          saveLifeline();
        }
        else{
          await FireDB().quizbuy(widget.quizid, int.parse(widget.quizprice)).then((value) {
            if(value){
              print("Quiz Unlocked Successfully");
              setState(() {
                unlockstate=true;
              });
            }else{
              return showDialog(context: context, builder: (context)=>AlertDialog(
                title: const Text("You Do Not Have Enough Money"),
                actions: [
                  TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("OK")),
                ],
              ));
            }
          });
        }
      },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("KBC- Quiz App"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(widget.quizname,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
                    const SizedBox(height: 6),
                    Image.network(widget.quizImgURL,fit: BoxFit.cover,height: 250,),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.topic_outlined),
                        SizedBox(width: 6),
                        Text("Related To-",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500))
                      ],
                    ),
                    const SizedBox(height:4),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            height: 20,
                            child: const Text("Science"),
                          ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 20,
                          child: const Text("Space"),
                        ),
                        Container(
                          margin:const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 20,
                          child: const Text("Astronomy"),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 20,
                          child: const Text("ISRO"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Row(
                      children: [
                        Icon(Icons.timer_outlined),
                        SizedBox(width: 6),
                        Text("Duration-",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500))
                      ],
                    ),
                    Text(widget.quizDuration,style: const TextStyle(fontSize: 16))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 6),
                        Text("About Quiz",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500))
                      ],
                    ),
                    Text(widget.quizAbout,style: const TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
