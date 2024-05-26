import 'package:dummy1/screens/availabilty.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/screens/upload.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';

import 'signup.dart';

class ProfilePage extends StatefulWidget {
  final DoctorModel doctor;
  const ProfilePage({super.key, required this.doctor});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DoctorModel? _doctorModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _doctorModel = widget.doctor;
    });
    //print(_doctorModel!.name.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/img_signup.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset(
                "assets/images/img_6_1.png",
                scale: 3.5,
              ),
              SizedBox(height: 32),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.86,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: AssetImage("assets/images/img_rectangle_2.png"),
                  ),
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      spreadRadius: 5,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    Text(
                      "Your Profile\n",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 74,
                        backgroundImage: NetworkImage(
                          _doctorModel!.profilePicUrl.isNotEmpty
                              ? _doctorModel!.profilePicUrl
                              : "https://healthkobucket.s3.ap-south-1.amazonaws.com/docId/a221fd11-1498-4cc2-95e7-4ad0338bf6bc-image_not_found.png",
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Dr. ${_doctorModel!.name}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "( ${_doctorModel!.speciality.toUpperCase()} )",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _doctorModel!.countryOfOrigin,
                      style: TextStyle(
                          //color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _doctorModel!.email,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Verification Status",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Phone Verified:    ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.verified_rounded,
                          color: Colors.green,
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Email Verified:      ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          _doctorModel!.isVerified
                              ? Icons.verified_rounded
                              : Icons.cancel_rounded,
                          color: _doctorModel!.isVerified
                              ? Colors.green
                              : Colors.redAccent,
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "RegNo Verified:    ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          _doctorModel!.isVerified
                              ? Icons.verified_rounded
                              : Icons.cancel_rounded,
                          color: _doctorModel!.isVerified
                              ? Colors.green
                              : Colors.redAccent,
                        )
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => NavBar(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 32.0,
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage("assets/images/img_rectangle_2.png"))),
//           )
//         ],
//       )