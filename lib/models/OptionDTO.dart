class OptionDTO {
  int? no;
  int? productNo;
  String? name;

  OptionDTO({
    this.no,
    this.productNo,
    this.name
  });

  OptionDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    productNo = json['productNo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['productNo'] = productNo;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return "OptionDTO{"
        "no: $no,"
        " productNo: $productNo,"
        " name: $name";
  }

}