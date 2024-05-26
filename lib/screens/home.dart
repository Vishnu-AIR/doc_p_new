import 'package:dummy1/screens/history.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/screens/patient_request.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../service/api_call.dart';


import 'dart:async'; // Add this import statement for Completer

class HomeScreen extends StatefulWidget {
  final DoctorModel doctor;
  const HomeScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DoctorModel? _docModel;
  List<dynamic> ReqList = [];

  List<double> myCoord = [0, 0];

  bool _isLoading = false;

  Completer<void>? _locationCompleter;
  StreamSubscription<Position>? _locationSubscription;

  filterUnApprovedRequest() {
    int cnt = 0;
    for (var i = 0; i < ReqList.length; i++) {
      if (ReqList[i]["approvalStatus"] == "pending") {
        cnt++;
      }
    }
    return cnt;
  }

  _patientRequest() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PatientRequest(
              reqList: ReqList,
              myCord: myCoord,
            )));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _docModel = widget.doctor;
    _locationCompleter = Completer<void>();
    getDocReq();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  getDocReq() async {
    Map _res = await ApiHelper.getDoctorSlots();

    if (_res["success"] == true) {
      setState(() {
        ReqList = _res["data"];
      });
      setState(() {
        _isLoading = false;
      });
      return;
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_res["message"]}'),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
                'This app requires access to your device\'s location. Please grant the location permission in settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          );
        },
      );
    } else {
      await _checkLocationPermission();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _locationSubscription =
          Geolocator.getPositionStream().listen((Position position) {
        // Check if myCoord is already set, if not, set it
        if (myCoord[0] == 0 && myCoord[1] == 0) {
          setState(() {
            myCoord = [position.latitude, position.longitude];
            _isLoading = false;
            _locationCompleter?.complete();
          });
        }
      });
      var _res = await ApiHelper.updateDoctor(_docModel!.id, {
        "live_loc": {
          "type": "Point",
          "coordinates": [myCoord[0], myCoord[1]],
        }
      });
      if (_res["success"] == true) {
        //DoctorModel _doc = DoctorModel.fromJson(_res["data"]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location Updated'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_res["message"]}'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        return;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"Error getting current location: $e"'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
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
              const SizedBox(
                height: 32,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.86,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => NavBar())),
                      child: Text(
                        "\nRefresh Request List",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                      ),
                    ),
                    const Spacer(),
                    BlueShadowButton(
                        onPressed: _patientRequest,
                        child: Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Icon(
                              Icons.watch_later_rounded,
                              color: Colors.white,
                            ),
                            Spacer(),
                            Text(
                              "Patients’ Request",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            Text(
                              "(" + filterUnApprovedRequest().toString() + ")",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ))),
                    const SizedBox(
                      height: 32,
                    ),
                    BlueShadowButton(
                        onPressed: () {},
                        child: const Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Icon(
                              Icons.thumb_up_rounded,
                              color: Colors.white,
                            ),
                            Spacer(),
                            Text(
                              "Rating / Review",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            Text(
                              "(3)",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ))),
                    const SizedBox(
                      height: 32,
                    ),
                    BlueShadowButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HistoryScreen(
                                    reqList: ReqList,
                                    doc: _docModel!,
                                  )));
                        },
                        child: const Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Icon(
                              Icons.person_pin_sharp,
                              color: Colors.white,
                            ),
                            Spacer(),
                            Text(
                              "History",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            Text(
                              "",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ))),
                    const Spacer()
                  ],
                ),
              )
            ]),
      ),
    );
  }
}

class BlueShadowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const BlueShadowButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 0, 92, 167),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: Offset(0, 8))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
