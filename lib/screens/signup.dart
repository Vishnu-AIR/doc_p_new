import 'package:dummy1/service/api_call.dart';
import 'package:flutter/material.dart';
import 'package:dummy1/screens/login.dart';
import 'package:dummy1/screens/otp.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phone = TextEditingController();
  bool _isLoading = false;

  sendOtp() async {
    if (_phone.value.text.trim() == null ||
        _phone.value.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter Your Number Properly'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    var res = await ApiHelper.verifyOTP(_phone.value.text.trim());
    //print(res);
    //if(res["data"])
    if (res["success"] == true) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => OtpScreen(
                otp: res["data"]["otp"],
                phone: _phone.value.text.trim(),
              )));
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${res["message"]}'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/img_signup.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset("assets/images/img_6_1.png", scale: 3.5),
              SizedBox(height: 50),
              Image.asset("assets/images/img_doc_1.png", scale: 3.3),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.86,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      spreadRadius: 5,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "\nSign Up",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            VerticalDivider(),
                            Expanded(
                              child: TextField(
                                controller: _phone,
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          children: [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? () {}
                          : () {
                              sendOtp();
                            },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                'Request OTP',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
