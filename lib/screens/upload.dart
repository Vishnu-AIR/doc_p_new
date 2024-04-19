import 'dart:io';

import 'package:dummy1/screens/availabilty.dart';
import 'package:dummy1/screens/personal_details.dart';
import 'package:dummy1/screens/profile_page.dart';
import 'package:dummy1/service/docModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';

class ImagePickerDemo extends StatefulWidget {
  final DoctorModel doc;
  const ImagePickerDemo({super.key, required this.doc});

  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  File? _image;
  File? _pdf;
  TextEditingController _regNo = TextEditingController();

  DoctorModel? _doctorModel;

  Map userUploads = {};

  final picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //print(widget.doc);
    // Initialize _doctorModel with the provided widget.doc
    setState(() {
      _doctorModel = widget.doc;
    });
    print(_doctorModel!.countryOfOrigin);
  }

  // Method to submit the form
  void submit() async {
    // Update _doctorModel with the uploaded files and registration number
    setState(() {
      _doctorModel = _doctorModel = _doctorModel!.updateField(
        regNo: userUploads["regNo"],
        idUrl: userUploads["application"],
        profilePicUrl: userUploads["image"],
      );
      _isLoading = false;
    });
    //print(_doctorModel!.profilePicUrl);
    // Navigate to the next screen passing _doctorModel as parameter
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Availability(doc: _doctorModel!),
        ),
      );
    }
  }

  // Method to pick an image from camera or gallery
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        //print('No image selected.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No Image selected.'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
      }
    });
  }

  // Method to pick a PDF file
  void pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        PlatformFile pFile = result.files.first;
        File file = File(pFile.path!);
        setState(() {
          _pdf = file;
        });
      } else {
        //print('User canceled the picker');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User canceled the picker'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
      }
    } catch (e) {
      //print('Error picking PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking PDF: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Method to upload a file
  uploadFile(File file, type) async {
    FormData formData = FormData.fromMap({
      'file': [
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType(
            'application',
            'pdf',
          ),
        )
      ]
    });

    Dio dio = Dio();
    try {
      Response response = await dio.post(
        'https://api.healthko.in/api/doctorauth/upload/docId',
        data: formData,
        options: Options(
          method: 'POST',
          headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            userUploads[type] = response.data["result"]["Location"];
          });
        }
        return true;
        // Call submit method when upload is successful
      } else {
        //print(response.statusMessage);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.statusMessage.toString()),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
      }
    } catch (e) {
      //print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
    }
    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _doctorModel == null
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
                          child: Column(
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
                                                  PersonalDetails(
                                                    doc: _doctorModel!,
                                                  )));
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await getImage();
                                },
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.grey
                                      .withOpacity(_image == null ? 0.2 : 0),
                                  child: _image == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt),
                                            Text("  Upload\nProfile Pic")
                                          ],
                                        )
                                      : Image.file(
                                          _image!,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: pickPDF,
                                child: DashedBorder(
                                  strokeWidth: 1,
                                  color: Colors.grey,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    //height: 120,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 24.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.08)
                                        // borderRadius: BorderRadius.circular(12.0),
                                        // border: Border.all(
                                        //     color: Colors.grey,
                                        //     style: BorderStyle.solid),
                                        ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "ID Card",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                        _pdf != null
                                            ? Text(
                                                "${_pdf!.path.split("/").last}",
                                                style: TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.badge),
                                                    VerticalDivider(),
                                                    Text("Upload Id"),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
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
                                    Icon(Icons.lock),
                                    VerticalDivider(),
                                    Expanded(
                                      child: TextField(
                                        controller: _regNo,
                                        decoration: InputDecoration(
                                          hintText: 'Registration No.',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              ElevatedButton(
                                onPressed: _isLoading
                                    ? () {}
                                    : () async {
                                        // await _uploadFile().then((value) {
                                        //   print(value);
                                        // });
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        if (_pdf == null || _image == null) {
                                          // print("sdjgdbj");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'select an Image and IC_card proof'),
                                              duration: Duration(
                                                  seconds:
                                                      2), // Adjust duration as needed
                                            ),
                                          );
                                          return;
                                        }
                                        if (_regNo.text.trim().isEmpty) {
                                          //print(_regNo.text.trim().isEmpty);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Enter Your Registration Number'),
                                              duration: Duration(
                                                  seconds:
                                                      2), // Adjust duration as needed
                                            ),
                                          );
                                          return;
                                        }
                                        if (await uploadFile(
                                                _image!, "image") &&
                                            await uploadFile(
                                                _pdf!, "application")) {
                                          setState(() {
                                            userUploads["regNo"] =
                                                _regNo.value.text.trim();
                                          });
                                          submit();
                                          return;
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Error uploading'),
                                              duration: Duration(
                                                  seconds:
                                                      2), // Adjust duration as needed
                                            ),
                                          );
                                          return;
                                        }

                                        //print(userUploads);
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Circular border
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
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

class DashedBorder extends StatelessWidget {
  final double strokeWidth;
  final Color color;
  final Widget child;

  const DashedBorder({
    Key? key,
    required this.strokeWidth,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
      ),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  DashedBorderPainter({
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5;
    final double dashSpace = 5;

    // Draw top border
    _drawDashedLine(
      canvas,
      Offset(0, 0),
      Offset(size.width, 0),
      paint,
      dashWidth,
      dashSpace,
    );

    // Draw bottom border
    _drawDashedLine(
      canvas,
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
      dashWidth,
      dashSpace,
    );

    // Draw left border
    _drawDashedLine(
      canvas,
      Offset(0, 0),
      Offset(0, size.height),
      paint,
      dashWidth,
      dashSpace,
    );

    // Draw right border
    _drawDashedLine(
      canvas,
      Offset(size.width, 0),
      Offset(size.width, size.height),
      paint,
      dashWidth,
      dashSpace,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    double distance = 0;
    final double dx = end.dx - start.dx;
    final double dy = end.dy - start.dy;
    final double length = dx != 0 ? dx : dy;

    while (distance < length) {
      final double x1 = start.dx + distance * (dx / length);
      final double y1 = start.dy + distance * (dy / length);
      final double x2 = x1 + dashWidth * (dx / length);
      final double y2 = y1 + dashWidth * (dy / length);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
