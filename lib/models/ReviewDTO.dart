import 'ProductDTO.dart';

class ReviewDTO {
  int? no;
  String? userId;
  int? orderProductNo;
  int? productNo;
  String? content;
  int? rate;
  ProductDTO? product;
  String? writeDate;
  double? averageRate;
  List<String>? users;

  ReviewDTO({
    this.no,
    this.userId,
    this.orderProductNo,
    this.productNo,
    this.content,
    this.rate,
    this.product,
    this.writeDate,
    this.averageRate,
    this.users
  });

  ReviewDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    userId = json['userId'];
    orderProductNo = json['orderProductNo'];
    productNo = json['productNo'];
    content = json['content'];
    rate = json['rate'];
    writeDate = json['writeDate'];
    if(json['product'] != null) {
      product = ProductDTO.fromJson(json: json['product']);
    }
    averageRate = json['averageRate'];
    users = List<String>.from(json['users'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['userId'] = userId;
    data['orderProductNo'] = orderProductNo;
    data['productNo'] = productNo;
    data['content'] = content;
    data['rate'] = rate;
    data['writeDate'] = writeDate;
    data['product'] = product;
    data['averageRate'] = averageRate;
    data['users'] = users;
    return data;
  }

  @override
  String toString() {
    return "ReviewDTO{"
        "no: $no,"
        " userId: $userId,"
        " orderProductNo: $orderProductNo,"
        " productNo: $productNo,"
        " content: $content,"
        " rate: $rate,"
        " product: $product,"
        " writeDate: $writeDate,"
        " averageRate: $averageRate,"
        " users: $users}";
  }

}