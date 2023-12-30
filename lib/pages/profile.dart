import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/signin.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/stream_listener.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');


  final ValueNotifier<bool> _isEditing = ValueNotifier(false);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Map<String, dynamic> _userData = {};

  @ override 
  void initState(){
    super.initState();
    print(_isEditing.value);
    //printAllDocumentsInCollection();
  }

  @override
  void didChangeDependencies() {
  super.didChangeDependencies();
  _fetchUserData();
  }

  Future<void> _fetchUserData() async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  if (user != null) {
    try {
      var userDoc = await _collectionRef.doc(user!.uid).get();
      print(_isEditing.value);
      if (userDoc.exists) {
        // Explicitly cast userData to Map<String, dynamic>
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
          _nameController.text = _userData['displayName'];
          _bioController.text = _userData['bio'];
        });
        print("im heeere");
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('User data does not exist.', style: TextStyle(fontSize: 18.0)),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text('Failed to fetch user data: $e', style: TextStyle(fontSize: 18.0)),
        backgroundColor: Colors.red,
      ));
    }
  } else {
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text('No user logged in.', style: TextStyle(fontSize: 18.0)),
      backgroundColor: Colors.red,
    ));
  }
}


  Future<void> _saveUserData() async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  String newDisplayName = _nameController.text.trim();
  String newBio = _bioController.text.trim();

  print("value of boolean is ${_isEditing.value}");
  
  if (user?.uid != null) {
    try {
      await _collectionRef.doc(user!.uid).set({
        "displayName": newDisplayName,
        "bio": newBio,
      }, SetOptions(merge: true));

      // Show a success snackbar
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Center(child: Text('Profile updated successfully',
        style: TextStyle(fontSize: 18.0,))),
        backgroundColor: Colors.green,
        ),
      );
      // Update the UI to display the new values and disable editing
      _isEditing.value = false;

    } catch (error) {
      // Handle errors
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Center(child: Text('Failed to update profile: $error', 
        style: TextStyle(fontSize: 18.0,))),
        backgroundColor: Colors.red, 
      ));
    }
    setState(() {
      _isEditing.value = false;
      _userData['displayName'] = newDisplayName;
      _userData['bio'] = newBio;
    });
  } else {
    // Handle empty fields
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Center(
        child: Text('No changes to save', style: TextStyle(fontSize: 18.0))),
        backgroundColor : Colors.orange, 
    ));
  }
}




 /* Future<void> printAllDocumentsInCollection() async {
  final collectionRef = FirebaseFirestore.instance.collection('users');
  
  // Fetch all documents in the collection
  QuerySnapshot querySnapshot = await collectionRef.get();

  // Iterate through all the documents
  for (var doc in querySnapshot.docs) {
    print('Document ID: ${doc.id}, Data: ${doc.data()}');
  }
}*/




  @override
  Widget build(BuildContext context){
    return StreamListener<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      listener: (user){
        if(user == null){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SignIn()), 
            (route) => false);
        }
      },
      child: user!=null 
      ? StreamBuilder<QuerySnapshot>(
        stream: _collectionRef.where('id', isEqualTo: user?.uid).snapshots(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: Text("Error : ${snapshot.error}"),);
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No documents found with the provided UID');
            return Center(child: Text("User data not found"));
          }
              
          // If the snapshot has data and the document exists, print the whole snapshot data
          print('Snapshot data: ${snapshot.data!.docs}');
          var userDataDocument = snapshot.data!.docs.first ;

          if (!userDataDocument.exists) {
            print('User document does not exist.');
            return Center(child: Text("User data not found!"));
          }
          var userData = userDataDocument.data() as Map<String, dynamic>;
          _nameController.text = userData['displayName'] ?? "No displayName set";
          _bioController.text = userData['bio'] ?? "No Bio";
          return Scaffold(
            backgroundColor: Colors.transparent,
            //padding: EdgeInsets.all(16.0),
            body: SafeArea(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 105.0))
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [


                          Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF6380fb),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                      onPressed: () => Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (_) => const Home())), 
                                      icon: Icon(Icons.arrow_back_ios_new_outlined,),) 
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
                                icon: const Icon(Icons.logout_outlined,),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                },
                                ) 
                            ),

                          ],
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7f30fe), Color(0xFF6380fb)], 
                              begin: Alignment.topLeft, 
                              end: Alignment.bottomRight),
                              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 105.0))
                            ),
                          child: Center(
                            child: Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('images/boy.png'),
                                    fit: BoxFit.cover,
                                  ),
                                border: Border.all(
                                color: Colors.black45
                            ),
                          ),
                        ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 5.0),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _editableRow("displayName", 
                        _nameController, 
                        _isEditing, "Type your displayName", _userData['displayName'] ?? "default displayname"),
                        SizedBox(height: 30.0,),
                        _editableRow('Biographie', 
                        _bioController, 
                        _isEditing, 
                        "Talk a little about yourself ...", _userData['bio'] ?? "default bio"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: (){
                        if(_isEditing.value){
                          _saveUserData();
                        }else{
                          setState(() {
                            _isEditing.value = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: _isEditing.value ? Text("Save changes") : Text("Update Profile"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },) :
        Center(child: Text("No User found"),),
    );
  }

  Widget _editableRow(
    String label,
    TextEditingController controller,
    ValueNotifier<bool> isEditing,
    String hintText,
    String latestValue) {
  return ValueListenableBuilder<bool>(
    valueListenable: isEditing,
    builder: (context, isEditingValue, child) {
      return Row(
        children: [
          Expanded(
            child: isEditingValue
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      labelText: label,
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  )
                : Center(
                  child: Text(latestValue),
                ),
          ),
        ],
      );
    },
  );
}
}