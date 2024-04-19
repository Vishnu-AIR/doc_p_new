import 'package:dummy1/service/api_call.dart';
import 'package:flutter/material.dart';

class RequestListData {
  static List<dynamic> reqList = [];

  RequestListData() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    Map _res = await ApiHelper.getDoctorSlots();

    if (_res["success"] == true) {
      reqList = _res["data"];
      //print(reqList);
    } else {
      throw Exception(_res["message"]);
    }
  }

  static Future<void> refresh(String doctorId) async {
    // Call your API to get the doctor slots data here
    // For example:
    // Map _res = await ApiHelper.getDoctorSlots(doctorId);
    // After fetching the data, update reqList accordingly
    // For demo purposes, let's assume _res contains the response data

    Map<String, dynamic> _res = await ApiHelper
        .getDoctorSlots(); // Replace this with your actual API call
    if (_res["success"] == true) {
      reqList = _res["data"];
    } else {
      throw Exception(_res["message"]);
    }
  }

  static List<dynamic> getFilteredList(
      {required String key, required dynamic value}) {
    // Filter reqList based on the provided key-value pair
    List<dynamic> filteredList = reqList.where((item) {
      // Add your filtering logic here
      return item[key] == value;
    }).toList();
    return filteredList;
  }
}
