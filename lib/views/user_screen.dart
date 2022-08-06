import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/user_data.dart';
import 'pages/auth_page.dart';
import 'pages/user_submit.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const UserPage();
              } else {
                return const AuthPage();
              }
            }));
  }
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    bool accountSetup = false;
    final screenWidth = MediaQuery.of(context).size.width;
    final userAc = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("user-id", isEqualTo: userAc.email)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          leading: Container(),
          title: const Text("User Details"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserSubmit(userId: userAc.email!)));
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 500,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      final user = UserData.fromJson(data);

                      return Container(
                          child: Column(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: user.img.isNotEmpty
                                  ? BorderRadius.circular(500)
                                  : BorderRadius.circular(0),
                              child: user.img.isNotEmpty
                                  ? Image.network(
                                      user.img,
                                      width: screenWidth / 2,
                                    )
                                  : Image.asset(
                                      "assets/user.png",
                                      width: screenWidth / 2,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text("Name"),
                            subtitle: user.name.isNotEmpty
                                ? Text(user.name)
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserSubmit(
                                                    user: user,
                                                    userId: userAc.email!,
                                                  )));
                                    },
                                    child: const Text(
                                      "Please Setup Your Name >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline),
                                    ))),
                        ListTile(
                            leading: const Icon(Icons.location_on),
                            title: const Text("Address"),
                            subtitle: user.address.isNotEmpty
                                ? Text(user.address)
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserSubmit(
                                                  user: user,
                                                  userId: userAc.email!)));
                                    },
                                    child: const Text(
                                      "Please Setup Your Name >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline),
                                    ))),
                        ListTile(
                            leading: const Icon(Icons.mobile_friendly),
                            title: const Text("Mobile"),
                            subtitle: user.mobile.isNotEmpty
                                ? Text(user.mobile)
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserSubmit(
                                                  user: user,
                                                  userId: userAc.email!)));
                                    },
                                    child: const Text(
                                      "Please Setup Your Name >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline),
                                    ))),
                        ListTile(
                            leading: const Icon(Icons.calendar_month),
                            title: const Text("Date Of Birth"),
                            subtitle: user.dateofbirth.isNotEmpty
                                ? Text(user.dateofbirth)
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserSubmit(
                                                  user: user,
                                                  userId: userAc.email!)));
                                    },
                                    child: const Text(
                                      "Please Setup Your Name >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline),
                                    ))),
                      ]));
                    }).toList());
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
