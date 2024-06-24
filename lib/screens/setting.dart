import 'package:dummy1/main.dart';
import 'package:dummy1/screens/availabilty.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/screens/personal_details.dart';
import 'package:dummy1/screens/update_email.dart';
import 'package:dummy1/screens/update_password.dart';
import 'package:dummy1/service/api_call.dart';
import 'package:flutter/material.dart';

import '../service/docModel.dart';
import 'home.dart';

class SettingScreen extends StatefulWidget {
  final DoctorModel doctor;
  const SettingScreen({super.key, required this.doctor});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  DoctorModel? _doctorModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _doctorModel = widget.doctor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        //height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(
          image: AssetImage("assets/images/img_signup.png"),
          fit: BoxFit.cover,
        )),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/images/img_6_1.png",
                scale: 3.5,
              ),
              const SizedBox(
                height: 32,
              ),
              // Image.asset(
              //   "assets/images/img_doc_1.png",
              //   scale: 3.3,
              // ),
              // SizedBox(
              //   height: 50,
              // ),

              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.86,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 3, // Blur radius
                        offset:
                            const Offset(0, 3), // Offset in x and y directions
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings),
                        Text(
                          "  Settings",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    BlueShadowButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Availability(
                                    doc: _doctorModel!,
                                  )));
                        },
                        child: const Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Spacer(),
                            Text(
                              "Change Availability",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                          ],
                        ))),
                    const SizedBox(
                      height: 32,
                    ),
                    BlueShadowButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangeEmailScreen(
                                    doc: _doctorModel!,
                                  )));
                        },
                        child: const Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Spacer(),
                            Text(
                              "Change Email",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                          ],
                        ))),
                    const SizedBox(
                      height: 32,
                    ),
                    BlueShadowButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(
                                    doc: _doctorModel!,
                                  )));
                        },
                        child: const Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Spacer(),
                            Text(
                              "Change Password",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                          ],
                        ))),
                    SizedBox(
                      height: 16,
                    ),
                    MaterialButton(
                      onPressed: () => _showDeleteConfirmationDialog(context),
                      child: Text(
                        "Delete Acount",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await MySharedPreferences.saveIsLoggedIn(false);
                        await MySharedPreferences.saveToken("");
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const NavBar()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 32,
                          ),
                          Text(
                            " LOG_OUT",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    // BlueShadowButton(
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => NavBar()));
                    //     },
                    //     child: const Center(
                    //         child: Flex(
                    //       direction: Axis.horizontal,
                    //       children: [
                    //         Spacer(),
                    //         Text(
                    //           "Change Slot Timing",
                    //           style: TextStyle(
                    //               fontSize: 16,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w700),
                    //         ),
                    //         Spacer(),
                    //       ],
                    //     ))),
                    const SizedBox(
                      height: 32,
                    ),
                    const Spacer()
                  ],
                ),
              )
            ]),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                bool _isDeleted = await ApiHelper.deleteDoc();
                if (_isDeleted) {
                  await MySharedPreferences.saveIsLoggedIn(false);
                  await MySharedPreferences.saveToken("");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const NavBar()));
                }
                // Dismiss the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
