import 'package:flutter/material.dart';
// import 'package:todo_list/d.dart';
import 'package:todo_list/mainui.dart';
//import 'package:todo_list/demo.dart';
//import 'package:todo_list/tododemo.dart';
//import 'package:todo_list/d.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Mainfile2(),
    );
  }
}

