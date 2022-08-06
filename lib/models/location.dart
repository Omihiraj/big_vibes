import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  Location({
    required this.location,
    required this.lName,
    required this.price,
    required this.serviceId,
  });

  GeoPoint location;
  String lName;
  int price;
  String serviceId;

  static Location fromJson(Map<String, dynamic> json) => Location(
      location: json["location"],
      lName: json["location-name"],
      price: json["price"],
      serviceId: json["service-id"]);
}
