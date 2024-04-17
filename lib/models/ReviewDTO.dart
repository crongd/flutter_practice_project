class ReviewDTO {
  int? no;
  String? userId;
  int? orderProductNo;
  int? productNo;
  String? content;
  int? rate;

  ReviewDTO({
    this.no,
    this.userId,
    this.orderProductNo,
    this.productNo,
    this.content,
    this.rate
  });

  ReviewDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    userId = json['userId'];
    orderProductNo = json['orderProductNo'];
    productNo = json['productNo'];
    content = json['content'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['userId'] = userId;
    data['orderProductNo'] = orderProductNo;
    data['productNo'] = productNo;
    data['content'] = content;
    data['rate'] = rate;
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
        " rate: $rate}";
  }

}