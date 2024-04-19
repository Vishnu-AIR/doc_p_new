import 'package:dummy1/main.dart';
import 'package:dummy1/screens/history.dart';
import 'package:dummy1/screens/home.dart';
import 'package:dummy1/screens/setting.dart';
import 'package:dummy1/service/api_call.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';
import 'package:dummy1/screens/login.dart';
import 'package:dummy1/screens/profile_page.dart';
import 'package:dummy1/screens/signup.dart';

class CustomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const CustomNavBar({required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      color: const Color.fromARGB(255, 194, 212, 254),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 9,
              offset: const Offset(0, -1), // changes position of shadow
            ),
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => onTabSelected(0),
              icon: const Icon(
                Icons.home_rounded,
                size: 38,
                color: Colors.black87,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: VerticalDivider(color: Colors.grey),
            ),
            GestureDetector(
              onTap: () => onTabSelected(1),
              child: CircleAvatar(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white.withOpacity(0.9),
                radius: 16,
                child: const Icon(
                  Icons.person_rounded,
                  size: 31,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: VerticalDivider(color: Colors.grey),
            ),
            IconButton(
              onPressed: () => onTabSelected(2),
              icon: const Icon(
                Icons.settings_rounded,
                size: 34,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;

  bool _isLoading = true;

  List<Widget> screens = [];

  void _onTabSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoc();
  }

  getDoc() async {
    var res = await ApiHelper.getDoctor();
    if (res == null) {
      await MySharedPreferences.saveIsLoggedIn(false);
      //await MySharedPreferences.saveToken(null);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignUpScreen()));
      return;
    }
    DoctorModel doctorModel = DoctorModel.fromJson(res);
    //print(doctorModel.name);
    screens = [
      HomeScreen(
        doctor: doctorModel,
      ),
      ProfilePage(
        doctor: doctorModel,
      ),
      SettingScreen(
        doctor: doctorModel,
      ),
    ];
    setState(() {
      screens;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()))
        : Scaffold(
            //backgroundColor: Colors.white12,
            body: screens[currentIndex],
            bottomNavigationBar: CustomNavBar(onTabSelected: _onTabSelected),
          );
  }
}
