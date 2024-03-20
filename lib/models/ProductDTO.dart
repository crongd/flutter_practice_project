class ProductDTO {
  int? no;
  String? title;
  String? mainImg;
  List<String>? images;
  int? price;
  int? amount;

  ProductDTO({
    this.no,
    this.title,
    this.mainImg,
    this.images,
    this.price,
    this.amount
  });

  ProductDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    title = json['title'];
    mainImg = json['mainImg'];
    images = List<String>.from(json['images'] ?? []);
    price = json['price'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['title'] = title;
    data['mainImg'] = mainImg;
    data['price'] = price;
    data['amount'] = amount;
    return data;
  }

  @override
  String toString() {
    return "ProductDTO{"
        "no: $no,"
        " title: $title,"
        " mainImg: $mainImg,"
        " images: $images,"
        " price: $price,"
        " amount: $amount}";
  }

}