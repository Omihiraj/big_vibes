import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../models/get_total.dart';
import '../models/location.dart';
import '../models/service.dart';
import '../models/user_data.dart';
import '../utils/snack_bar.dart';
import '../views/cart_screen.dart';
import '../views/user_screen.dart';

class FireService {
  static Stream<List<Service>> getServices() => FirebaseFirestore.instance
      .collection('services')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Service.fromJson(doc.data())).toList());

  static Stream<List<Location>> getLocations(String id) => FirebaseFirestore
      .instance
      .collection("service-location")
      .where("service-id", isEqualTo: "7WFeiBlUllVLBkzFF7ey")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Location.fromJson(doc.data())).toList());

  static Future putBook(
      {required BuildContext context,
      required String userId,
      required int beds,
      required int cleaners,
      required Timestamp date,
      required int hours,
      required List<String> location,
      required Map<String, int> materials,
      required int price,
      required String serviceId,
      required String serviceName,
      required String img}) async {
    final String bookingId =
        FirebaseFirestore.instance.collection("booking").doc().id;
    final book =
        FirebaseFirestore.instance.collection("booking").doc(bookingId);
    final bookItem = Book(
        bookingId: bookingId,
        serviceName: serviceName,
        img: img,
        userId: userId,
        beds: beds,
        cleaners: cleaners,
        date: date,
        hours: hours,
        location: location,
        materials: materials,
        price: price,
        serviceId: serviceId,
        status: 0);

    final json = bookItem.toJson();
    await book
        .set(json)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartScreen())))
        .catchError((error) {
      print("Some Error Occured");
    });
  }

  static Stream<List<Book>> getBook(String id) => FirebaseFirestore.instance
      .collection("booking")
      .where("user-id", isEqualTo: id)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static Stream<List<Book>> activeOrders(String id) =>
      FirebaseFirestore.instance
          .collection("booking")
          .where("status", isEqualTo: 1)
          .where("user-id", isEqualTo: id)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static Stream<List<Book>> completeOrders(String id) =>
      FirebaseFirestore.instance
          .collection("booking")
          .where("status", isEqualTo: 2)
          .where("user-id", isEqualTo: id)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static deleteBook(String id) =>
      FirebaseFirestore.instance.collection("booking").doc(id).delete();

  static Future signInFire(String user, String pass) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: pass);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  static Future signUpFire(String user, String pass, final formKey) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: pass);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      print(e);
    }
  }

  static Future resetPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      print(e);
    }
  }

  static getTotal(String id, context) => FirebaseFirestore.instance
          .collection('booking')
          .where("user-id", isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        Provider.of<GetTotal>(context, listen: false).reset();
        querySnapshot.docs.forEach((doc) {
          Provider.of<GetTotal>(context, listen: false).add(doc["price"]);
        });
      });

  static Future addUserData({
    required BuildContext context,
    required String id,
    required String img,
    required String name,
    required String mobile,
    required String address,
    required String dateofbirth,
    required String cardNo,
    required String cvv,
  }) async {
    final userData = FirebaseFirestore.instance.collection("users").doc(id);
    final user = UserData(
        id: id,
        img: img,
        name: name,
        mobile: mobile,
        address: address,
        dateofbirth: dateofbirth,
        cardNo: cardNo,
        cvv: cvv);

    final json = user.toJson();

    userData.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userData
            .update(json)
            .then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserScreen())))
            .catchError((error) {
          print("Some Error Occured");
        });
      } else {
        userData
            .set(json)
            .then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserScreen())))
            .catchError((error) {
          print("Some Error Occured");
        });
      }
    });
  }
}
