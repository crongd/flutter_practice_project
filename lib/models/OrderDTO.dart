import 'package:flutter_practice_project/models/ProductDTO.dart';

import 'UserDTO.dart';

class OrderDTO {
  String? orderId;
  String? impUid;
  UserDTO? user;
  List<ProductDTO>? products;
  String? name;
  String? buyerAddr;
  String? buyerPostcode;
  String? createdAt;
  int? amount;
  String? payMethod;
  String? pgId;

  OrderDTO({
    this.orderId,
    this.impUid,
    this.user,
    this.products,
    this.name,
    this.buyerAddr,
    this.buyerPostcode,
    this.createdAt,
    this.amount,
    this.payMethod,
    this.pgId
  });

  OrderDTO.fromJson({required Map<String, dynamic> json}) {
    orderId = json['orderId'];
    impUid = json['impUid'];
    user = json['user'];
    if(json['products'] != null) {
      products = (json['products'] as List).map((json) => ProductDTO.fromJson(json: json)).toList();
    }
    name = json['name'];
    buyerAddr = json['buyerAddr'];
    buyerPostcode = json['buyerPostcode'];
    createdAt = json['createdAt'];
    amount = json['amount'];
    payMethod = json['payMethod'];
    pgId = json['pgId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = orderId;
    data['impUid'] = impUid;
    data['user'] = user;
    if(products != null) {
      data['products'] = products!.map((product) => product.toJson()).toList();
    }
    data['name'] = name;
    data['buyerAddr'] = buyerAddr;
    data['buyerPostcode'] = buyerPostcode;
    data['createdAt'] = createdAt;
    data['amount'] = amount;
    data['payMethod'] = payMethod;
    data['pgId'] = pgId;
    return data;
  }

  @override
  String toString() {
    return "OrderDTO{"
        "orderId: $orderId,"
        " impUid: $impUid,"
        " user: $user,"
        " products: $products,"
        " name: $name,"
        " buyerAddr: $buyerAddr,"
        " buyerPostcode: $buyerPostcode,"
        " createdAt: $createdAt,"
        " amount: $amount,"
        " payMethod: $payMethod,"
        " pgId: $pgId";
  }

}