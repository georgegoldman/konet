// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:curnect/src/customException/unsuccessfulRequestException.dart';
import 'package:curnect/src/services/user.dart';
import 'package:curnect/src/widgets/appbar.dart';
import 'package:curnect/src/widgets/snackBar/ErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route_animation.dart';
import '../../style/animation/loading_gif.dart';
import 'SignupTwo.dart';

class SignupPageOne extends StatefulWidget {
  const SignupPageOne({Key? key}) : super(key: key);

  @override
  State<SignupPageOne> createState() => _SignupPageOneState();
}

class _SignupPageOneState extends State<SignupPageOne> with ErrorSnackBar {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  Future<void>? _checkEmail;
  int? connectionDone;

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1205,
              ),
              Column(
                children: const <Widget>[
                  Text(
                    'Sign up',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              emailForm(),
            ],
          ),
        ),
      ),
      FutureBuilder(
          future: _checkEmail,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              case ConnectionState.waiting:
                return const LoadingPageGif();
              case ConnectionState.active:
                return const Text('Active');
              case ConnectionState.done:
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
            }
          })
    ]);
  }

  Future<void> checkEmail() async {
    try {
      var user = User(email: _emailController.text, password: '', token: '');
      final response = await user.checkEmail(
          'https://curnect.com/curnect-api/public/api/checkemail',
          {'email': user.email, 'token': ''});
      if (response.statusCode == 200) {
        context.replace('/signin');
      } else {
        Navigator.of(context).push(RouteAnimation(
            Screen: SignupPageTwo(
          email: _emailController.text,
        )).createRoute());
      }
    } on SocketException catch (_) {
      sendErrorMessage('Network failure', 'Pleasecheck your internet', context);
    } catch (e) {
      return;
    }
  }

  Widget emailForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  controller: _emailController,
                  style: const TextStyle(
                    height: 1,
                  ),
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      labelStyle: TextStyle(color: Colors.black54),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFFE6B325))),
                      label: Text("Email"),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.black54,
                      )),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'Please fill in the field';
                    } else if (!(RegExp(
                            r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                        .hasMatch(value))) {
                      return 'Please enter a valid email';
                    } else {
                      return null;
                    }
                  },
                );
              },
            ),
            const SizedBox(
              height: 27.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 27, 0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      )
                    ],
                  )),
                  const Text('Other sign up options'),
                  Expanded(
                      child: Column(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(27, 0, 0, 0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      // ignore: avoid_returning_null_for_void
                      onPressed: () => null,
                      icon: SvgPicture.asset(
                        'assets/images/google_login_icon.svg',
                      ),
                    ),
                    IconButton(
                      // ignore: avoid_returning_null_for_void
                      onPressed: () => null,
                      icon: SvgPicture.asset(
                        'assets/images/apple_login_icon.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50)),
                //check if the validation is successful
                onPressed: (_emailController.text.isNotEmpty &&
                        isChecked &&
                        RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                            .hasMatch(_emailController.text.toString()))
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _checkEmail = checkEmail();
                          });
                          _checkEmail;
                        }
                      }
                    : null,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FormField<bool>(builder: (state) {
                        return Column(
                          children: <Widget>[
                            Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                    state.didChange(value);
                                  });
                                }),
                          ],
                        );
                      }, validator: (value) {
                        if (!isChecked &&
                            (_emailController.text != '' ||
                                _emailController.text.isNotEmpty) &&
                            RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                .hasMatch(_emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Flexible(
                                  child: Text(
                                "You need to accept the terms of service and Privacy Policy",
                              ))
                            ],
                          )));
                        } else {
                          return null;
                        }
                        return null;
                      }),
                      Flexible(
                        child: TextButton(
                          child: const Text(
                            'I agree to the terms of service and Privacy Policy',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('Terms of service'),
                                  content: SingleChildScrollView(
                                      child: Text(
                                          'Terms of service are the legal agreements between a service provider and a person who wants to use that service. The person must agree to abide by the terms of service in order to use the offered service. Terms of service can also be merely a disclaimer, especially regarding the use of websites.')),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Already a member?'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                        child: TextButton(
                          child: const Text('Sign in',
                              style: TextStyle(
                                  color: Color(0xFFE6B325),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onPressed: () => context.replace('/signin'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
