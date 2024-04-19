import 'package:dummy1/screens/availabilty.dart';
import 'package:dummy1/screens/history_list.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/screens/personal_details.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class HistoryScreen extends StatefulWidget {
  final DoctorModel doc;
  final List<dynamic> reqList;
  const HistoryScreen({super.key, required this.reqList, required this.doc});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _homeVisitReq = [];

  List<dynamic> _clinicAppointmentReq = [];
  List<dynamic> _videoCousultancyReq = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // _homeVisitBySlotReq = widget.ReqList.where(
      //     (e) => e["counsultancyType"] == "homeVisitBySlot");
      filterType("homeVisitBySlot", _homeVisitReq);
      //print(_homeVisitBySlotReq);

      // _homeVisitImmidiateReq = widget.ReqList.where(
      //     (e) => e["counsultancyType"] == "homeVisitImmediate");
      filterType("homeVisitImmediate", _homeVisitReq);

      // _clinicAppointmentReq = widget.ReqList.where(
      //     (e) => e["counsultancyType"] == "clinicAppointment");
      filterType("clinicAppointment", _clinicAppointmentReq);

      // _videoCousultancyReq = widget.ReqList.where(
      //     (e) => e["counsultancyType"] == "videoConsultancy");
      filterType("videoConsultancy", _videoCousultancyReq);
    });
  }

  filterType(type, list) {
    for (var element in widget.reqList) {
      //print(element["consultancyType"]);
      if (element["consultancyType"] == type &&
          element["approvalStatus"] == "completed") {
        list.add(element);
      }
    }
  }

  filterUnApprovedRequest(reqList) {
    int cnt = 0;
    if (reqList.isEmpty) {
      return 0;
    }
    for (var i = 0; i < reqList.length; i++) {
      if (reqList[i]["approvalStatus"] == "completed") {
        cnt++;
      }
    }
    return cnt;
  }

  viewList(reqList, earning) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HistoryList(
              reqList: reqList,
              earning: earning,
            )));
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.doc.clinicAppointmentFee.contains("null"));
    return Scaffold(
      body: SingleChildScrollView(
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
                  height: 80,
                ),
                Image.asset(
                  "assets/images/img_6_1.png",
                  scale: 3.5,
                ),
                const SizedBox(
                  height: 16,
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
                          offset: const Offset(
                              0, 3), // Offset in x and y directions
                        ),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(context);
                              },
                              icon: Icon(Icons.arrow_back)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings),
                          Text(
                            "  History",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      BlueShadowButton(
                          onPressed: () {
                            viewList(
                                _homeVisitReq, widget.doc.homeVisitBySlotFee);
                          },
                          child: Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.add_home_work_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Home Visit\n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "\n",
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: 'Earnings(Rs): ',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    TextSpan(
                                      text:
                                          "${filterUnApprovedRequest(_homeVisitReq) * widget.doc.homeVisitBySlotFee}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                "(${filterUnApprovedRequest(_homeVisitReq)})",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ))),
                      const SizedBox(
                        height: 32,
                      ),
                      BlueShadowButton(
                          onPressed: () {
                            viewList(_clinicAppointmentReq,
                                widget.doc.clinicAppointmentFee);
                          },
                          child: Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.store_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Clinic Appointment\n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "\n",
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: 'Earnings(Rs): ',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    TextSpan(
                                      text:
                                          "${filterUnApprovedRequest(_clinicAppointmentReq) * widget.doc.clinicAppointmentFee}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                "(${filterUnApprovedRequest(_clinicAppointmentReq)})",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ))),
                      const SizedBox(
                        height: 32,
                      ),
                      BlueShadowButton(
                          onPressed: () {
                            viewList(_videoCousultancyReq,
                                widget.doc.videoConsultancyFee);
                          },
                          child: Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.video_call,
                                color: Colors.white,
                                size: 26,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Video Consultancy\n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "\n",
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: 'Earnings(Rs): ',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    TextSpan(
                                      text:
                                          "${filterUnApprovedRequest(_videoCousultancyReq) * widget.doc.videoConsultancyFee}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                "(${filterUnApprovedRequest(_videoCousultancyReq)})",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ))),
                      const SizedBox(
                        height: 32,
                      ),
                      const Spacer()
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
