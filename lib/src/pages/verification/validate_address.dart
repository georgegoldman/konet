import 'dart:io';

import 'package:curnect/src/pages/verification/home_service_fee.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/src/services/user.dart';
import 'package:curnect/src/style/animation/loading_gif.dart';
import 'package:curnect/src/widgets/emptyLoader.dart';
import 'package:curnect/src/widgets/snackBar/ErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../state_manager/add_service_manipulator.dart';
import '../../widgets/appbar.dart';
import '../../widgets/unauthenticatedPageHeader.dart';

class ValidateAddress extends StatefulWidget {
  final Map<String, String> addresses;
  const ValidateAddress({super.key, required this.addresses});

  @override
  State<ValidateAddress> createState() => _ValidateAddressState();
}

class _ValidateAddressState extends State<ValidateAddress> with ErrorSnackBar {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetOneController = TextEditingController();
  final TextEditingController _streetTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateMarkController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  Future<void>? _validateAddress;
  bool success = false;
  User user = User(email: '', password: '');

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(
                context: context,
                screeenInfo:
                    "With our postal address verification and cleansing service you can easily verify if an address exists and is deliverable. Whether you want to clean up the addresses in your customer database or verify addresses directly on your website, we have exactly the right solution for you.")
            .preferredSize(),
        body: validateAddressForm(),
        persistentFooterButtons: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50)),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                changeFutureBuilderState();
                // var validatingAddressFromMap =
                //     await validateAddressRequest();
                // debugPrint('the truth');
                // debugPrint(validatingAddressFromMap.toString());
                setState(() {
                  _validateAddress = verifyAddresss();
                });
                _validateAddress;
              } else {
                null;
              }
            },
            child: const Text(
              'Continue',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          )
        ],
      ),
      FutureBuilder(
        future: _validateAddress,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // ignore: todo
              // TODO: Handle this case.
              return const EmptyLoader();
            case ConnectionState.waiting:
              // ignore: todo
              // TODO: Handle this case.
              return const LoadingPageGif();
            case ConnectionState.active:
              // ignore: todo
              // TODO: Handle this case.
              return const Text("Is Active");
            case ConnectionState.done:
              // ignore: todo
              // TODO: Handle this case.
              return const EmptyLoader();
          }
        },
      )
    ]);
  }

  Future<void> verifyAddresss() async {
    try {
      User user = User(email: '', password: '');
      int userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id'];
      Map<String, String> body = {
        '_method': 'patch',
        'id': userId.toString(),
        'address':
            "${_streetOneController.text.toString()} ${_zipController.text.toString()} ${_cityController.text.toString()} ${_stateMarkController.text.toString()} ${_countryController.text}"
      };

      http.StreamedResponse response = await user.validateAddressController(
          body, 'https://curnect.com/curnect-api/public/api/registeraddress');
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context).push(
              RouteAnimation(Screen: const GetHomeServiceFee()).createRoute());
        } else {
          sendErrorMessage(res.reasonPhrase.toString(), res.body, context);
        }
      });
    } on SocketException catch (_) {
      sendErrorMessage(
          'Network error', 'Please check you internet connection', context);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _streetOneController.text = widget.addresses['street-adress'] ?? '';
    _streetTwoController.text = widget.addresses['region'] ?? '';
    _zipController.text = widget.addresses['postal-code'] ?? '';
    _cityController.text = widget.addresses['locality'] ?? '';
    _stateMarkController.text = widget.addresses['locality'] ?? '';
    _countryController.text = widget.addresses['country-name'] ?? '';
    super.initState();
  }

  Widget validateAddressForm() {
    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.1,
          child: const UnauthenticatedPageheader(
            subTitle: 'Where can your clients find you?',
            title: 'Validate your address',
          ),
        ),
        Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return TextFormField(
                            controller: _streetOneController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(
                              height: 1,
                            ),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                label: Text("Street Address Line 1"),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a street address';
                              }
                              return null;
                            },
                          );
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return TextField(
                            textInputAction: TextInputAction.done,
                            controller: _streetTwoController,
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(
                              height: 1,
                            ),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                label: Text("Street Address Line 2"),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                          );
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return TextFormField(
                            controller: _zipController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(
                              height: 1,
                            ),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                label: Text("Zip code"),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                          );
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return TextFormField(
                            controller: _cityController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a city';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              height: 1,
                            ),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                label: Text("City"),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                          );
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return TextFormField(
                            controller: _stateMarkController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(
                              height: 1,
                            ),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                label: Text("State"),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a landmark';
                              }
                              return null;
                            },
                          );
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.01),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return TextFormField(
                            controller: _countryController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(
                              height: 1,
                            ),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                label: Text("Country"),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Country';
                              }
                              return null;
                            },
                          );
                        })),
                  ],
                )),
            Text(
              errorMessage.toString(),
              style: const TextStyle(color: Colors.redAccent),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  setState(() {
                    _streetOneController.text = '';
                    _streetTwoController.text = '';
                    _zipController.text = '';
                    _cityController.text = '';
                    _stateMarkController.text = '';
                    _countryController.text = '';
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.redAccent),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }

  void changeFutureBuilderState() async {
    setState(() {
      _validateAddress = validateAddressRequest();
    });
  }

  Future<bool> validateAddressRequest() async {
    final response = await user.validateAddress(
        'https://curnect.com/curnect-api/public/api/registeraddress',
        {"email": '', "password": '', "token": ''});
    return response;
  }
}
