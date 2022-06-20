import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/Tabs/homeTab.dart';
import 'package:my_app/Screens/Tabs/profileTab.dart';
import 'package:my_app/models/courier.dart';
import 'package:provider/provider.dart';

import '../globalUtils/global.dart';
import '../globalUtils/allDeliveriesInfo.dart';
import '../widgets/progressDialog.dart';
import '../widgets/textFieldWidget.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController firstNameTextEditingController;
  late final TextEditingController lastNameTextEditingController;
  late final TextEditingController phoneNumberTextEditingController;
  String? selectdVehicleType;
  List<String> vehicleTypesList = ["bike", "scooter", "car", "van"];

  @override
  void initState() {
    super.initState();
    firstNameTextEditingController = TextEditingController(
        text: Provider.of<AllDeliveriesInfo>(context, listen: false)
            .courierInfo
            .firstName);
    lastNameTextEditingController = TextEditingController(
        text: Provider.of<AllDeliveriesInfo>(context, listen: false)
            .courierInfo
            .lastName);
    phoneNumberTextEditingController = TextEditingController(
        text: Provider.of<AllDeliveriesInfo>(context, listen: false)
            .courierInfo
            .phoneNumber);
    selectdVehicleType = Provider.of<AllDeliveriesInfo>(context, listen: false)
        .courierInfo
        .vehicleType;
  }

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextFieldWidget(
                label: 'First Name',
                text: firstNameTextEditingController.text.trim(),
                controller: firstNameTextEditingController,
              ),
              const SizedBox(height: 20),
              TextFieldWidget(
                label: 'Last Name',
                text: lastNameTextEditingController.text.trim(),
                controller: lastNameTextEditingController,
              ),
              const SizedBox(height: 20),
              TextFieldWidget(
                label: 'Phone Number',
                text: phoneNumberTextEditingController.text.trim(),
                controller: phoneNumberTextEditingController,
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
                  "choose vehicle type      ",
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
                height: 42,
              ),
              ElevatedButton(
                  onPressed: (() async {
                    await validateAndSaveInfo();
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
  validateAndSaveInfo() async {
    if (firstNameTextEditingController.text.length < 3 ||
        lastNameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters.");
    } else if (selectdVehicleType == null) {
      Fluttertoast.showToast(msg: "vehicle tepe must be choosen");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => ProgressBox(
          message: "Saving, please wait...",
        ),
      );
      await updateCourierInfo();
      await getCourierInfo();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<int> updateCourierInfo() async {
    var json = jsonEncode(<String, String>{
      'firstName': firstNameTextEditingController.text.trim(),
      'lastName': lastNameTextEditingController.text.trim(),
      'phoneNumber': phoneNumberTextEditingController.text.trim(),
      'VehicleType': selectdVehicleType!
    });
    var response;
    try {
      response = await dio.put(
        basicUri + 'updateCourierInfo/$userId',
        data: json,
      );

      print('User updated: ${response.data}');
      return 0;
    } catch (e) {
      print('Error "updateCourierInfo" updating user: $e');
      return -1;
    }
  }

  Future<void> getCourierInfo() async {
    var response;
    try {
      response = await dio.get(basicUri + 'get_courier/$userId');
    } catch (onError) {
      print("error !!!! getCourierInfo function  ");
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
      // Navigator.pop(context);
    }
    if (response != null) {
      var jsonList = response.data;
      var data = json.decode(jsonList);
      Provider.of<AllDeliveriesInfo>(context, listen: false)
          .updateCourierInfo(Courier.fromJson(data));
    }
  }
}
