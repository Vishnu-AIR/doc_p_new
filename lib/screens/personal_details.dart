import 'package:dummy1/screens/signup.dart';
import 'package:dummy1/screens/upload.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:flutter/material.dart';

import '../service/api_call.dart';

class PersonalDetails extends StatefulWidget {
  final DoctorModel doc;
  const PersonalDetails({super.key, required this.doc});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  DoctorModel? docModel;

  TextEditingController _name = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _speciality = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(widget.doc.phone);
    // Initialize _doctorModel with the provided widget.doc

    setState(() {
      _speciality.text = "other";
      docModel = widget.doc;
    });
    //print(docModel!.name);
  }

  sumbitPersonal() async {
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _country.text.trim().isEmpty ||
        _password.text.trim().isEmpty ||
        _speciality.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter Your Credentials'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    var resc = await ApiHelper.checkPhone(_email.value.text.trim());
    print(resc);
    if (!resc["status"]) {
      setState(() {
        _isLoading = false;
        docModel = docModel!.updateField(
            name: _name.text.trim(),
            countryOfOrigin: _country.text.trim(),
            email: _email.text.trim(),
            password: _password.text.trim(),
            speciality: _speciality.text.trim());
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ImagePickerDemo(doc: docModel!)));
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${resc["message"]}'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_speciality.text);
    return docModel == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding:
                    EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 100),
                //height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/img_signup.png"),
                      fit: BoxFit.cover,
                    )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        "assets/images/img_6_1.png",
                        scale: 3.5,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      // Image.asset(
                      //   "assets/images/img_doc_1.png",
                      //   scale: 3.3,
                      // ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      Container(
                        padding: EdgeInsets.all(8),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.86,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.06), // Shadow color
                                spreadRadius: 5, // Spread radius
                                blurRadius: 3, // Blur radius
                                offset: const Offset(
                                    0, 3), // Offset in x and y directions
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Flex(
                            direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios_new),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen()));
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "Personal Details",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    VerticalDivider(),
                                    Expanded(
                                      child: TextField(
                                        controller: _name,
                                        decoration: InputDecoration(
                                          hintText: 'Name',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.name,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    VerticalDivider(),
                                    Expanded(
                                      child: TextField(
                                        controller: _country,
                                        decoration: InputDecoration(
                                          hintText: 'Countary Or Region',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.email),
                                    VerticalDivider(),
                                    Expanded(
                                      child: TextField(
                                        controller: _email,
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.type_specimen),
                                    VerticalDivider(),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: _speciality.text,
                                        decoration: InputDecoration(
                                          hintText: 'Speciality',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _speciality.text = newValue!;
                                          });
                                        },
                                        items: [
                                          "physician",
                                          "gynacology",
                                          "dermatology",
                                          "sexology",
                                          "psychiatry",
                                          "pediatrics",
                                          "pulmonology",
                                          "hematology",
                                          "other",
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.password),
                                    VerticalDivider(),
                                    Expanded(
                                      child: TextField(
                                        controller: _password,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  sumbitPersonal();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Circular border
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  child: Text(
                                    'Sumbit',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          );
  }
}
