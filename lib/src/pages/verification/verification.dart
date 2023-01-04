import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/pages/verification/publish_profile.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/src/services/user.dart';
import 'package:curnect/src/style/animation/loading_gif.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common_widgets/appbar.dart';
import '../../common_widgets/emptyLoader.dart';
import '../../common_widgets/formFields/formFields.dart';
import '../../common_widgets/snackBar/ErrorMessage.dart';
import '../../common_widgets/unauthenticatedPageHeader.dart';
import '../../state_manager/add_service_manipulator.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification>
    with ErrorSnackBar, FormInputFields {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final TextEditingController _ninController = TextEditingController();
  final TextEditingController _businessRegController = TextEditingController();
  String _chosenValue = "Select Id type";
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  Future<void>? _verificationFUture;
  int? successful;

  Future<void> verificationFunc() async {
    try {
      User user = User(email: '', password: '');
      int userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id'];
      Map<String, String> body = {
        '_method': 'patch',
        'id': userId.toString(),
        'id_name': _chosenValue.toString(),
        'reg_no': _businessRegController.text.toString(),
        'nin_number': _ninController.text.toString(),
      };
      if (_croppedFile != null) {
        http.StreamedResponse response = await user.idVerificationController(
            _croppedFile!.path,
            body,
            'https://curnect.com/curnect-api/public/api/registerid');

        http.Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context).push(
                RouteAnimation(Screen: const PublishProfile()).createRoute());
          } else {
            sendErrorMessage(res.reasonPhrase.toString(),
                json.decode(res.body)['error'], context);
          }
        });
      } else {
        http.StreamedResponse response = await user.idVerificationController(
            _pickedFile!.path,
            body,
            'https://curnect.com/curnect-api/public/api/registerid');
        http.Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context).push(
                RouteAnimation(Screen: const PublishProfile()).createRoute());
          } else {
            sendErrorMessage(res.reasonPhrase.toString(),
                json.decode(res.body)['error'].toString(), context);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(
                context: context,
                screeenInfo:
                    "Verify customer IDs with AI-powered biometric recognition service. Ensure quality identity verification with iDenfy's team that manually reviews every audit.")
            .preferredSize(),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width * 0.1,
                child: const UnauthenticatedPageheader(
                  subTitle: 'To verify the authencity of who you are.',
                  title: 'Verification',
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return textInput(_ninController, 'NIN', 11, 'NIN', 1,
                              TextInputType.number, true);
                        },
                      ),
                      const SizedBox(
                        height: 11.0,
                      ),
                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return textInput(
                              _businessRegController,
                              'Business Reg. No',
                              6,
                              'Business Reg. No',
                              1,
                              TextInputType.text,
                              false);
                        },
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      const Text(
                        "Upload ID",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Color(0xFFE6B325)))),
                          isExpanded: true,
                          items: <String>[
                            'National Id',
                            'Drivers License',
                            'International Passport',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(_chosenValue),
                          onChanged: (value) {
                            setState(() {
                              _chosenValue = value!;
                            });
                          }),
                      const SizedBox(
                        height: 15.0,
                      ),
                      _body(),
                    ],
                  )),
            ],
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50)),
              //check if the validation is successful
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _verificationFUture = verificationFunc();
                  });
                  _verificationFUture;
                } else {
                  return;
                }
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
      FutureBuilder(
          future: _verificationFUture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const EmptyLoader();
              case ConnectionState.waiting:
                return const LoadingPageGif();
              case ConnectionState.active:
                return const Text('waiting');
              case ConnectionState.done:
                return const EmptyLoader();
            }
          })
    ]);
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploadCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _image(),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.001),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "delete",
              onPressed: () {
                _clear();
              },
              backgroundColor: Colors.black,
              tooltip: 'Delete',
              child: const Icon(Icons.delete),
            ),
            if (_croppedFile == null)
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: FloatingActionButton(
                  heroTag: "crop",
                  onPressed: () {
                    _cropImage();
                  },
                  backgroundColor: Colors.black,
                  tooltip: 'Crop',
                  child: const Icon(Icons.crop),
                ),
              ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.017,
        ),
      ],
    );
  }

  Widget _uploadCard() {
    return InkWell(
      onTap: () => _uploadImage(),
      child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.06),
          // height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.camera_alt_rounded,
                color: Colors.black12,
                size: 77,
              ),
              Text(
                "Upload a means of Identification",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black38),
              )
            ],
          )),
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}
