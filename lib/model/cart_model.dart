import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_products.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  
  static CartModel of(BuildContext context) =>
    ScopedModel.of<CartModel>(context);

  //Lista com todos os produtos do carrinho
  List<CartProducts> products = [];

  //usuario atual
  UserModel user;

  bool isLoading = false;

  CartModel(this.user);

  void addCartItem(CartProducts cartProducts){
    products.add(cartProducts);

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").add(cartProducts.toMap()).then((value) {
        cartProducts.cid = value.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProducts cartProducts){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProducts.cid).delete();
    products.remove(cartProducts);
    notifyListeners();
  }


}