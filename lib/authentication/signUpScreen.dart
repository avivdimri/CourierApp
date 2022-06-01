import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/splashScreen.dart';
import 'package:my_app/authentication/global.dart';
import 'package:my_app/authentication/loginScreen.dart';
import 'package:my_app/models/courier.dart';
import 'package:my_app/widgets/progressDialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController companyIdTextEditingController =
      TextEditingController();
  List<String> vehicleTypesList = ["bike", "scooter", "car", "van"];
  String? selectdVehicleType;

  validateForm() {
    if (firstNameTextEditingController.text.length < 3 ||
        lastNameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters.");
    } else if (selectdVehicleType == Null) {
      Fluttertoast.showToast(msg: "vehicle tepe must be choosen");
    } else {
      saveCourierInfo();
    }
  }

  saveCourierInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, please wait...",
          );
        });
    Courier courier = Courier(
        first_name: firstNameTextEditingController.text.trim(),
        last_name: lastNameTextEditingController.text.trim(),
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
        phone_number: phoneTextEditingController.text.trim(),
        VehicleType: selectdVehicleType!);
    Map<String, dynamic> jsonData = courier.toJson();
    Response? response;
    try {
      response = await dio.post(basicUri + 'api/register', data: jsonData);
    } catch (onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    var data = response!.data;
    if (data == "The registerion of user is completed successfuly!") {
      Fluttertoast.showToast(
          msg: "Acocount has created.", timeInSecForIosWeb: 3);
    } else {
      Fluttertoast.showToast(msg: "Error. " + data, timeInSecForIosWeb: 3);
    }
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const MySplashScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("images/35303782.jpg"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Sign up",
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: firstNameTextEditingController,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "First Name",
                hintText: "First Name",
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
              controller: lastNameTextEditingController,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Last Name",
                hintText: "Last Name",
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
            TextField(
              controller: phoneTextEditingController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Phone",
                hintText: "Phone",
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
            DropdownButton(
              iconSize: 20,
              dropdownColor: const Color.fromARGB(218, 255, 255, 255),
              hint: const Text(
                "Please choose vehicle type",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
              value: selectdVehicleType,
              items: vehicleTypesList.map((vehicle) {
                return DropdownMenuItem(
                  child: Text(
                    vehicle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  value: vehicle,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectdVehicleType = newValue.toString();
                });
              },
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
                  "Create Account",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const LoginScreen()));
              },
              child: const Text(
                "Already have an account? Log in here",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
