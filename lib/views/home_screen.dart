import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/service.dart';
import '../services/firebase_service.dart';
import 'pages/all_services.dart';
import 'pages/service_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> imgList = [
    "assets/cleaningvector.png",
    "assets/Laundry.png",
    "assets/Painting.png",
    "assets/Reparing.png",
    "assets/cleaningvector.png"
  ];
  List<String> catNameList = [
    "Cleaning",
    "Laundary",
    "Painting",
    "Air BNB",
    "Car Wash"
  ];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu),
          color: Color.fromARGB(255, 202, 202, 202),
          iconSize: 32,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 27,
              foregroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=461&q=80"),
            ),
          )
        ],
      ),
      drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset("assets/logo.jpeg",
                    height: 100, width: 100, scale: 5),
              ),
              const Center(
                  child: Text(
                "About",
                style: TextStyle(fontSize: 28),
              )),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Center(
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet faucibus ligula ac ultrices. Duis sem quam, dignissim eget est vel, condimentum suscipit nulla. Quisque feugiat enim vitae nunc accumsan aliquet. In viverra laoreet ullamcorper. Duis in mattis metus. Morbi et imperdiet purus. Nunc metus nunc, convallis eget risus eget, elementum accumsan sapien. Nunc justo diam, convallis quis erat laoreet, volutpat hendrerit erat. Quisque tristique ut mauris sed tempus.",
                  ),
                ),
              ),
            ],
          )),
      body: ListView(children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.25,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.normal,
                  color: Color.fromARGB(136, 158, 158, 158),
                  offset: Offset(0.0, 10.0), //(x,y)
                  blurRadius: 10.0,
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Hi User,",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "What",
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Service do",
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "you need?",
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Image.asset(
              "assets/main-cleaner.png",
              //width: screenWidth * 0.4,
              scale: 10,
              fit: BoxFit.cover,
            )
          ]),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Category",
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 120,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                categoryItem(imgList[index], catNameList[index]),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Services",
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllService())),
                child: const Text(
                  "See All>>",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 500,
          width: double.infinity,
          child: StreamBuilder<List<Service>>(
            stream: FireService.getServices(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    if (snapshot.data == null) {
                      return const Text('No data to show');
                    } else {
                      final services = snapshot.data!;

                      return ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (BuildContext context, int index) {
                          return builtService(services[index]);
                        },
                      );
                    }
                  }
              }
            },
          ),
        ),
      ]),
    );
  }

  Widget builtService(Service service) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceDetails(
                      service: service,
                    ))),
        child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(10.0, 10.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            //padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10), right: Radius.circular(25)),
                  child: Image.network(
                    fit: BoxFit.cover,
                    service.img,
                    width: screenWidth * 0.4,
                    height: 150,
                  ),
                ),
                Container(
                  width: screenWidth * 0.4,
                  padding: EdgeInsets.only(right: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("\$${service.price}/h",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget categoryItem(String img, String catName) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: 75,
          height: 75,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 0.0), //(x,y)
              blurRadius: 4.0,
            ),
          ], borderRadius: BorderRadius.circular(100), color: Colors.white),
          child: Center(
              child: Image.asset(
            img,
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          )),
        ),
        Text(catName),
      ],
    );
  }
}
