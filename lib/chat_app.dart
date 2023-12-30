import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/pages/chatpage.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/signin.dart';
import 'package:superchat/pages/signup.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/pages/home.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          backgroundColor: Colors.white,
          accentColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      home: isLoggedIn ? const Home() : const SignIn()//const ChatPage() //const Home() //const SignUp() //const SignInPage(),
    );
  }
}
