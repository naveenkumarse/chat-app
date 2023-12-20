
import 'package:flutter/material.dart';
import 'package:kecbot/chatbox.dart';

void main(){
  runApp(App());
}
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Chatpage(),
      debugShowCheckedModeBanner: false,

    );
  }
}

