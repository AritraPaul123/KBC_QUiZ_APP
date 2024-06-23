import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Lose extends StatefulWidget {
  late String wonmoney, correctAns;
  bool timeup=false;
  Lose(this.wonmoney, this.correctAns, this.timeup);

  @override
  State<Lose> createState() => _LoseState();
}

class _LoseState extends State<Lose> {
  @override
  final player2=AudioPlayer();
  playlose(){
    player2.play(AssetSource("sounds/WORNG_ANSWER.mp3"));
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    playlose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/loose.png"),fit:BoxFit.cover )),
      child: Scaffold(
        floatingActionButton: ElevatedButton(child: const Text("Retry"),onPressed: (){},),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("OH,SORRY!}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 27,color: Colors.white),),
                const  Text(widget.timeup? "Your Answer is incorrect" : "Your Time Is Up",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                Text("Correct Answer is : ${widget.correctAns}",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                const SizedBox(height: 15,),
                const Text("You Won",style: TextStyle(fontSize: 20,color: Colors.white),),
                Text(widget.wonmoney=="2500"? "Rs.0":"Rs.${int.parse(widget.wonmoney)~/2}",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                const SizedBox(height: 20,),
                const Icon(Icons.error_outline,color: Colors.white,size: 150,),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  player2.stop();
                  player2.dispose();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
                },
                  child: const Text("GO TO HOME"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

