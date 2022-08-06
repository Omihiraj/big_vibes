import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  Service({
    required this.id,
    required this.img,
    required this.name,
    required this.price,
  });
  String id;
  String img;
  String name;
  int price;

  static Service fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        img: json["img"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
        "name": name,
        "price": price,
      };
}
