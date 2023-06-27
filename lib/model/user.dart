class User {
  String? id;
  String? name;
  String? num;
  String? phone;
  String? email;
  String? datereg;
  String? state;
  String? city;
  String? lat;
  String? long;

  User(
      {this.id,
      this.name,
      this.num,
      this.phone,
      this.email,
      this.datereg,
      this.state,
      this.city,
      this.lat,
      this.long});

  User.fromJson(Map<String, dynamic> json) {
    id = json['user_id'];
    name = json['user_name'];
    num = json['user_matric'];
    phone = json['user_phone'];
    email = json['user_email'];
    datereg = json['user_datereg'];
    state = json['user_state'];
    city = json['user_city'];
    lat = json['user_lat'];
    long = json['user_long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = id;
    data['user_name'] = name;
    data['user_matric'] = num;
    data['user_phone'] = phone;
    data['user_email'] = email;
    data['user_datereg'] = datereg;
    data['user_state'] = state;
    data['user_city'] = city;
    data['user_lat'] = lat;
    data['user_long'] = long;
    return data;
  }
}
