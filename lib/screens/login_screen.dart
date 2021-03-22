import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =  TextEditingController();
  final _passController =  TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen())
              );
            },
            child: Text(
              'CRIAR CONTA',
              style: TextStyle(fontSize: 15.0),
            ),
            style: TextButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: ( context, child, model){
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
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
                      if(text.isEmpty || text.length < 6) return "Senha inválida";
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if(_emailController.text.isEmpty){
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Insira seu e-mail para recuperação"),backgroundColor: Colors.redAccent,duration: Duration(seconds: 2),)
                          );
                        }else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Confira seu email"),backgroundColor: Theme.of(context).primaryColor,duration: Duration(seconds: 2),)
                          );
                        }
                      },
                      child: Text(
                        "Equeci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        primary: Theme.of(context).primaryColor),
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      if(_formKey.currentState.validate()){

                      }
                      model.signIn(
                        email: _emailController.text,
                        pass: _passController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                      );
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao entrar"),backgroundColor: Colors.redAccent,duration: Duration(seconds: 2),)
    );
  }


}

