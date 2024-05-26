import 'package:dummy1/main.dart';

import 'package:dummy1/screens/profile_page.dart';

import 'package:dummy1/service/api_call.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';

class Availability extends StatefulWidget {
  final DoctorModel doc;
  const Availability({super.key, required this.doc});

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  Set<String> selectedOptions = Set<String>();

  TextEditingController _homeVisitBySlotFee = TextEditingController();
  //TextEditingController _homeVisitImmediateFee = TextEditingController();
  TextEditingController _clinicAppointmentFee = TextEditingController();
  TextEditingController _videoConsultancyFee = TextEditingController();

  TextEditingController _clinicNameController = TextEditingController();
  TextEditingController _clinicAddressController = TextEditingController();

  DoctorModel? _doctorModel;

  bool _isLoading = false;

  bool? _isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLogedIn();
  }

  isLogedIn() async {
    _isLoggedIn = await MySharedPreferences.getIsLoggedIn();
    setState(() {
      _isLoggedIn;
      _doctorModel = widget.doc;
    });
    print(_doctorModel!.countryOfOrigin);
    // print(_isLoggedIn! &&
    //     (_doctorModel!.clinicAppointmentFee.contains("null") ||
    //         _doctorModel!.clinicAppointmentFee.isEmpty));
    setState(() {
      if (_doctorModel!.homeVisitBySlot) {
        selectedOptions.add("Option 1");
        _homeVisitBySlotFee.text = _doctorModel!.homeVisitBySlotFee.toString();
      } else {
        _homeVisitBySlotFee.text = "0";
      }

      // if (_doctorModel!.homeVisitImmediate) {
      //   selectedOptions.add("Option 2");
      //   _homeVisitImmediateFee.text = _doctorModel!.homeVisitImmediateFee;
      // }

      if (_doctorModel!.clinicAppointment) {
        selectedOptions.add("Option 3");
        _clinicAppointmentFee.text =
            _doctorModel!.clinicAppointmentFee.toString();
        _clinicNameController.text = _doctorModel!.clinicName;
        _clinicAddressController.text = _doctorModel!.clinicAddress;
      } else {
        _clinicAppointmentFee.text = "0";
      }
      if (_doctorModel!.videoConsultancy) {
        selectedOptions.add("Option 4");
        _videoConsultancyFee.text =
            _doctorModel!.videoConsultancyFee.toString();
      } else {
        _videoConsultancyFee.text = "0";
      }
    });
  }

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void onNextPressed() async {
    //print('Selected Options: $selectedOptions');

    if (selectedOptions.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select atleat one option'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }

    setState(() {
      _doctorModel = _doctorModel!.updateField(
          homeVisitBySlot: selectedOptions.contains("Option 1"),
          homeVisitBySlotFee: int.parse(_homeVisitBySlotFee.text.trim()),
          // homeVisitImmediate: selectedOptions.contains("Option 2"),
          // homeVisitImmediateFee: _homeVisitImmediateFee.text.trim(),
          clinicAppointment: selectedOptions.contains("Option 3"),
          clinicAppointmentFee: int.parse(_clinicAppointmentFee.text.trim()),
          videoConsultancy: selectedOptions.contains("Option 4"),
          videoConsultancyFee: int.parse(_videoConsultancyFee.text.trim()),
          clinicName: _clinicNameController.text.trim(),
          clinicAddress: _clinicAddressController.text.trim());
    });
    print(_doctorModel!.countryOfOrigin);
    if (_isLoggedIn ?? false) {
      Map _res = await ApiHelper.updateDoctor(
          _doctorModel!.id, _doctorModel!.toJson());

      if (_res["success"] == true) {
        //DoctorModel _doc = DoctorModel.fromJson(_res["data"]);
        setState(() {
          _isLoading = false;
        });
        //print("object");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ProfilePage(
                  doctor: DoctorModel.fromJson(_res["data"]),
                )));
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_res["message"]}'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } else {
      print(_doctorModel!.countryOfOrigin);
      var res = await ApiHelper.registerDoctor(_doctorModel!.toJson());
      print(res);
      if (res["status"] == true) {
        Map _res = await ApiHelper.login(
            "", _doctorModel!.password, _doctorModel!.phone);

        if (_res["success"] == true) {
          //DoctorModel _doc = DoctorModel.fromJson(_res["data"]);
          await MySharedPreferences.saveToken(_res["token"]);
          await MySharedPreferences.saveIsLoggedIn(true);
          //print("object");
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ProfilePage(
                    doctor: DoctorModel.fromJson(_res["data"]),
                  )));
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('login: ${_res["message"]}'),
              duration: Duration(seconds: 2), // Adjust duration as needed
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('register: ${res["message"]}'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      //print(_doctorModel!.profilePicUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/img_signup.png"),
                      fit: BoxFit.cover,
                    )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        "assets/images/img_6_1.png",
                        scale: 3.5,
                      ),
                      SizedBox(
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
                        padding: EdgeInsets.all(0),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.86,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.06), // Shadow color
                                spreadRadius: 5, // Spread radius
                                blurRadius: 3, // Blur radius
                                offset: const Offset(
                                    0, 3), // Offset in x and y directions
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios_new),
                                    onPressed: () {
                                      Navigator.of(context).pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                'Your Availability',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 32),
                              CheckboxListTile(
                                title: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Icon(Icons.add_home_work),
                                    Text('  Home Visit by Slot',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                value: selectedOptions.contains('Option 1'),
                                onChanged: (value) => toggleOption('Option 1'),
                              ),
                              if (selectedOptions.contains("Option 1")) ...{
                                TextField(
                                  controller: _homeVisitBySlotFee,
                                  decoration: InputDecoration(
                                    hintText: _doctorModel!.homeVisitBySlot
                                        ? _doctorModel!.homeVisitBySlotFee
                                            .toString()
                                        : "Enter Your fee", // Hint text
                                  ),
                                ),
                              },
                              Divider(),
                              // CheckboxListTile(
                              //   title: Flex(
                              //     direction: Axis.horizontal,
                              //     children: [
                              //       Icon(Icons.home_repair_service),
                              //       Text(
                              //         '  Home Visit Immediate',
                              //         style: TextStyle(fontSize: 14),
                              //         softWrap: true,
                              //       ),
                              //     ],
                              //   ),
                              //   value: selectedOptions.contains('Option 2'),
                              //   onChanged: (value) => toggleOption('Option 2'),
                              // ),
                              // if (selectedOptions.contains("Option 2")) ...{
                              //   TextField(
                              //     controller: _homeVisitImmediateFee,
                              //     enabled: !_isLoggedIn!,
                              //     decoration: InputDecoration(
                              //       hintText: _doctorModel!.homeVisitImmediate
                              //           ? _doctorModel!.homeVisitImmediateFee
                              //           : "Enter Your fee", // Hint text
                              //     ),
                              //   ),
                              // },
                              // Divider(),

                              CheckboxListTile(
                                title: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Icon(Icons.video_call),
                                    Text('  Video Consultancy',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                value: selectedOptions.contains('Option 4'),
                                onChanged: (value) => toggleOption('Option 4'),
                              ),
                              if (selectedOptions.contains("Option 4")) ...{
                                TextField(
                                  controller: _videoConsultancyFee,
                                  decoration: InputDecoration(
                                    hintText: _doctorModel!.videoConsultancy
                                        ? _doctorModel!.videoConsultancyFee
                                            .toString()
                                        : "Enter Your fee", // Hint text
                                  ),
                                ),
                              },
                              Divider(),
                              CheckboxListTile(
                                title: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Icon(Icons.store),
                                    Text('  Clinic Appointment',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                value: selectedOptions.contains('Option 3'),
                                onChanged: (value) => toggleOption('Option 3'),
                              ),
                              if (selectedOptions.contains("Option 3")) ...{
                                TextField(
                                  controller: _clinicAppointmentFee,
                                  decoration: InputDecoration(
                                    hintText: _doctorModel!.clinicAppointment
                                        ? _doctorModel!.clinicAppointmentFee
                                            .toString()
                                        : "Enter Your fee", // Hint text
                                  ),
                                ),
                                TextField(
                                  controller: _clinicNameController,
                                  decoration: InputDecoration(
                                    hintText: _doctorModel!.clinicAppointment
                                        ? _doctorModel!.clinicName
                                        : "Enter Clinic Name", // Hint text
                                  ),
                                ),
                                TextField(
                                  controller: _clinicAddressController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintMaxLines: 2,
                                    hintText: _doctorModel!.clinicAppointment
                                        ? _doctorModel!.clinicAddress
                                        : "Enter Clinic Address", // Hint text
                                  ),
                                ),
                              },
                              Divider(),
                              SizedBox(height: 32),
                              //Spacer(),
                              ElevatedButton(
                                onPressed: _isLoading
                                    ? () {}
                                    : () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        onNextPressed();
                                      },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text('Done'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
    );
  }
}


/*
Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your options:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Option 1'),
              value: selectedOptions.contains('Option 1'),
              onChanged: (value) => toggleOption('Option 1'),
            ),
            CheckboxListTile(
              title: Text('Option 2'),
              value: selectedOptions.contains('Option 2'),
              onChanged: (value) => toggleOption('Option 2'),
            ),
            CheckboxListTile(
              title: Text('Option 3'),
              value: selectedOptions.contains('Option 3'),
              onChanged: (value) => toggleOption('Option 3'),
            ),
            CheckboxListTile(
              title: Text('Option 4'),
              value: selectedOptions.contains('Option 4'),
              onChanged: (value) => toggleOption('Option 4'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: onNextPressed,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Text('Next'),
              ),
            ),
          ],
        )
 */