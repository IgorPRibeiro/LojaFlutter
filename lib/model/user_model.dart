import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';



class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;

  static UserModel of(BuildContext context) =>
    ScopedModel.of<UserModel>(context);


  //usurio que vai estar logado no momento
  //se não ter algum usuario logado no momento ele retorna null
  //se retornar algum user vai conter o id e outras informacoes
  FirebaseUser firebaseUser;

  //Informacoes mais importantes do user. COntendo os nome email e o endereço.
  //Que são os campos que o usuario coloca quando cadastra uma nova conta
  Map<String, dynamic> userData = Map();


  bool isLoading = false;


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  //VoidCallback é uma função que vamos chamar dentro de uma funcao
  void signUp (
      {@required Map<String, dynamic> userData,
        @required String pass,
        @required VoidCallback onSuccess,
        @required VoidCallback onFail})  {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: pass
    ).then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){
      onFail();

      isLoading = false;
      notifyListeners();

    });



  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
        email: email, 
        password: pass
    ).then((value) async {
      firebaseUser = value;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }


  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String,dynamic> userData ) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }


  bool isLoggedIn() {

    return firebaseUser != null;

  }

  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

}