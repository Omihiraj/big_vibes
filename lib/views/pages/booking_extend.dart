import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/book.dart';
import '../../services/location_finder.dart';
import '../../utils/calculator.dart';

enum Status { room, hour, cleaner }

class BookExtend extends StatefulWidget {
  final Book service;
  const BookExtend({Key? key, required this.service}) : super(key: key);

  @override
  State<BookExtend> createState() => _BookExtendState();
}

class _BookExtendState extends State<BookExtend> {
  int rooms = 0;
  int hours = 0;
  int cleaners = 0;
  int total = 0;
  int daySelectItem = 0;
  double? latitude;
  double? longitude;
  String year = DateTime.now().year.toString();
  String? selectDate;
  String? selectTime;
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  bool userLog = false;
  String? userId;
  @override
  Widget build(BuildContext context) {
    print("Rooms $rooms   Hours  $hours  Cleaners  $cleaners");
    LocationFinder.determinePosition().then((Map<String, dynamic> loc) {
      print("Latitude:${loc['latitude']} Altitude:${loc['altitude']}");

      latitude = double.parse(loc['latitude']);
      longitude = double.parse(loc['altitude']);
    });

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(children: [
        Stack(
          children: [
            Image.network(
              widget.service.img,
              width: screenWidth,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: 100,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: screenWidth * 0.12,
                      height: 8,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(50, 158, 158, 158),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(widget.service.serviceName,
                          maxLines: 2,
                          style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        const ListTile(
          leading: Icon(Icons.calendar_month, color: primaryColor),
          title: Text("Date"),
          subtitle: Text(
            "2022-07-11     08:30 A.M",
            style: TextStyle(color: secondaryColor),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.bed,
            color: primaryColor,
          ),
          title: const Text("No of Rooms"),
          subtitle: Text(widget.service.beds.toString().padLeft(2, "0"),
              style: const TextStyle(color: secondaryColor)),
        ),
        ListTile(
          leading: const Icon(Icons.timelapse_rounded, color: primaryColor),
          title: const Text("No of Hours"),
          subtitle: Text(widget.service.hours.toString().padLeft(2, "0"),
              style: const TextStyle(color: secondaryColor)),
        ),
        ListTile(
          leading: const Icon(Icons.person, color: primaryColor),
          title: const Text("No of Cleaners"),
          subtitle: Text(widget.service.cleaners.toString().padLeft(2, "0"),
              style: const TextStyle(color: secondaryColor)),
        ),
        ListTile(
          leading: const Icon(Icons.money, color: primaryColor),
          title: const Text("Price"),
          subtitle: Text("\$${widget.service.price}.00",
              style: const TextStyle(color: secondaryColor)),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30), right: Radius.circular(30)),
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              width: screenWidth * 0.8,
              child: const Center(
                  child: Text("Complete Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600))),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Container(
            child: const Text("Extend Order",
                maxLines: 2,
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Extend Rooms",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 70,
            child: listSlide(startNo: 0, count: 10, status: Status.room)),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Extend Hours",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 70,
            child: listSlide(startNo: 1, count: 10, status: Status.hour)),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Extend Cleaners",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 70,
            child: listSlide(startNo: 0, count: 10, status: Status.cleaner)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.4,
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                "\$$total.00",
                style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              )),
            ),
            InkWell(
              onTap: () async {
                Calculator sum = Calculator(
                    bedNo: rooms,
                    hours: hours,
                    lat: "4.5",
                    alt: "2.5",
                    serviceId: widget.service.serviceId);
                total = await sum.calculate();
                setState(() {
                  total = total;
                });
              },
              child: Container(
                width: screenWidth * 0.4,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: secondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: const Center(
                    child: Text(
                  "Generate Price",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30), right: Radius.circular(30)),
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              width: screenWidth * 0.8,
              child: const Center(
                  child: Text("Extend Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600))),
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ]),
    );
  }

  checkColor(Status status, int itemNo, String widgetType) {
    if (widgetType == "Container") {
      if (status == Status.cleaner && cleaners == itemNo) {
        return primaryColor;
      } else if (status == Status.hour && hours == itemNo) {
        return primaryColor;
      } else if (status == Status.room && rooms == itemNo) {
        return primaryColor;
      } else {
        return Colors.white;
      }
    } else if (widgetType == "Text") {
      if (status == Status.cleaner && cleaners == itemNo) {
        return Colors.white;
      } else if (status == Status.hour && hours == itemNo) {
        return Colors.white;
      } else if (status == Status.room && rooms == itemNo) {
        return Colors.white;
      } else {
        return Colors.grey;
      }
    }
  }

  Widget listSlide(
      {required int startNo, required int count, required Status status}) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: ((context, index) {
          int itemNo = index + 1 + startNo;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (status == Status.cleaner) {
                    cleaners = itemNo;
                  } else if (status == Status.hour) {
                    hours = itemNo;
                  } else if (status == Status.room) {
                    rooms = itemNo;
                  }
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color: checkColor(status, itemNo, "Container")),
                child: Center(
                    child: Text(
                  (itemNo).toString().padLeft(2, "0"),
                  style: TextStyle(
                      color: checkColor(status, itemNo, "Text"),
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ),
          );
        }));
  }
}
