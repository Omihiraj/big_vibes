import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/book.dart';
import '../services/firebase_service.dart';
import 'pages/booking_extend.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool userLog = true;
  String? userId;
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     userLog = true;
    //     userId = user.email;

    //     print('User is signed in!');
    //   }
    // });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Orders",
              style: TextStyle(color: secondaryColor, fontSize: 32),
            ),
            centerTitle: true,
            bottom: const TabBar(
                indicatorColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.amber,
                tabs: [
                  Tab(
                    text: "Active Orders",
                  ),
                  Tab(
                    text: "Complete Orders",
                  )
                ]),
          ),
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = FirebaseAuth.instance.currentUser!;
                  return TabBarView(children: [
                    StreamBuilder<List<Book>>(
                      stream: FireService.activeOrders(user.email!),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              if (snapshot.data == null) {
                                return const Text('No data to show');
                              } else {
                                final bookings = snapshot.data!;

                                return ListView.builder(
                                  itemCount: bookings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return builtService(bookings[index]);
                                  },
                                );
                              }
                            }
                        }
                      },
                    ),
                    StreamBuilder<List<Book>>(
                      stream: FireService.completeOrders(user.email!),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              if (snapshot.data == null) {
                                return const Text(
                                  'No data to show',
                                );
                              } else {
                                final bookings = snapshot.data!;

                                return ListView.builder(
                                  itemCount: bookings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return builtService(bookings[index]);
                                  },
                                );
                              }
                            }
                        }
                      },
                    ),
                  ]);
                } else {
                  return const Center(child: Text("Please Log"));
                }
              })),
    );
  }

  Widget builtService(Book book) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.025),
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => BookExtend(service: book))),
        child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.5), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        child: Text(
                          maxLines: 2,
                          book.serviceName,
                          style: const TextStyle(
                              fontSize: 20,
                              color: titleIconColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("\$ ${book.price}.00",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                          )),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.bed,
                            color: titleIconColor,
                          ),
                          Text(
                            book.beds.toString(),
                            style: const TextStyle(
                                color: secondaryColor, fontSize: 20),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          const Icon(
                            Icons.timelapse_rounded,
                            color: titleIconColor,
                          ),
                          Text(
                            book.hours.toString() + "hrs",
                            style: const TextStyle(
                                color: secondaryColor, fontSize: 20),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(0), right: Radius.circular(20)),
                  child: Image.network(
                    fit: BoxFit.cover,
                    book.img,
                    width: screenWidth * 0.5,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
