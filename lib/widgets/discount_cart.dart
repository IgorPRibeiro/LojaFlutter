import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: ExpansionTile(
        title: Text("Cupon de desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[500]
          ),
        ),

        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("coupons").document(text).get().then((value){
                  if(value.data !=null){
                    CartModel.of(context).setCupom(text, value["percent"]);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Desconto de ${value.data["percent"]}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,
                      )
                    );
                  }else {
                    CartModel.of(context).setCupom(null, 0);
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Cupom não existente"),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
