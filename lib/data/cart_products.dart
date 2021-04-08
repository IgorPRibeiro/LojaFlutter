import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/data/product_data.dart';

class CartProducts {

  //id carrinho
  String cid;

  //Categoria do produto
  String category;
  //id do produto
  String pid;

  //quantidade de produtos no carrinho
  int quantity;
  //o tamanho do carrinho
  String size;

  //Os dados dos produtos do carrinho
  ProductData productData;

  CartProducts();

  CartProducts.fromDocument(DocumentSnapshot documentSnapshot){
    //esse documento sera um dos produtos que está no carrinho que será armezanado no banco de dados e irá transformar cada um em um CartProduct
    cid = documentSnapshot.documentID;
    category = documentSnapshot.data['category'];
    pid = documentSnapshot.data['pid'];
    quantity = documentSnapshot.data['quantity'];
    size = documentSnapshot.data['size'];
  }
  //Depois que adicionamos o produto no carrinho devemos adicionar no banco de dados
  //para isso devemos transforma-lo em um map
  Map<String,dynamic> toMap(){
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      //"product": productData.toResumeMap()
    };
  }


}