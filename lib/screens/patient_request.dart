import 'package:dummy1/screens/request_list.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class PatientRequest extends StatefulWidget {
  final reqList;
  final myCord;
  const PatientRequest(
      {super.key, required this.reqList, required this.myCord});

  @override
  State<PatientRequest> createState() => _PatientRequestState();
}

class _PatientRequestState extends State<PatientRequest> {
  //List<dynamic> rl = [];

  List<dynamic> _homeVisitBySlotReq = [];
  List<dynamic> _homeVisitImmidiateReq = [];
  List<dynamic> _clinicAppointmentReq = [];
  List<dynamic> _videoCousultancyReq = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // _homeVisitBySlotReq = widget.reqList.where(
      //     (e) => e["counsultancyType"] == "homeVisitBySlot");
      filterType("homeVisitBySlot", _homeVisitBySlotReq);
      //print(_homeVisitBySlotReq);

      // _homeVisitImmidiateReq = widget.reqList.where(
      //     (e) => e["counsultancyType"] == "homeVisitImmediate");
      filterType("homeVisitImmediate", _homeVisitImmidiateReq);

      // _clinicAppointmentReq = widget.reqList.where(
      //     (e) => e["counsultancyType"] == "clinicAppointment");
      filterType("clinicAppointment", _clinicAppointmentReq);

      // _videoCousultancyReq = widget.reqList.where(
      //     (e) => e["counsultancyType"] == "videoConsultancy");
      filterType("videoConsultancy", _videoCousultancyReq);
    });
  }

  filterType(type, list) {
    for (var element in widget.reqList) {
      //print(element["consultancyType"]);
      if (element["consultancyType"] == type) {
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
      if (reqList[i]["approvalStatus"] == "pending") {
        cnt++;
      }
    }
    return cnt;
  }

  viewList(reqList, typeOf) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequestList(
            reqList: reqList, typeOf: typeOf, myCord: widget.myCord)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          //height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 100),
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
                  height: 24,
                ),
                // Image.asset(
                //   "assets/images/img_doc_1.png",
                //   scale: 3.3,
                // ),
                // SizedBox(
                //   height: 50,
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  height: MediaQuery.of(context).size.height * 0.6,
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
                      const Spacer(),
                      BlueShadowButton(
                          onPressed: () {
                            viewList(_homeVisitBySlotReq, "homeVistBySlot");
                          },
                          child: Center(
                              child: Row(
                            children: [
                              Icon(
                                Icons.add_home_work_rounded,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Text(
                                "Home Visit By Slot",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              Spacer(),
                              Text(
                                "(${filterUnApprovedRequest(_homeVisitBySlotReq)})",
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
                      // BlueShadowButton(
                      //     onPressed: () {
                      //       viewList(
                      //           _homeVisitImmidiateReq, "homeVisitImmediate");
                      //     },
                      //     child: Center(
                      //         child: Row(
                      //       children: [
                      //         Icon(
                      //           Icons.add_home_work_rounded,
                      //           color: Colors.white,
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         Text(
                      //           "Home Visit Immediate",
                      //           style: TextStyle(
                      //               fontSize: 14,
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.w700),
                      //           softWrap: true,
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         Spacer(),
                      //         Text(
                      //           "(${filterUnApprovedRequest(_homeVisitImmidiateReq)})",
                      //           style: TextStyle(
                      //               fontSize: 16,
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.w500),
                      //         ),
                      //       ],
                      //     ))),
                      // const SizedBox(
                      //   height: 32,
                      // ),
                      BlueShadowButton(
                          onPressed: () {
                            viewList(
                                _clinicAppointmentReq, "clinicAppointment");
                          },
                          child: Center(
                              child: Row(
                            children: [
                              Icon(
                                Icons.store_rounded,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Text(
                                "Clinic Appointment",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              Spacer(),
                              Text(
                                "(${filterUnApprovedRequest(_clinicAppointmentReq)})",
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
                            viewList(_videoCousultancyReq, "videoConsultancy");
                          },
                          child: Center(
                              child: Row(
                            children: [
                              Icon(
                                Icons.video_call_rounded,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Text(
                                "Video Consultancy",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              Spacer(),
                              Text(
                                "(${filterUnApprovedRequest(_videoCousultancyReq)})",
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
      ),
      // bottomNavigationBar: CustomNavBar(),
    );
  }
}
