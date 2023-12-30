import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "", password = "";

  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController = TextEditingController();
  bool _showPassword =false;




  @override
  Widget build (BuildContext context){
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
        Padding(padding: const EdgeInsets.only(top: 70.0),
        child: Column(children: [
          Center(child: Text(
            "Sign In", 
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, 
              fontWeight: FontWeight.bold),
              )),
          Center(child: Text(
            "Login To Your Account", 
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
                height: MediaQuery.of(context).size.height/1.6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Form(
                  key: _formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Email", 
                    style: TextStyle(color: Colors.black, 
                    fontSize: 18.0, 
                    fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.black38), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _emailFieldController,
                      onChanged: (value) => setState(() => email = value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(border: InputBorder.none, 
                      prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF7f30fe),),
                      hintText: 'Email Address',),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Email is required !";
                        }else if(!EmailValidator.validate(value)){
                          return "Invalid Email Address";
                        }
                        return null;
                      }
                      //(value) => value != null && EmailValidator.validate(value) ? null : "Invalid Email Adress",
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Password", 
                    style: TextStyle(color: Colors.black, 
                    fontSize: 18.0, 
                    fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.black38), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _passwordFieldController,
                      onChanged: (value) => setState(() => password = value),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Password is required !";
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
                  SizedBox(height: 10.0,),
                  
                  SizedBox(height: 20.0,),
                  Center(
                    child: Container(
                      width: 130,
                      child: Material(
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Color(0xFF6380fb),borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => _signIn(),
                              child: Text("Sign In", style: TextStyle(color: Color(0xFF7f30fe), fontSize: 18.0, fontWeight: FontWeight.bold),),
                            )
                          ),
                        ),
                      ),
                    ),
                  )
                ],
                )),
              ),
            ), 
          ),
          SizedBox(height: 40.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(
            "Don't have an account?", 
            style: TextStyle(color: Colors.black, fontSize: 16.0, ),),
            TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const SignUp())),
                        child: const Text(
                                  " Sign Up Here!", 
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

  Future<void> _signIn() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (credential.user != null) {
          log("this is the user data : ${credential.user}");
          navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const Home()));
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        final String errorMessage;

        if (e.code == 'user-not-found') {
          errorMessage = 'User Not Found,  check your email';
        } else if (e.code == 'invalid-login-credentials') {
          errorMessage = 'Incorrect credentials, check the provided credentials.';
        } else {
          errorMessage = 'an Error has occured ! ${e.code}';
        }

        log(
          'Error while signing in: ${e.code}',
          error: e,
          stackTrace: stackTrace,
          name: 'SignInPage',
        );
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Center(child: Text(errorMessage, style: TextStyle(fontSize: 18.0, color: const Color.fromARGB(255, 215, 51, 49)),),)
          ));
      }
    }
  }
}
