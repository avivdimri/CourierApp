import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/authentication/global.dart';
import 'package:my_app/authentication/signUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/splashScreen.dart';
import '../widgets/progressDialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginCourier();
    }
  }

  loginCourier() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Loging in, please wait...",
          );
        });

    var json = jsonEncode(<String, String>{
      'username': emailTextEditingController.text.trim(),
      'password': passwordTextEditingController.text.trim(),
    });
    var d = Dio();
    Response? response;
    try {
      response = await d.post(basicUri + 'sign_in_courier', data: json);
    } catch (onError) {
      Navigator.pop(context);
      print(onError.toString());
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      print(response);
      var id = response.data as String;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', emailTextEditingController.text.trim());
      prefs.setString('userId', id);
      setState(() {
        name = emailTextEditingController.text.trim();
        isLoggedIn = true;
        userId = id;
      });
      printstate("login screen");
      emailTextEditingController.clear();
      Fluttertoast.showToast(
          msg: "Sign in successfully.", timeInSecForIosWeb: 3);
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const MySplashScreen())));
    } else {
      // Navigator.pop(context);
      Fluttertoast.showToast(msg: "Sign in failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("images/35303782.jpg"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Log in",
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            TextField(
              controller: passwordTextEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Password",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: (() {
                  validateForm();
                }),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const SignUpScreen()));
              },
              child: const Text(
                "Do not have an account? Sign up here",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
