// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book(
      {required this.bookingId,
      required this.userId,
      required this.beds,
      required this.cleaners,
      required this.date,
      required this.hours,
      required this.location,
      required this.materials,
      required this.price,
      required this.serviceId,
      required this.serviceName,
      required this.img,
      required this.status});
  String bookingId;
  String userId;
  int beds;
  int cleaners;
  Timestamp date;
  int hours;
  List<String> location;
  Map<String, int> materials;
  int price;
  String serviceId;
  String serviceName;
  String img;
  int status;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
      bookingId: json["booking-id"],
      serviceName: json["service-name"],
      img: json["img"],
      userId: json["user-id"],
      beds: json["beds"],
      cleaners: json["cleaners"],
      date: json["date"],
      hours: json["hours"],
      location: List<String>.from(json["location"].map((x) => x)),
      materials: Map.from(json["materials"])
          .map((k, v) => MapEntry<String, int>(k, v)),
      price: json["price"],
      serviceId: json["service-id"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "booking-id": bookingId,
        "service-name": serviceName,
        "img": img,
        "user-id": userId,
        "beds": beds,
        "cleaners": cleaners,
        "date": date,
        "hours": hours,
        "location": location,
        "materials":
            Map.from(materials).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price": price,
        "service-id": serviceId,
        "status": status
      };
}
