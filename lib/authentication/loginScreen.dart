import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/globalUtils/global.dart';
import 'package:my_app/authentication/signUpScreen.dart';
import '../Screens/enterScreen.dart';
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
          return ProgressBox(
            message: "Loging in, please wait...",
          );
        });

    var json = jsonEncode(<String, String>{
      'user_name': emailTextEditingController.text.trim(),
      'password': passwordTextEditingController.text.trim(),
    });
    Response? response;
    try {
      response = await dio.post(basicUri + 'api/login_courier', data: json);
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
      Navigator.pop(context);
    }
    if (response != null) {
      if (response.data == "wrong username or password") {
        Fluttertoast.showToast(msg: "Error: wrong username or password");
        Navigator.pop(context);
      } else {
        var id = response.data as String;

        prefs.setString('username', emailTextEditingController.text.trim());
        prefs.setString('userId', id);
        prefs.setString('isActive', "false");
        setState(() {
          name = emailTextEditingController.text.trim();
          isLoggedIn = true;
          userId = id;
          isCourierActive = false;
          statusText = "Offline";
        });
        emailTextEditingController.clear();
        Fluttertoast.showToast(
            msg: "Sign in successfully.", timeInSecForIosWeb: 3);
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const EnterScreen())));
      }
    } else {
      Fluttertoast.showToast(msg: "Sign in failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(246, 255, 255, 255),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset("images/logo.jpg"),
            ),
            const Text(
              "Log in",
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.black,
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
                color: Colors.black,
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
                  color: Colors.black,
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
                  primary: Color.fromARGB(255, 15, 148, 166),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const SignUpScreen()));
              },
              child: const Text(
                "Don't have an account? Sign up here",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
