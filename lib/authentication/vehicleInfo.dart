import 'package:flutter/material.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  TextEditingController VehicleTypeTextEditingController =
      TextEditingController();
  List<String> VehicleTypesList = ["bike", "scooter", "car", "van"];
  String? selectdVehicleType;
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
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("images/35303782.jpg"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please Fill Vehicle Details",
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: VehicleTypeTextEditingController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Company Id",
                hintText: "Company Id",
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
              // icon: Icon(Icons.),
              dropdownColor: const Color.fromARGB(218, 255, 255, 255),
              hint: const Text(
                "Please choose vehicle type",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
              value: selectdVehicleType,
              items: VehicleTypesList.map((vehicle) {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const VehicleInfoScreen()));
                }),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Save Now",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ))
          ],
        ),
      )),
    );
  }
}
