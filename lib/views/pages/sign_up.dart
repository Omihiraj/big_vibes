import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/firebase_service.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUp({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
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
        child: Form(
          key: formKey,
          child: ListView(children: [
            Image.asset(
              'assets/logo.jpeg',
              width: screenWidth / 2,
              height: screenWidth / 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                "Register Now",
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
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    contentPadding:
                        EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                    border: InputBorder.none,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter Valid Email'
                          : null,
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
                child: TextFormField(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                FireService.signUpFire(emailController.text.trim(),
                    passController.text.trim(), formKey);
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
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                    child: Text(
                  "Sign Up",
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
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Color.fromARGB(166, 0, 0, 0)),
                  children: <TextSpan>[
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'SignIn',
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
      ),
    );
  }
}
