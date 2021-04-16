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

  String cupomCode;
  int discountPercentege = 0;

  //usuario atual
  UserModel user;

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn())
      _loadCartItens();
  }

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

  void decProduct(CartProducts cartProducts){
    cartProducts.quantity--;
    
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").document(cartProducts.cid).updateData(cartProducts.toMap());

    notifyListeners();
    
  }

  void incProduct(CartProducts cartProducts){
    cartProducts.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProducts.cid).updateData(cartProducts.toMap());

    notifyListeners();
  }

  void _loadCartItens() async {


    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

    products = query.documents.map((e) => CartProducts.fromDocument(e)).toList();

    notifyListeners();

  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for(CartProducts c in products){
      if(c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentege / 100;
  }

  void setCupom(String cupomCode, int discountPercentage){
    this.cupomCode = cupomCode;
    this.discountPercentege = discountPercentage;
  }

  Future<String> finishOrder() async {
    if(products.length == 0) return null;

    isLoading = true;

    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //criando o pedido no firebase
    DocumentReference refOrder = await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });

    //Salvando o orderId dentro do usuario
    await  Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("orders").document(refOrder.documentID).setData({
      "ordeId": refOrder.documentID
    });

    //removendo os produtos do carrinho e do firebase
    QuerySnapshot querySnapshot = await Firestore.instance.collection("users")
      .document(user.firebaseUser.uid).collection("cart").getDocuments();
    for(DocumentSnapshot doc in querySnapshot.documents){
      doc.reference.delete();
    }
    products.clear();
    cupomCode = null;
    discountPercentege = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }


}