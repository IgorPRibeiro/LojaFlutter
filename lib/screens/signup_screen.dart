import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController =  TextEditingController();
  final _emailController =  TextEditingController();
  final _passController =  TextEditingController();
  final _adressController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastre-se"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Nome Completo"),
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty) return "Nome inválido";
                  },
                ),
                SizedBox(
                  height: 18.0,
                ),TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text){
                    // ignore: missing_return
                    if(text.isEmpty || !text.contains("@")) return "E-mail inválido";
                  },
                ),
                SizedBox(
                  height: 18.0,
                ),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(hintText: "Senha"),
                  obscureText: true,
                  validator: (text){
                    // ignore: missing_return
                    if(text.isEmpty || text.length < 6) return "Senha inválida";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _adressController,
                  decoration: InputDecoration(hintText: "Endereço"),
                  validator: (text){
                    // ignore: missing_return
                    if(text.isEmpty) return "Endereço inválida";
                  },
                ),

                SizedBox(
                  height: 19.0,
                ),
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(color: Colors.white),
                      primary: Theme.of(context).primaryColor),
                  child: Text(
                    "Cadastra-se",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    if(_formKey.currentState.validate()){

                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _adressController.text
                      };

                      model.signUp(
                          userData: userData,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso!"),backgroundColor: Theme.of(context).primaryColor,duration: Duration(seconds: 2),)
    );
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context).pop());
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar o usuario"),backgroundColor: Colors.redAccent,duration: Duration(seconds: 2),)
    );
  }

}


