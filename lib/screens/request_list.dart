import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../service/api_call.dart';

import 'package:url_launcher/url_launcher.dart';

class RequestList extends StatefulWidget {
  final String typeOf;
  final List<dynamic> myCord;
  List<dynamic> reqList;
  RequestList(
      {super.key,
      required this.reqList,
      required this.typeOf,
      required this.myCord});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  String _selectedOption = 'Upcoming';
  List<dynamic> pendingList = [];
  List<dynamic> upcomingList = [];

  List<dynamic> get filteredList {
    if (_selectedOption == 'Upcoming') {
      return upcomingList;
    } else {
      return pendingList;
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat dateFormat = DateFormat('E dd, hh:mm a');
    String formattedDateTime = dateFormat.format(dateTime);
    return formattedDateTime;
  }

  Future<void> updateSlotStatus(String slotId, String status) async {
    // Call the API to update slot status
    try {
      var _res =
          await ApiHelper.updateSlotById(slotId, {"approvalStatus": status});
      if (_res["success"] == true) {
        // If successful, update UI
        setState(() {
          // Update the status of the slot in the local list

          for (int i = 0; i < pendingList.length; i++) {
            if (pendingList[i]['_id'] == slotId) {
              // Remove the item from the main list and store it in tempList
              if (status == "approved") {
                upcomingList.add(pendingList.removeAt(i));
              } else {
                pendingList.removeAt(i);
              }
              // Decrement i to account for the removal
              i--;
            }
          }
        });
        //setState(() {});

        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_res["message"]}'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        return;
      }
    } catch (e) {
      // Handle API call failure
      //print('Error updating slot status: $e');
    }
  }

  void openUrl(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch: $url'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
    try {
      await launchUrl(Uri.parse(url));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url \nDue to: $e'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Could not launch $url'),
    //       duration: Duration(seconds: 2), // Adjust duration as needed
    //     ),
    //   );
    //   return;
    //   // 'Could not launch $url';
    // }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers

    // Convert latitude and longitude from degrees to radians
    final lat1Rad = degreesToRadians(lat1);
    final lon1Rad = degreesToRadians(lon1);
    final lat2Rad = degreesToRadians(lat2);
    final lon2Rad = degreesToRadians(lon2);

    // Haversine formula
    final dlon = lon2Rad - lon1Rad;
    final dlat = lat2Rad - lat1Rad;
    final a = pow(sin(dlat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dlon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pendingList = widget.reqList
          .where((req) => req['approvalStatus'] == 'pending')
          .toList();

      upcomingList = widget.reqList
          .where((req) => req['approvalStatus'] == 'approved')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img_signup.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.asset(
              "assets/images/img_6_1.png",
              scale: 3.5,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                DropdownButton<String>(
                  value: _selectedOption,
                  items: <String>['Upcoming', 'Pending'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "( ${widget.typeOf} ) Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.black12,
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.white,
                          splashColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          horizontalTitleGap: 16,
                          isThreeLine: true,
                          leading: CircleAvatar(
                            radius: 32,
                            child: Text(
                              filteredList[index]["user"]["name"][0]
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          title: Text(
                            '${filteredList[index]["user"]["name"]}',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 26,
                                    color: Color.fromARGB(255, 24, 141, 237),
                                  ),
                                  Text(
                                    "  ${formatDateTime(filteredList[index]["slotTime"])}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    size: 26,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    "  ${filteredList[index]["user"]["phone"]}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              if (_selectedOption == "Pending") ...{
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Return the AlertDialog
                                            return AlertDialog(
                                              title: Text(
                                                'Accept',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                  'Are you sure you want to proceed?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Perform the action on confirmation
                                                    updateSlotStatus(
                                                      filteredList[index]
                                                          ['_id'],
                                                      'approved',
                                                    );
                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Confirm'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      color: Colors.green,
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Return the AlertDialog
                                            return AlertDialog(
                                              title: Text(
                                                'Reject',
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                  'Are you sure you want to proceed?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Perform the action on confirmation
                                                    updateSlotStatus(
                                                      filteredList[index]
                                                          ['_id'],
                                                      'rejected',
                                                    );
                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Confirm'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      color: Colors.red,
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              },
                              if (widget.typeOf == "videoConsultancy" &&
                                  _selectedOption == "Upcoming") ...{
                                //Text(filteredList[index]["link"]),
                                MaterialButton(
                                  onPressed: () {
                                    openUrl(filteredList[index]["link"]);
                                  },
                                  child: Text("Join"),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                )
                              },
                              if (widget.typeOf == "homeVistBySlot" &&
                                  _selectedOption == "Upcoming") ...{
                                //Text(filteredList[index]["link"]),
                                Row(
                                  children: [
                                    Text(
                                      "Distance: ${filteredList[index]["patient_loc"] == null ? "NA" : calculateDistance(widget.myCord[0], widget.myCord[1], filteredList[index]["patient_loc"]["coordinates"][0], filteredList[index]["patient_loc"]["coordinates"][1]).toStringAsFixed(2)} m",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blue),
                                    ),
                                    Spacer(),
                                    MaterialButton(
                                      onPressed: () {
                                        if (filteredList[index]
                                                ["patient_loc"] ==
                                            null) {
                                          openUrl("www.google.com");
                                          return;
                                        }
                                        var coord = filteredList[index]
                                            ["patient_loc"]["coordinates"];

                                        openUrl(
                                            "https://www.google.com/maps?q=${coord[0]},${coord[1]}");
                                      },
                                      child: Text("Direction"),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                )
                              },
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle item tap
                            //print('Tapped on item $index');
                          },
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
