import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/constants.dart';
import '../../main.dart';
import '../../models/location.dart';
import '../../models/service.dart';
import '../../services/firebase_service.dart';
import '../../services/location_finder.dart';
import '../../utils/calculator.dart';
import '../../utils/date_gen.dart';
import 'auth_page.dart';

enum Status { room, hour, cleaner }

class ServiceDetails extends StatefulWidget {
  final Service service;
  const ServiceDetails({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        userLog = true;
        userId = user.email;

        print('User is signed in!');
      }
    });
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
                      child: Text(widget.service.name,
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
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Number of Rooms",
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
          child: Text("Number of Hours",
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
          child: Text("Number of Cleaners",
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
                    serviceId: widget.service.id);
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
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Select Date",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(height: 120, child: dateListSlide()),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: const Text("Select Time",
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            InkWell(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: secondaryColor, // <-- SEE HERE
                            onPrimary: Colors.white, // <-- SEE HERE
                            onSurface: primaryColor, // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: Colors.grey, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    initialTime: time,
                  );
                  if (newTime == null) return;
                  setState(() {
                    time = newTime;
                    String hour = time.hour.toString().padLeft(2, '0');
                    String minute = time.minute.toString().padLeft(2, '0');
                    selectTime = "$hour:$minute";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Text(
                      (time.hour).toString().padLeft(2, '0') +
                          ":" +
                          (time.minute).toString().padLeft(2, '0'),
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                )),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: InkWell(
            onTap: () {
              if (userLog) {
                FireService.putBook(
                    context: context,
                    userId: userId!,
                    beds: rooms,
                    cleaners: cleaners,
                    date: Timestamp.fromDate(
                        DateTime.parse(selectDate! + " " + selectTime!)),
                    hours: hours,
                    location: [],
                    materials: {"1": 1},
                    price: total,
                    serviceId: widget.service.id,
                    img: widget.service.img,
                    serviceName: widget.service.name);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // return ServiceDetails(
                                //   service: widget.service,
                                // );
                                return const MainPage();
                              } else {
                                return const AuthPage();
                              }
                            })));
              }

              print(selectDate! + " " + selectTime!);
            },
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30), right: Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    primaryColor,
                    Colors.white,
                  ],
                ),
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
                  child: Text("Add to cart",
                      style: TextStyle(
                          color: secondaryColor,
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
        return secondaryColor;
      } else if (status == Status.hour && hours == itemNo) {
        return secondaryColor;
      } else if (status == Status.room && rooms == itemNo) {
        return secondaryColor;
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

  Widget dateListSlide() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: getDate()[0].length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  String monthNo =
                      getDate()[3][index].toString().padLeft(2, '0');
                  String day = getDate()[0][index].toString().padLeft(2, '0');
                  selectDate = "$year-$monthNo-$day";
                  daySelectItem = index;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color:
                        index == daySelectItem ? primaryColor : Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      (getDate()[1][index]),
                      style: TextStyle(
                          color: index == daySelectItem
                              ? secondaryColor
                              : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                    Center(
                        child: Text(
                      (getDate()[0][index]).toString().padLeft(2, "0"),
                      style: TextStyle(
                          color: index == daySelectItem
                              ? secondaryColor
                              : Colors.grey,
                          fontSize: 28,
                          fontWeight: FontWeight.w500),
                    )),
                    Center(
                        child: Text(
                      (getDate()[2][index]),
                      style: TextStyle(
                          color: index == daySelectItem
                              ? secondaryColor
                              : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
