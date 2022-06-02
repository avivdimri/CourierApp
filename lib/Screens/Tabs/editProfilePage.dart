import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../assistants/global.dart';
import '../../widgets/textFieldWidget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String firstName = courierInfo!.first_name;
  String lastName = courierInfo!.last_name;
  String phoneNumber = courierInfo!.phone_number;
  String selectdVehicleType = courierInfo!.VehicleType;
  List<String> vehicleTypesList = ["bike", "scooter", "car", "van"];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextFieldWidget(
                label: 'First Name',
                text: courierInfo!.first_name,
                onChanged: (first_name) {
                  setState(() {
                    firstName = first_name;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFieldWidget(
                label: 'Last Name',
                text: courierInfo!.last_name,
                onChanged: (last_name) {
                  setState(() {
                    lastName = last_name;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFieldWidget(
                label: 'Phone Number',
                text: courierInfo!.phone_number,
                onChanged: (phone_number) {
                  setState(() {
                    phoneNumber = phone_number;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Vehicle Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              DropdownButton(
                iconSize: 30,
                dropdownColor: const Color.fromARGB(218, 255, 255, 255),
                hint: const Text(
                  "Please choose vehicle type              ",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                value: selectdVehicleType,
                items: vehicleTypesList.map((vehicle) {
                  return DropdownMenuItem(
                    child: Text(
                      vehicle,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
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
                height: 66,
              ),
              ElevatedButton(
                  onPressed: (() {
                    validateAndSaveInfo();
                  }),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  )),
            ],
          ),
        ),
      ));
  validateAndSaveInfo() {
    if (firstName.length < 3 || lastName.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters.");
    } else if (selectdVehicleType == Null) {
      Fluttertoast.showToast(msg: "vehicle tepe must be choosen");
    } else {
      updateCourierInfo();
    }
  }

  void updateCourierInfo() async {
    var json = jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'Vehicle_type': selectdVehicleType
    });
    try {
      Response response = await dio.put(
        basicUri + 'updateInfoCourier/$userId',
        data: json,
      );

      print('User updated: ${response.data}');
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
