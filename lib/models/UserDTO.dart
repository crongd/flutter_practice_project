class UserDTO {
  int? no;
  String? id;
  String? pw;
  String? name;

  UserDTO({
    this.no,
    this.id,
    this.pw,
    this.name
  });

  UserDTO.fromJson({required Map<String, dynamic> json}) {
    no = json['no'];
    id = json['id'];
    pw = json['pw'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['no'] = no;
    data['id'] = id;
    data['pw'] = pw;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return "UserDTO{"
        "no: $no,"
        " id: $id,"
        " pw: $pw,"
        " name: $name";
  }

}