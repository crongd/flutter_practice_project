class CategoryDTO {
  int? no;
  String? name;
  int? parent_no;
  int? level;

  CategoryDTO({
    this.no,
    this.name,
    this.parent_no,
    this.level
  });

  CategoryDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    name = json['name'];
    parent_no = json['parent_no'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['name'] = name;
    data['parent_no'] = parent_no;
    data['level'] = level;
    return data;
  }

  @override
  String toString() {
    return "ProductDTO{"
        "no: $no,"
        " title: $name,"
        " mainImg: $parent_no,"
        " images: $level,";
  }

}