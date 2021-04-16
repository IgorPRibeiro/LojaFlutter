import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users").document(uid).collection("orders").getDocuments(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else {
            return ListView(
              children: snapshot.data.documents.map((e) => OrderTile(e.documentID)).toList().reversed.toList(),
            );
          }
        },
      );

    }else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch ,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.line_style_rounded, size: 80.0, color: Theme.of(context).primaryColor,),
            SizedBox(height: 16.0,),
            Text("Faça o login para acompanhar os seus pedidos",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
              child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: TextStyle(
                      color: Colors.white
                  )
              ),

            )

          ],
        ),
      );
    }
  }
}
