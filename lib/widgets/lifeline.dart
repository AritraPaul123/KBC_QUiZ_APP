import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz_app/services/localDB.dart';
import 'package:kbc_quiz_app/views/quiz_ques.dart';
import 'package:kbc_quiz_app/widgets/askexpert.dart';
import 'package:kbc_quiz_app/widgets/audiencepoll.dart';
import 'package:kbc_quiz_app/widgets/fifty50.dart';

class Lifeline extends StatefulWidget {
  late String question, opt1, opt2, opt3, opt4, correctAns, quizid, currentprice, videoid;
  Lifeline(this.question, this.opt1, this.opt2, this.opt3, this.opt4, this.correctAns, this.quizid, this.currentprice, this.videoid);
  @override
  State<Lifeline> createState() => _LifelineState();
}

class _LifelineState extends State<Lifeline> {
  Future<bool> checkAudavail() async {
    bool isAudAvail=true;
    await LocalDB.getAud().then((value) {
      setState(() {
        isAudAvail=jsonDecode(value!.toString());
      });
    });
    return isAudAvail;
  }
  Future<bool> check50avail() async {
    bool is50Avail=true;
    await LocalDB.get50().then((value) {
      setState(() {
        is50Avail=jsonDecode(value!.toString());
      });
    });
    return is50Avail;
  }
  Future<bool> checkjokeravail() async {
    bool isjokerAvail=true;
    await LocalDB.getjoker().then((value) {
      setState(() {
        isjokerAvail=jsonDecode(value!.toString());
      });
    });
    return isjokerAvail;
  }
  Future<bool> checkexpavail() async {
    bool isexpAvail=true;
    await LocalDB.getexpert().then((value) {
      setState(() {
        isexpAvail=jsonDecode(value!.toString());
      });
    });
    return isexpAvail;
  }
  playlifeline(){
    final player3=AudioPlayer();
    player3.play(AssetSource("assets/sounds/LIFELINE.mp3"));
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Text("LIFELINES",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    if(await checkAudavail()) {
                      playlifeline();
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) =>
                          AudiencePoll(
                              widget.question, widget.opt1, widget.opt2,
                              widget.opt3, widget.opt4,
                              widget.correctAns)));
                      setState(() async {
                        await LocalDB.saveAud(false);
                      });
                    }else{
                      print("Audience Poll Already Used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.purple,shape: BoxShape.circle),
                          child: Icon(Icons.people_alt,color: Colors.white,size: 27,),
                        ),
                      ),
                      const Text("Audience\nPoll",textAlign: TextAlign.center,style: TextStyle(fontSize: 15),)
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if(await checkjokeravail()) {
                      playlifeline();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              Q_question(
                                  widget.quizid, widget.currentprice)));
                      setState(() async {
                        await LocalDB.savejoker(false);
                      });
                    }else{
                      print("Joker Question Already Used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.purple,shape: BoxShape.circle),
                          child: Icon(Icons.call,color: Colors.white,size: 27,),
                        ),
                      ),
                      Text("Joker\nQuestion",textAlign: TextAlign.center,style: TextStyle(fontSize: 15),)
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if(await check50avail()) {
                      playlifeline();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              Fifty50(widget.question, widget.opt1, widget.opt2, widget.opt3, widget.opt4, widget.correctAns)));
                      setState(() async {
                        await LocalDB.save50(false);
                      });
                    }else{
                      print("50-50 Already Used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.purple,shape: BoxShape.circle),
                          child: Icon(Icons.percent,color: Colors.white,size: 27,),
                        ),
                      ),
                      const Text("50-50",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if(await checkexpavail()) {
                      playlifeline();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              AskTheExpert(widget.question, widget.videoid)));
                      setState(() async {
                        await LocalDB.saveexpert(false);
                      });
                    }else{
                      print("Ask The Expert Already Used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.purple,shape: BoxShape.circle),
                          child: const Icon(Icons.star,color: Colors.white,size: 27,),
                        ),
                      ),
                      const Text("Ask The\nExpert",textAlign: TextAlign.center,style: TextStyle(fontSize: 15),)
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            const Divider(color: Colors.black12,thickness: 3,),
            const SizedBox(height: 6),
            const Text("PRIZES",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            const SizedBox(height: 8),
            SizedBox(
              height: 530,
              child: ListView.builder(itemCount:13,reverse:true,shrinkWrap: true,itemBuilder: (context,index){
                if({(pow(2, index))*2500}==widget.currentprice) {
                  return ListTile(leading: Text("${index + 1}.",
                      style: const TextStyle(fontSize: 20, color: Colors.grey)),
                      tileColor: Colors.deepPurpleAccent,
                      title: Text("Rs.${(pow(2, index)) * 2500}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight
                              .w600,color: Colors.white)),
                      trailing: const Icon(Icons.check,color: Colors.purpleAccent,));
                }else{
                  return ListTile(leading: Text("${index + 1}.",
                      style: const TextStyle(fontSize: 20, color: Colors.grey)),
                      title: Text("Rs.${(pow(2, index)) * 2500}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight
                              .w600)),
                      trailing: const Icon(Icons.check));
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
