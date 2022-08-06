import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'models/get_total.dart';
import 'utils/snack_bar.dart';
import 'views/cart_screen.dart';
import 'views/home_screen.dart';
import 'views/order_screen.dart';
import 'views/pages/all_services.dart';
import 'views/user_screen.dart';
import 'widgets/custom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (context) => GetTotal(),
      builder: ((context, child) => const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final screens = [
    const HomeScreen(),
    const OrderScreen(),
    const CartScreen(),
    const UserScreen()
  ];
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[index],
      //body: const Text("Hello"),
      // bottomNavigationBar: NavigationBarTheme(
      //     data: const NavigationBarThemeData(indicatorColor: primaryColor),
      //     child: NavigationBar(
      //         selectedIndex: index,
      //         onDestinationSelected: (index) => setState(() {
      //               this.index = index;
      //             }),
      //         destinations: const [
      //           NavigationDestination(icon: Icon(Icons.home), label: "Home"),
      //           NavigationDestination(
      //               icon: Icon(Icons.card_giftcard), label: "Order"),
      //           NavigationDestination(
      //               icon: Icon(Icons.person), label: "Profile"),
      //           NavigationDestination(
      //               icon: Icon(Icons.home_work_outlined), label: "Company")
      //         ])),
      bottomNavigationBar: CustomNavBar(
        index: index,
        onChangedTab: onChangedTab,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AllService()));
        },
        backgroundColor: secondaryColor,
        splashColor: secondaryColor,
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }
}
