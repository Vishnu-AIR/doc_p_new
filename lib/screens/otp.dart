import 'package:dummy1/screens/signup.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';
import 'package:dummy1/screens/personal_details.dart';

class OtpScreen extends StatefulWidget {
  final String otp;
  final String phone;

  const OtpScreen({required this.otp, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otp = TextEditingController();
  bool _isLoading = false;

  DoctorModel _doc = DoctorModel.empty();

  checkOtp() {
    if (_otp.value.text.trim().isEmpty || _otp.value.text.trim().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter Your OTP Properly'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (widget.otp == _otp.value.text.trim()) {
      setState(() {
        _isLoading = false;
      });
      //DoctorModel doc = DoctorModel.empty();
      //print(widget.phone + "---->");
      setState(() {
        _doc = _doc.updateField(phone: widget.phone);
      });
      //print(_doc.phone);
      //print(_doc.name);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => PersonalDetails(
                  doc: _doc,
                )),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect Otp'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.otp);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          //height: MediaQuery.of(context).size.height,
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
                      "\nVerify OTP",
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
                            VerticalDivider(),
                            Expanded(
                              child: TextField(
                                controller: _otp,
                                decoration: InputDecoration(
                                  hintText: 'OTP',
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
                      onTap: _isLoading
                          ? () {}
                          : () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? () {}
                          : () {
                              //print(_otp.value.text.isNotEmpty ?? _otp.value.text);
                              checkOtp();
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
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
