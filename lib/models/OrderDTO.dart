import 'package:flutter_practice_project/models/ProductDTO.dart';

import 'UserDTO.dart';

class OrderDTO {
  String? merchantUid;
  UserDTO? user;
  List<ProductDTO>? products;
  String? buyerAddr;
  String? buyerPostcode;
  String? createdAt;
  int? amount;

  OrderDTO({
    this.merchantUid,
    this.user,
    this.products,
    this.buyerAddr,
    this.buyerPostcode,
    this.createdAt,
    this.amount
  });

  OrderDTO.fromJson({required Map<String, dynamic> json}) {
    merchantUid = json['merchantUid'];
    user = json['user'];
    if(json['products'] != null) {
      products = (json['products'] as List).map((json) => ProductDTO.fromJson(json: json)).toList();
    }
    buyerAddr = json['buyerAddr'];
    buyerPostcode = json['buyerPostcode'];
    createdAt = json['createdAt'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantUid'] = merchantUid;
    data['user'] = user;
    if(products != null) {
      data['products'] = products!.map((product) => product.toJson()).toList();
    }
    data['buyerAddr'] = buyerAddr;
    data['buyerPostcode'] = buyerPostcode;
    data['createdAt'] = createdAt;
    data['amount'] = amount;
    return data;
  }

  @override
  String toString() {
    return "OrderDTO{"
        "merchantUid: $merchantUid,"
        " user: $user,"
        " products: $products,"
        " buyerAddr: $buyerAddr,"
        " buyerPostcode: $buyerPostcode,"
        " createdAt: $createdAt,"
        " amount: $amount";
  }

}