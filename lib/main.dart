import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 4, 125, 141),
        primarySwatch: Colors.blue,

      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
