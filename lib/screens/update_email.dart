import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';

import '../service/api_call.dart';

class ChangeEmailScreen extends StatefulWidget {
  final DoctorModel doc;
  ChangeEmailScreen({required this.doc});
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController newEmailController = TextEditingController();

  bool _isLoading = false;

  void _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    String newEmail = newEmailController.text.trim();

    // Validate passwords
    if (newEmail.isEmpty || !newEmail.contains("@")) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email isnt valid'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    Map _res = await ApiHelper.updateDoctor(
        widget.doc.id, {"email": newEmailController.text.trim()});

    if (_res["success"] == true) {
      //DoctorModel _doc = DoctorModel.fromJson(_res["data"]);
      setState(() {
        _isLoading = false;
      });
      //print("object");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => NavBar()));
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

    // Implement password change logic here
    // You can use a form validation library or write custom validation logic
    // Once the password is successfully changed, you can navigate to a success screen or show a confirmation message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NavBar()));
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: newEmailController,
              decoration: InputDecoration(
                labelText: 'New Email',
              ),
              //obscureText: true, // Hide password text
            ),
            SizedBox(height: 16),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? () {} : _changePassword,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Change Email'),
            ),
          ],
        ),
      ),
    );
  }
}
