import 'package:flutter_practice_project/models/OptionDTO.dart';

class ProductDTO {
  int? no;
  String? title;
  String? mainImg;
  List<String>? images;
  List<OptionDTO>? options;
  int? price;
  int? amount;
  int? orderProductNo;

  ProductDTO({
    this.no,
    this.title,
    this.mainImg,
    this.images,
    this.options,
    this.price,
    this.amount,
    this.orderProductNo
  });

  ProductDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    title = json['title'];
    mainImg = json['mainImg'];
    images = List<String>.from(json['images'] ?? []);
    if(json['options'] != null) {
      options = (json['options'] as List).map((json) => OptionDTO.fromJson(json: json)).toList();
    }
    price = json['price'];
    amount = json['amount'];
    orderProductNo = json['orderProductNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['title'] = title;
    data['mainImg'] = mainImg;
    data['images'] = images;
    if (options != null) {
      data['options'] = options!.map((option) => option.toJson()).toList();
    }
    data['price'] = price;
    data['amount'] = amount;
    data['orderProductNo'] = orderProductNo;
    return data;
  }

  @override
  String toString() {
    return "ProductDTO{"
        "no: $no,"
        " title: $title,"
        " mainImg: $mainImg,"
        " images: $images,"
        " options: $options"
        " price: $price,"
        " amount: $amount,"
        " orderProductNo: $orderProductNo}";
  }

}