import 'package:dummy1/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/service/docModel.dart';
import '../service/api_call.dart';
import 'otp.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool _isLoading = false;

  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  void _changePassword() async {
    setState(() {
      _isLoading = true;
    });
    String phoneNumber = phoneNumberController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;

    if (phoneNumber.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter the values in all fields*'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    var redc = await ApiHelper.getDocByPhone(phoneNumberController.text.trim());
    print(redc.runtimeType);
    if (redc.runtimeType == String) {
      if (phoneNumberController.text.trim().isEmpty ||
          newPasswordController.text.trim().isEmpty ||
          confirmNewPasswordController.text.trim().isEmpty) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter the values in all fields*'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Validate passwords
      if (newPassword != confirmNewPassword) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New password and confirm password do not match.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Map _res = await ApiHelper.updateDoctor(
          redc, {"password": newPasswordController.text.trim()});

      if (_res["success"] == true) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_res["message"]}'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } else if (redc == false) {
      print("gghgij");
      var res = await ApiHelper.verifyOTP(phoneNumber.trim());
      //print(res);
      //if(res["data"])
      if (res["success"] == true) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OtpScreen(
                  otp: res["data"]["otp"],
                  phone: phoneNumber.trim(),
                )));
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${res["message"]}'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        return;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went Wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => NavBar()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscureNewPassword,
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmNewPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscureConfirmNewPassword,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? () {} : _changePassword,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
