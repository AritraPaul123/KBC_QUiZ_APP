import 'package:flutter/material.dart';

class Fifty50 extends StatefulWidget {
  late String question, opt1, opt2, opt3, opt4, correctAns;
  Fifty50(this.question, this.opt1, this.opt2, this.opt3, this.opt4, this.correctAns);

  @override
  State<Fifty50> createState() => _Fifty50State();
}

class _Fifty50State extends State<Fifty50> {
  late List wrongAns=[];
  FindWrongAns() {
    setState(() {
      if(widget.opt1!=widget.correctAns){
        wrongAns.add(widget.opt1);
      }
      if(widget.opt2!=widget.correctAns){
        wrongAns.add(widget.opt2);
      }
      if(widget.opt3!=widget.correctAns){
        wrongAns.add(widget.opt3);
      }
      if(widget.opt4!=widget.correctAns){
        wrongAns.add(widget.opt4);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FindWrongAns();
    Future.delayed(Duration(seconds: 60),(){
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 220),
          decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("50-50",textAlign: TextAlign.center,style: TextStyle(color: Colors.redAccent,fontSize: 28,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,decorationColor: Colors.redAccent),),
              const SizedBox(height: 20),
              Text("Question: ${widget.question}",textAlign: TextAlign.center,style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600,color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 20),
              Text("${wrongAns[0]} And ${wrongAns[1]} Are Incorrect Options",textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
              SizedBox(height: 20),
              Text("You Will Be Redirected To Question In 60 Seconds",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23,color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
