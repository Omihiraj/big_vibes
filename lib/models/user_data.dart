import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({
    required this.id,
    required this.img,
    required this.name,
    required this.mobile,
    required this.address,
    required this.dateofbirth,
    required this.cardNo,
    required this.cvv,
  });
  String id;
  String img;
  String name;
  String mobile;
  String address;
  String dateofbirth;
  String cardNo;
  String cvv;

  static UserData fromJson(Map<String, dynamic> json) => UserData(
      id: json["user-id"],
      img: json["user-img"],
      name: json["name"],
      mobile: json["mobile-no"],
      address: json["address"],
      dateofbirth: json["birthday"],
      cardNo: json["card-no"],
      cvv: json["cvv"]);

  Map<String, dynamic> toJson() => {
        "user-id": id,
        "user-img": img,
        "name": name,
        "mobile-no": mobile,
        "address": address,
        "birthday": dateofbirth,
        "card-no": cardNo,
        "cvv": cvv
      };
}
