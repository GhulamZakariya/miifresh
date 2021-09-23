import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_viewer/image_viewer.dart';

import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'constants.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(35),
              width: double.maxFinite,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                children: [
                  SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset(
                        "assets/images/avator.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppData.user.firstName +" "+ AppData.user.lastName,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    AppData.user.email,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.maxFinite,
              color: Colors.black12,
              child: Text(
                "Personal",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [Expanded(child: Text("Name")), Text(AppData.user.firstName +" "+ AppData.user.lastName)],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Phone")),
                      Text(AppData.user.phone)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Email")),
                      Text(AppData.user.email)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("D-O-B")),
                      Text(AppData.user.dob)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Blood Group")),
                      Text(AppData.user.bloodGroup)
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.maxFinite,
              color: Colors.black12,
              child: Text(
                "Bike",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Bike Name")),
                      Text(AppData.user.bikeName)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Bike Details")),
                      Text(AppData.user.bikeDetails)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [Expanded(child: Text("Color")), Text(AppData.user.bikeColor)],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Owner Name")),
                      Text(AppData.user.ownerName)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("registration No")),
                      Text(AppData.user.vehicleRegistrationNumber)
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("License")),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetailScreen(Constants.ECOMMERCE_URL + AppData.user.drivingLicenseImage)),),
                        child: Icon(
                          Icons.credit_card,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("registration No")),
                      GestureDetector(
                        child: Icon(
                          Icons.credit_card,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.maxFinite,
              color: Colors.black12,
              child: Text(
                "Social",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Aadhar Card")),
                      GestureDetector(
                        child: Icon(
                          Icons.credit_card,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Voter ID")),
                      Text("123456789")
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Bank Passbook")),
                      GestureDetector(
                        child: Icon(
                          Icons.credit_card,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Pan Card")),
                      GestureDetector(
                        child: Icon(
                          Icons.credit_card,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.maxFinite,
              color: Colors.black12,
              child: Text(
                "Refferral",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Refferrer Name")),
                      Text("Some name")
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Refferrer Aadhaar")),
                      GestureDetector(
                        child: Icon(
                          Icons.credit_card,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageDetailScreen extends StatelessWidget {

  String imageUrl = "";

  ImageDetailScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Image.network(
            imageUrl,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}