import 'dart:math';

import 'package:flutter/material.dart';
class AudiencePoll extends StatefulWidget {
  late String question, opt1, opt2, opt3, opt4, correctAns;
  AudiencePoll(this.question, this.opt1, this.opt2, this.opt3, this.opt4, this.correctAns);

  @override
  State<AudiencePoll> createState() => _AudiencePollState();
}

class _AudiencePollState extends State<AudiencePoll> {
  bool isVoting=true;
  int opt1votes=0; int opt2votes=0; int opt3votes=0; int opt4votes=0;
  VotingMachine() async {
    Future.delayed(const Duration(milliseconds: 2000),(){
      setState(() {
        if(widget.opt1==widget.correctAns){
          opt1votes=Random().nextInt(100);
        }else{
          opt1votes=Random().nextInt(40);
        }
        if(widget.opt2==widget.correctAns){
          opt2votes=Random().nextInt(100);
        }else{
          opt2votes=Random().nextInt(40);
        }
        if(widget.opt3==widget.correctAns){
          opt3votes=Random().nextInt(100);
        }else{
          opt3votes=Random().nextInt(40);
        }
        if(widget.opt4==widget.correctAns){
          opt4votes=Random().nextInt(100);
        }else{
          opt4votes=Random().nextInt(40);
        }
        isVoting=false;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VotingMachine();
    Future.delayed(Duration(seconds: 60),(){
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.withOpacity(0.7),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 170, horizontal: 20),
          decoration: BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("AUDIENCE POLL",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.redAccent, decoration: TextDecoration.underline,decorationColor: Colors.redAccent)),
              SizedBox(height: 10),
              Text("Question- ${widget.question}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23,color: Colors.white.withOpacity(0.8))),
              SizedBox(height: 9,),
              Text(isVoting? "Audience Is Voting" : "Here Are The Results",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize:20,color: Colors.white.withOpacity(0.8))),
              isVoting ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(),
              ) : const SizedBox(height: 10),
              Text(isVoting? "A. ${widget.opt1}" : "A. ${widget.opt1}\t\t${opt1votes} Votes",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: Colors.white.withOpacity(0.8))),
              SizedBox(height: 3),
              Text(isVoting? "B. ${widget.opt2}" : "B. ${widget.opt2}\t\t${opt2votes} Votes",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: Colors.white.withOpacity(0.8))),
              SizedBox(height: 3),
              Text(isVoting? "C. ${widget.opt3}" : "C. ${widget.opt3}\t\t${opt3votes} Votes",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: Colors.white.withOpacity(0.8))),
              SizedBox(height: 3),
              Text(isVoting? "D. ${widget.opt4}" : "D. ${widget.opt4}\t\t${opt4votes} Votes",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: Colors.white.withOpacity(0.8))),
              SizedBox(height: 3),
              Text("You Will Be Redirected To Question In 60 Seconds",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23,color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
