class CategoryDTO {
  int? no;
  String? name;
  int? parentNo;
  int? level;
  List<CategoryDTO>? categorys;

  CategoryDTO({
    this.no,
    this.name,
    this.parentNo,
    this.level,
    this.categorys
  });

  CategoryDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    name = json['name'];
    parentNo = json['parent_no'];
    level = json['level'];
    if(json['categorys'] != null) {
      categorys = (json['categorys'] as List).map((json) => CategoryDTO.fromJson(json: json)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['name'] = name;
    data['parent_no'] = parentNo;
    data['level'] = level;
    if (categorys != null) {
      data['categorys'] = categorys!.map((option) => option.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "ProductDTO{"
        "no: $no,"
        " title: $name,"
        " mainImg: $parentNo,"
        " images: $level,"
        " categorys: $categorys }";
  }

}