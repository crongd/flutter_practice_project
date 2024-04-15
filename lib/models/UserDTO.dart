class UserDTO {
  String? id;
  String? ci;
  String? password;
  String? email;
  String? tel;
  String? joinDate;

  UserDTO({
    this.id,
    this.ci,
    this.password,
    this.email,
    this.tel,
    this.joinDate
  });

  UserDTO.fromJson({required Map<String, dynamic> json}) {
    id = json['id'];
    ci = json['ci'];
    password = json['password'];
    email = json['email'];
    tel = json['tel'];
    joinDate = json['joinDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['ci'] = ci;
    data['password'] = password;
    data['email'] = email;
    data['tel'] = tel;
    data['joinDate'] = joinDate;
    return data;
  }

  @override
  String toString() {
    return "UserDTO{"
        "id: $id,"
        " ci: $ci,"
        " password: $password,"
        " email: $email,"
        " tel: $tel,"
        " joinDate: $joinDate";
  }

}