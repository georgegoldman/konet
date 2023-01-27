// ignore_for_file: file_names

import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/src/signup/service/index.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';

import '../../common_widgets/appbar.dart';
import '../../common_widgets/formFields/formFields.dart';
import '../../common_widgets/snackBar/ErrorMessage.dart';
import '../../common_widgets/unauthenticatedPageHeader.dart';
import 'SignUpThree.dart';

class SignupPageTwo extends StatefulWidget {
  final String email;
  const SignupPageTwo({Key? key, required this.email}) : super(key: key);

  @override
  State<SignupPageTwo> createState() => _SignupPageTwoState();
}

class _SignupPageTwoState extends State<SignupPageTwo>
    with ErrorSnackBar, FormInputFields {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _referalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  CountryCode countryCode =
      const CountryCode(code: "NG", dialCode: "+234", name: "Nigeria");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: initUnauthenticatedAppBar(context, 'sign up two'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const UnauthenticatedPageheader(
                subTitle: 'About you',
                title: 'Tell us about yourself and your business',
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0,
                          MediaQuery.of(context).size.height * 0,
                          0,
                          MediaQuery.of(context).size.height * 0.012),
                      child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                        return textInput(_fullNameController, "full name", 100,
                            'john doe', 1, TextInputType.name, true);
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0,
                          MediaQuery.of(context).size.height * 0.01,
                          0,
                          MediaQuery.of(context).size.height * 0.025),
                      child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                        return textInput(_businessNameController, 'business',
                            100, 'business', 1, TextInputType.name, false);
                      }),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(7),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: InkWell(
                                onTap: () async {
                                  final code = await countryPicker.showPicker(
                                      context: context);
                                  if (code != null) {
                                    setState(() {
                                      countryCode = code;
                                    });
                                  }
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      countryCode.flagImage,
                                      Text(countryCode.dialCode)
                                    ]),
                              ),
                            ),
                            Flexible(
                                child: Container(
                              margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _phoneController,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(height: 1),
                                maxLines: 1,
                                validator: (value) {
                                  if ((value == null || value.isEmpty)) {
                                    return 'Please provide phone number';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  MaskInputFormatter(mask: '###-###-####')
                                ],
                                decoration: InputDecoration(
                                    hintText: '070-123-4567',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 12),
                                    labelText: "Phone",
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Color(0xFFE6B325))),
                                    border: const OutlineInputBorder(),
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600])),
                              ),
                            ))
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0,
                          MediaQuery.of(context).size.height * 0,
                          0,
                          MediaQuery.of(context).size.height * 0.0),
                      child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                        return textInput(
                            _referalCodeController,
                            'referral code',
                            null,
                            'have a referral code? (optional)',
                            1,
                            TextInputType.name,
                            false);
                      }),
                    ),
                  ],
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(50)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).push(RouteAnimation(
                Screen: SignUpFormThree(
              aboutYouFields: {
                "email": widget.email,
                "fullName": _fullNameController.text,
                "businesName": _businessNameController.text,
                "phone":
                    "${countryCode.dialCode}${_phoneController.text.replaceAll('-', '')}",
                "referralCode": _referalCodeController.text
              },
            )).createRoute());
          } else {
            fieldValidationErrorMessage(
                'Please fill in the required fields', context);
          }
        },
        child: const Text(
          'Continue',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
    );
  }
}
