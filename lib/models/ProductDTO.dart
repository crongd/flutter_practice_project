class ProductDTO {
  int? no;
  String? title;
  String? mainImg;
  List<String>? images;
  int? price;

  ProductDTO({
    this.no,
    this.title,
    this.mainImg,
    this.images,
    this.price
  });

  ProductDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    title = json['title'];
    mainImg = json['mainImg'];
    images = List<String>.from(json['images'] ?? []);
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['title'] = title;
    data['mainImg'] = mainImg;
    data['price'] = price;
    return data;
  }

  @override
  String toString() {
    return "ProductDTO{no: $no, title: $title, mainImg: $mainImg, images: $images, price: $price}";
  }

}