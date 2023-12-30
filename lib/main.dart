import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superchat/util/firebase_options.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'chat_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // create store as a final variable
  //final store = Store((state, action) => null, initialState: initialState)

  runApp(const ChatApp());
}
