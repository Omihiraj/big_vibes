import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/firebase_service.dart';
import 'forget_pass.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignIn({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isPassVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(children: [
          Image.asset(
            'assets/logo.jpeg',
            width: screenWidth / 2,
            height: screenWidth / 2,
            // fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Login Now",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Center(
            child: Text(
              "Please Enter the details below to continue",
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                color: const Color.fromARGB(115, 226, 220, 220),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  contentPadding:
                      EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                color: const Color.fromARGB(115, 226, 220, 220),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.only(
                      left: 20.0,
                      top: 15,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      highlightColor: secondaryColor,
                      icon: isPassVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isPassVisible = !isPassVisible;
                        });
                      },
                    )),
                obscureText: isPassVisible,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              FireService.signInFire(
                  emailController.text.trim(), passController.text.trim());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      primaryColor,
                      Colors.white,
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(195, 187, 187, 187),
                      offset: Offset(0.0, 2.0), //(x,y)
                      blurRadius: 10.0,
                    ),
                  ],
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(30)),
              child: const Center(
                  child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ForgetPass()));
            },
            child: const Center(
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: secondaryColor),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'No Account? ',
                style: const TextStyle(color: Color.fromARGB(166, 0, 0, 0)),
                children: <TextSpan>[
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'SignUp',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ]),
      ),
    );
  }
}
