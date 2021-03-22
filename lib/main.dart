import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/home_screens.dart';
import 'package:scoped_model/scoped_model.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 4, 125, 141),
            primarySwatch: Colors.blue,

          ),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        )
    );
  }
}
