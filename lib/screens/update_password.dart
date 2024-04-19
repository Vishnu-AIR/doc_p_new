import 'package:flutter/material.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/service/docModel.dart';
import '../service/api_call.dart';

class ChangePasswordScreen extends StatefulWidget {
  final DoctorModel doc;
  ChangePasswordScreen({required this.doc});
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  void _changePassword() async {
    setState(() {
      _isLoading = true;
    });
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;

    if (currentPasswordController.text.trim().isEmpty ||
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
        widget.doc.id, {"password": newPasswordController.text.trim()});

    if (_res["success"] == true) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NavBar()),
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
              controller: currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscureCurrentPassword,
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
