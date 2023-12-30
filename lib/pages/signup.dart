import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/signin.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  String email = "", password = "", confirmPassword = "";

  final TextEditingController _mailController = new TextEditingController();
  final TextEditingController _paswordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height/4.0,
          width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7f30fe), Color(0xFF6380fb)], 
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(
                MediaQuery.of(context).size.width, 105.0))
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 60.0),
        child: Column(children: [
          Center(child: Text(
            "Sign Up", 
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, 
              fontWeight: FontWeight.bold),
              )),
          Center(child: Text(
            "Create New Account", 
            style: TextStyle(
              color:Color(0xFFbbb0ff),
              fontSize: 18, 
              fontWeight: FontWeight.w500),
              )),
              SizedBox(height: 20.0,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),  
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                height: MediaQuery.of(context).size.height/1.55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Form(
                  key: _formKey,
                  child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Email", 
                    style: TextStyle(color: Colors.black, 
                    fontSize: 18.0, 
                    fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.black38), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _mailController,
                      onChanged: (value) => setState(() => email = value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(border: InputBorder.none, 
                      prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF7f30fe),),
                      hintText: 'Email Address',),
                      validator: (value) => value != null && EmailValidator.validate(value) ? null : "Invalid Email Adress",
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Text("Password", 
                    style: TextStyle(color: Colors.black, 
                    fontSize: 18.0, 
                    fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.black38), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _paswordController,
                      onChanged: (value) => setState(() => password = value),
                      validator: (value){
                        if(value == null  || value.isEmpty){
                          return "Please enter password";
                        }
                        return null;
                      },
                      autofillHints: const[AutofillHints.password],
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(
                        Icons.password, 
                        color: Color(0xFF7f30fe),
                        ),
                        hintText: 'Your Password',
                        suffixIcon: IconButton(onPressed: 
                        () => setState(
                          () => _showPassword = !_showPassword), 
                          icon: _showPassword ?
                          const Icon(Icons.visibility_off) :
                          const Icon(Icons.visibility)
                          )),
                        obscureText: !_showPassword,
                    ),
                  ),
                  SizedBox(height: 8.0,),

                  Text("Confirm Password", 
                    style: TextStyle(color: Colors.black, 
                    fontSize: 18.0, 
                    fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.black38), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      onChanged: (value) => setState(() => confirmPassword = value),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please confirm Password";
                        }
                        return null;
                      },
                      autofillHints: const[AutofillHints.password],
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(
                        Icons.password, 
                        color: Color(0xFF7f30fe),
                        ),
                        hintText: 'Confirm Your Password',
                        suffixIcon: IconButton(onPressed: 
                        () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword), 
                          icon: _showConfirmPassword ?
                          const Icon(Icons.visibility_off) :
                          const Icon(Icons.visibility)
                          )),
                        obscureText: !_showConfirmPassword,
                    ),
                  ),

                  SizedBox(height: 8.0,),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                      child: Material(
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Color(0xFF6380fb),borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => _signUp(),
                              child: Text("SIGN UP", style: TextStyle(color: Color(0xFF7f30fe), fontSize: 18.0, fontWeight: FontWeight.bold),),
                            )
                          ),
                        ),
                      ),
                    ),
                  )
                ],
                ) ,
                )
                
              ),
            ), 
          ),
          SizedBox(height: 40.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(
            "Already have an account?", 
            style: TextStyle(color: Colors.black, fontSize: 16.0, ),),
            TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const SignIn())),
                        child: const Text(
                              " Sign In Here!", 
                              style: TextStyle(color: Color(0xFF7f30fe), fontSize: 16.0, fontWeight: FontWeight.w500 ),
                              ),
                      ),
            ],
          )
        ],
        ),
        ),
      ],
      ),
      ),
    );
  }


  Future<void> _signUp() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      if(password != "" && password == confirmPassword){
          try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _mailController.text.trim(),
            password: _paswordController.text.trim(),
          );

          if (credential.user != null) {
            // Create a reference to the 'users' collection
            final usersRef = FirebaseFirestore.instance.collection('users');

            // Add a new document in 'users' collection with UID as the document ID
            CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

            Map<String, dynamic> userData = {
              "id": credential.user?.uid ?? '',
              "displayName": _mailController.text.trim().split("@")[0],
              "bio": ""
            };
            await usersCollection.add(userData);
            navigator.pushReplacement(
                MaterialPageRoute(builder: (_) => const Home()));
            scaffoldMessenger.showSnackBar(SnackBar(
              content: Center(child: Text("Registred successfully", style: TextStyle(fontSize: 20.0),)))) ;
          }
          } on FirebaseAuthException catch (e, stackTrace) {
            final String errorMessage;

            if (e.code == 'weak-password') {
              errorMessage = 'Provided password is too weak.';
            } else if (e.code == 'email-already-in-use') {
              errorMessage = 'User with This email already exists.';
            } else {
              errorMessage = 'an error has occured.';
            }

            log(
              'Error while signing in: ${e.code}',
              error: e,
              stackTrace: stackTrace,
              name: 'SignInPage',
            );
            scaffoldMessenger.showSnackBar(SnackBar(
              content: Center(child:  Text(errorMessage, style: TextStyle(fontSize: 18.0, color: const Color.fromARGB(255, 215, 51, 49))))));
          }
      }else{
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Center(
            child: Text("Password and confirmation are not identical", style: TextStyle(fontSize: 18.0, color: const Color.fromARGB(255, 215, 51, 49))))),
          );
          
      }
    }
  }
}