import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kbc_quiz_app/services/localDB.dart';

import '../services/firedb.dart';

class Profile extends StatefulWidget {
  //dynamic name, money, level, rank, proURL;
  //Profile(name, money, level, rank, proURL,);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isloading=true;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> Leaderboard=[];
  int rank=0;
  dynamic name="NA", money="NA", level="NA", proURL="NA";
  Future <void> profileinfo() async {
    FireDB instance2 = FireDB();
    await instance2.getUser();
    setState(() {
      name = instance2.username;
      money = instance2.money;
      rank = instance2.rank;
      level = instance2.level;
      //proURL = instance2.proURL;
      isloading=false;
    });
  }
  getLeaderboard() async {
    await FirebaseFirestore.instance.collection("users").orderBy("money").get().then((value) {
          setState(() {
            Leaderboard=value.docs.reversed.toList();
            rank=Leaderboard.indexWhere((element) => element.data()["name"]==name)+1;
            proURL=Leaderboard[rank-1].data()["photoURL"];
            isloading=false;
          });
    });
          await FireDB().updateRank(rank);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileinfo();
    getLeaderboard();
    setState(() {
      isloading=false;
    });
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
    ) : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back,color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.share,color: Colors.white,)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.person_add,color: Colors.white,)),
        ],
        elevation: 0.0,
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text("PROFILE",style:TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20))),
              child: Column(
                children: [
                  Stack(children: [
                    CircleAvatar(radius: 50,backgroundImage: NetworkImage(proURL)),
                    Positioned(
                      height: 35,
                      width: 35,
                      top: 0,
                        right: 0,
                        child:
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.white,),
                        child: IconButton(icon: const Icon(Icons.edit,color: Colors.purple,size: 20,),onPressed: (){},)))
                  ],),
                  const SizedBox(height: 10),
                  Text("${name}\n(Rs.${money})",style: const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1,indent: 20,endIndent: 20,),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Rank",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 25),),
                          Text("#${rank}",style: const TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w600))
                        ],
                      )
                    ],
                  )
                ],
              )
            ),
            const SizedBox(height: 5),
            const Text("Leaderboard",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
            Container(
              margin: const EdgeInsets.all(10),
              child: Stack(
                children: [ SizedBox(
                  height: 340,
                  child: ListView.separated(
                       shrinkWrap: true,
                      itemBuilder: (context,index) => ListTile(
                        leading: Text("#${index+1}",style: const TextStyle(fontSize: 16),),
                        title: Row(
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(Leaderboard[index].data()["photoURL"]),),
                            const SizedBox(width: 10),
                            Text(Leaderboard[index].data()["name"].toString().length>12? "${Leaderboard[index].data()["name"].toString().substring(0,12)}...": Leaderboard[index].data()["name"]),
                          ],
                        ),
                        trailing: Text("Rs.${Leaderboard[index].data()["money"]}",style: const TextStyle(fontSize: 17),),
                      ),
                      separatorBuilder: (context,index)=>const Divider(thickness: 1,color: Colors.purple,indent: 10,endIndent: 10,),
                      itemCount: Leaderboard.length,
                  ),
                ),
                  Positioned(
                    bottom: 12,
                      left: 100,
                      right: 100,
                      child: ElevatedButton(onPressed: (){}, child: const Text("Show My Position")),
                  )
              ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
