import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/pages/chatpage.dart';
import 'package:superchat/pages/profile.dart';
import 'package:superchat/pages/signin.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/stream_listener.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users");

  Future<void> getUsersData() async{
    final response = await _collectionRef.get();
    for(var user in response.docs){
      print(user.data());
    }
  }

  @override
  void initState(){
    super.initState();
    getUsersData();
  }


  @override
  Widget build(BuildContext context){
    return StreamListener<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      listener : (user){
        if(user == null){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignIn()),
              (route) => false);
        }
      },
      child: Scaffold(
      backgroundColor: Color(0xFF6380fb),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7f30fe), Color(0xFF6380fb)], 
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(
                MediaQuery.of(context).size.width, 105.0))
          ),
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF6380fb),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                 icon: const Icon(Icons.logout_outlined),
                 onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                 },
                 ) 
            ),

            Text(kAppTitle,
              style: TextStyle(color: Color.fromARGB(255, 228, 205, 235),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),),

            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF6380fb),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                 icon: const Icon(Icons.account_circle_outlined),
                 onPressed: () async {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile()));
                 },
                 ) 
            )
          ],
          ),),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.25,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child : StreamBuilder<QuerySnapshot>(
              stream: _collectionRef.snapshots(),
              builder:(context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                if(snapshot.hasError){
                  return Center(child: Text('Error : ${snapshot.error}'),);
                }
                if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                  return Center(child: Text("No Users Found"),);
                }
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => Divider(color: Color.fromARGB(255, 219, 177, 232),thickness: 1,),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> UserData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    bool isIndexedOdd = index % 2 == 1;
                    Color backgroundColor = Colors.white;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0,),
                      child : Container(
                        color: backgroundColor,
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                  borderRadius : BorderRadius.circular(60),
                                  child: UserData['profilePicture'] != null ?
                                    Image.network(UserData['profilePicture'], height: 60, width: 60, fit: BoxFit.cover,) :
                                    isIndexedOdd ?
                                    Image.asset(
                                      "images/boy.png", 
                                      height: 60, 
                                      width: 60,
                                      fit: BoxFit.cover,) : 
                                      Image.asset(
                                      "images/boyy.png", 
                                      height: 60, 
                                      width: 60,
                                      fit: BoxFit.cover,),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(
                                    child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.0,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(UserData['displayName']!= null && UserData['displayName'].isNotEmpty ? UserData['displayName'] : "default username", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            Text(UserData['bio'] != null && UserData['bio'].isNotEmpty ? UserData['bio'] : "Hello World ! i'm ${UserData['displayName']}" , style: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChatPage(userId : UserData['id']?? 'yUjl2YIK3lcbs5I8TC0Afwt6MGC3', userName : UserData['displayName'] ?? 'DefauktUser'),));
                                    }, 
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 113, 138, 249))
                                    ), 
                                    child: Text("Open Chat", style: TextStyle(
                                      color: Color.fromARGB(255, 228, 205, 235),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),), 
                                    ),
                              ],),)
                      
                    );
                  },
                );
              },
            )
          )
        ],
      ),),
    ) , 
    );
  }
}