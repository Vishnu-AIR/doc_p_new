import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatefulWidget {
  final List<dynamic> reqList;
  final earning;
  const HistoryList({super.key, required this.reqList, required this.earning});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  late List<dynamic> filteredAppointments;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    filteredAppointments = widget.reqList;
    selectedDate = DateTime.now();
    _filterAppointments(selectedDate);
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    String formattedDateTime = dateFormat.format(dateTime);
    return formattedDateTime;
  }

  void _filterAppointments(DateTime selectedDate) {
    //print(widget.reqList);
    setState(() {
      filteredAppointments = widget.reqList
          .where((appointment) => appointment['createdAt']
              .contains(selectedDate.toString().substring(0, 10)))
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
              ],
            ),
            Text(
              "History List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null) {
                        _filterAppointments(pickedDate);
                        //print(filteredAppointments);
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          Text(
                            '  ${formatDateTime(selectedDate.toString())}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                          tileColor: Colors.white,
                          leading: CircleAvatar(
                            radius: 40,
                            child: Text(
                              "${filteredAppointments[index]['user']['name'][0]}"
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          title: Text(
                            "${filteredAppointments[index]['user']['name']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '(+91) ${filteredAppointments[index]['user']['phone']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Earnings(Rs): ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${widget.earning}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider()
                    ],
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


// Column(
//         children: [
          // Container(
          //   padding: EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       GestureDetector(
          //         onTap: () async {
          //           final DateTime? pickedDate = await showDatePicker(
          //             context: context,
          //             initialDate: selectedDate,
          //             firstDate: DateTime(2022),
          //             lastDate: DateTime(2025),
          //           );
          //           if (pickedDate != null) {
          //             _filterAppointments(pickedDate);
          //             setState(() {
          //               selectedDate = pickedDate;
          //             });
          //           }
          //         },
          //         child: Container(
          //           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(50),
          //               color: Colors.blue),
          //           child: Row(
          //             children: [
          //               Icon(
          //                 Icons.calendar_month,
          //                 color: Colors.white,
          //               ),
          //               Text(
          //                 '  ${formatDateTime(selectedDate.toString())}',
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.w700),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: filteredAppointments.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(filteredAppointments[index]['user']['name']),
          //         subtitle: Text(
          //             'Earnings(Rs): ${filteredAppointments[index]['total']}'),
          //       );
          //     },
          //   ),
          // ),
//         ],
//       )