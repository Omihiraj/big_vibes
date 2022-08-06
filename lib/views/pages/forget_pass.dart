import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/firebase_service.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({Key? key}) : super(key: key);

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              child: Text(
                "Receive an email \nto reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: secondaryColor,
                ),
                hintText: 'Email',
                contentPadding:
                    EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter Valid Email'
                      : null,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: secondaryColor,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  FireService.resetPass(emailController.text.trim());
                },
                icon: const Icon(Icons.email),
                label: const Text("Reset Password",
                    style: TextStyle(
                      fontSize: 24,
                    )))
          ],
        ),
      ),
    );
  }
}
