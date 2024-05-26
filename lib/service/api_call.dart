import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dummy1/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiHelper {
  static final Dio _dio = Dio();

  static const String baseUrl =
      "https://api.healthko.in/api"; //'http://127.0.0.1:8000';

  static Future<dynamic> verifyOTP(String phoneNumber) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode({"num": phoneNumber});
      final response = await _dio.post(
        '$baseUrl/verification/verifyphone',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        ('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in verifyOTP: $error');
      return null;
    }
  }

  static Future<dynamic> registerDoctor(Map<String, dynamic> body) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode(body);
      final response = await _dio.post(
        '$baseUrl/doctorauth/registration',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in registerDoctor: $error');
      return null;
    }
  }

  static Future<dynamic> updateDoctor(
      String doctorId, Map<String, dynamic> body) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode(body);
      final response = await _dio.post(
        '$baseUrl/doctorauth/update/$doctorId',
        options: Options(headers: headers),
        data: data,
      );
      print(response.data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in updateDoctor: $error');
      return null;
    }
  }

  static Future<dynamic> getDoctorSlots() async {
    try {
      String? token = await MySharedPreferences.getToken();
      if (token!.isEmpty) {
        return null;
      }
      Map<String, dynamic>? decodedToken = JwtDecoder.decode(token);
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final data = json.encode({"doctor": decodedToken["_id"]});
      final response = await _dio.post(
        '$baseUrl/slots/doctor',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        //print(response.data["data"]);
        return response.data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in getDoctorSlots: $error');
      return null;
    }
  }

  static Future<dynamic> updateSlotById(
      String slotId, Map<String, dynamic> body) async {
    try {
      String? token = await MySharedPreferences.getToken();
      if (token!.isEmpty) {
        return null;
      }
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final data = json.encode(body);
      final response = await _dio.post(
        '$baseUrl/slots/updateSlot/$slotId',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in updateSlotById: $error');
      return null;
    }
  }

  static Future<dynamic> verifyEmail(String email) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode({"email": email});
      final response = await _dio.post(
        '$baseUrl/verification/verifyemail',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in verifyEmail: $error');
      return null;
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password, String phone) async {
    //rint(email + password + phone);
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var data =
          json.encode({"phone": phone, "password": password, "email": email});

      var dio = Dio();
      var response = await dio.request(
        '$baseUrl/doctorauth/login',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );
      //print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
        return {
          'success': true,
          'data': response.data["data"],
          'token': response.data["token"]
        };
      } else {
        return {'success': false, 'message': response.data["message"]};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<dynamic> getDoctor() async {
    try {
      //MySharedPreferences pref = MySharedPreferences();
      String? _token = await MySharedPreferences.getToken();
      if (_token == null) {
        return null;
      }

      Map<String, dynamic>? decodedToken = JwtDecoder.decode(_token);

      print(decodedToken["_id"]);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode({});
      final response = await _dio.post(
        '$baseUrl/doctorauth/update/${decodedToken["_id"]}',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data["data"];
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in updateDoctor: $error');
      return null;
    }
  }

  static Future<dynamic> checkPhone(String phoneNumber) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode({"phone": phoneNumber});
      final response = await _dio.post(
        '$baseUrl/doctorauth/phonechecker',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        ('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in verifyOTP: $error');
      return null;
    }
  }

  static Future<dynamic> checkEmail(String email) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final data = json.encode({"email": email});
      final response = await _dio.post(
        '$baseUrl/doctorauth/phonechecker',
        options: Options(headers: headers),
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        ('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in verifyOTP: $error');
      return null;
    }
  }
}
