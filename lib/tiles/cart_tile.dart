import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_products.dart';
import 'package:loja_virtual/data/product_data.dart';
import 'package:loja_virtual/model/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProducts cartProducts;

  CartTile(this.cartProducts);



  @override

  Widget _buidContent() {

  }

  Widget build(BuildContext context) {

    Widget _buidContent(){
      CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment:  MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProducts.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cartProducts.productData.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    Text(
                      "Tamanho: ${cartProducts.size}",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "R\$ ${cartProducts.productData.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            color: Theme.of(context).primaryColor,
                            onPressed: cartProducts.quantity >1 ? (){
                              CartModel.of(context).decProduct(cartProducts);
                            } : null
                        ),
                        Text(
                          cartProducts.quantity.toString(),
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              CartModel.of(context).incProduct(cartProducts);
                            }
                        ),
                        TextButton(
                            child: Text("Remover"),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(color: Colors.grey[500]),
                              primary: Colors.grey[500]
                            ),
                            onPressed: (){
                              CartModel.of(context).removeCartItem(cartProducts);
                            },
                        )
                      ],
                    )
                  ],
                ),
              )
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: cartProducts.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("products").document(cartProducts.category).
          collection("items").document(cartProducts.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              cartProducts.productData = ProductData.fromDocument(snapshot.data);
              return _buidContent();
            }else {
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) :
          _buidContent()
      ,
    );
  }
}
