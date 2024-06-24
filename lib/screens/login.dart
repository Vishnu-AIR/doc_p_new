import 'package:dummy1/main.dart';
import 'package:dummy1/screens/forget_password.dart';
import 'package:dummy1/screens/home.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/screens/signup.dart';
import 'package:dummy1/service/api_call.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';

import 'otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool _obscurePassword = true;

  login() async {
    if (_phone.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter Your Credentials'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }

    Map _res = await ApiHelper.login(
        _phone.text.trim().contains("@") ? _phone.text.trim() : "",
        _password.text.trim(),
        _phone.text.trim().contains("@") ? "" : _phone.text.trim());

    if (_res["success"] == true) {
      //DoctorModel _doc = DoctorModel.fromJson(_res["data"]);
      await MySharedPreferences.saveToken(_res["token"]);
      await MySharedPreferences.saveIsLoggedIn(true);
      //print("object");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavBar()));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          //height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage("assets/images/img_signup.png"),
                fit: BoxFit.cover,
              )),
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              "assets/images/img_6_1.png",
              scale: 3.5,
            ),
            SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/images/img_doc_1.png",
              scale: 3.8,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.86,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 3, // Blur radius
                      offset:
                          const Offset(0, 3), // Offset in x and y directions
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "\nLogin",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.mail),
                          VerticalDivider(),
                          Expanded(
                            child: TextField(
                              controller: _phone,
                              decoration: InputDecoration(
                                hintText: 'Email / Phone',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock),
                          VerticalDivider(),
                          Expanded(
                            child: TextField(
                              controller: _password,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen()));
                    },
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                      // You can add onTap callback to navigate to login screen
                      // onTap: () {
                      //   Navigator.pushNamed(context, '/login');
                      // },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      'Create An Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                      // You can add onTap callback to navigate to login screen
                      // onTap: () {
                      //   Navigator.pushNamed(context, '/login');
                      // },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //print(_phone.value.text.isNotEmpty ?? _phone.value.text);
                      await login();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Circular border
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
