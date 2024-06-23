import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AskTheExpert extends StatefulWidget {
  late String question, videoid;
  AskTheExpert(this.question, this.videoid);

  @override
  State<AskTheExpert> createState() => _AskTheExpertState();
}

class _AskTheExpertState extends State<AskTheExpert> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 190),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ASK THE EXPERT",textAlign: TextAlign.center,style: TextStyle(color: Colors.redAccent,fontSize: 28,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,decorationColor: Colors.redAccent)),
              const SizedBox(height: 20),
              Text("Question: ${widget.question}",textAlign: TextAlign.center,style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600,color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 20),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: YoutubePlayer(
                  width: 600,
                  controller: YoutubePlayerController(
                      initialVideoId: widget.videoid,
                    flags: const YoutubePlayerFlags(
                      hideControls: false,
                      autoPlay: true,
                      mute: false,
                      controlsVisibleAtStart: false,
                      enableCaption: true
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ),
              SizedBox(height: 20),
              Text("You Will Be Redirected To Question In 60 Seconds",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23,color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
