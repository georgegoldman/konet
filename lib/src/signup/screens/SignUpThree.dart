// ignore_for_file: file_names, empty_catches

import 'package:curnect/src/signup/service/index.dart';
import 'package:flutter/material.dart';

import '../../../utils/common_widgets/appbar.dart';
import '../../../utils/common_widgets/emptyLoader.dart';
import '../../../utils/common_widgets/snackBar/ErrorMessage.dart';
import '../../../utils/common_widgets/unauthenticatedPageHeader.dart';

import '../../../utils/common_widgets/loading_gif.dart';

class SignUpFormThree extends StatefulWidget {
  final Map<String, String> aboutYouFields;
  const SignUpFormThree({super.key, required this.aboutYouFields});

  @override
  State<SignUpFormThree> createState() => _SignUpFormThreeState();
}

class _SignUpFormThreeState extends State<SignUpFormThree> with ErrorSnackBar {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isHidden = true;
  bool passwordMatch = false;
  bool _isHiddenForPassword = true;
  // ignore: non_constant_identifier_names
  Map<String, dynamic>? sign_done;
  late String _password;
  double _strength = 0;
  Future<dynamic>? _register;
  SignupService? _service;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  final regExp = RegExp(
      r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
      "'" // <-- ' is added to the expression
      ']');

  String notSuccessfullMessage = '';

  @override
  void initState() {
    _service = SignupService(context: context);
    super.initState();
  }

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
      });
    } else {
      if (letterReg.hasMatch(_password) &&
          numReg.hasMatch(_password) &&
          _password.contains(regExp)) {
        setState(() {
          _strength = 1;
        });
      }
    }
  }

  void callTheErrorText(error) {
    setState(() {
      notSuccessfullMessage = error;
    });
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const UnauthenticatedPageheader(
                subTitle: 'Enter the password for your business profile',
                title: 'Password',
              ),
            ),
            // const SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.05,
            // ),
            registerForm(),
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50)),
          onPressed: () async {
            _strength < 1 / 2 ? null : () {};
            if (_formKey.currentState!.validate() &&
                (_confirmPasswordController.text == _passwordController.text)) {
              setState(() {
                _register = _service?.signUpUserAccount(_getUserDetail(),
                    'https://curnect.com/curnect-api/public/api/registerpartone');
              });
              _register;
            }
          },
          child: const Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
      ),
      FutureBuilder(
          future: _register,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const EmptyLoader();
              case ConnectionState.waiting:
                return const LoadingPageGif();
              case ConnectionState.active:
                return const Text('active');
              case ConnectionState.done:
                return const EmptyLoader();
            }
          })
    ]);
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenForPassword = !_isHiddenForPassword;
    });
  }

  Map<String, String> _getUserDetail() {
    return {
      "email": widget.aboutYouFields["email"].toString(),
      "full_name": widget.aboutYouFields["fullName"].toString(),
      "business_name": widget.aboutYouFields["businesName"].toString(),
      "phone_number": widget.aboutYouFields["phone"].toString(),
      "referralCode": widget.aboutYouFields["referralCode"].toString(),
      "password": _confirmPasswordController.text.toString(),
      "token": ''
    };
  }

  Widget registerForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _passwordController,
              onChanged: (value) {
                _checkPassword(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please create a password';
                }
                return null;
              },
              obscureText: _isHiddenForPassword,
              style: const TextStyle(height: 1),
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFE6B325))),
                  suffixIcon: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHiddenForPassword
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.black54,
                    ),
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              onChanged: (value) {
                if (_passwordController.text.length == value.length) {
                  if (_passwordController.text == value) {
                    setState(() {
                      passwordMatch = false;
                    });
                  } else {
                    setState(() {
                      passwordMatch = true;
                    });
                  }
                } else if (_passwordController.text.length != value.length) {
                  setState(() {
                    passwordMatch = true;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a confirm password';
                }
                return null;
              },
              style: const TextStyle(height: 1),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                labelStyle: TextStyle(color: Colors.black54),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE6B325), width: 2)),
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: _isHidden,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.0009),
              child: Center(
                child: notSuccessfullMessage.isEmpty
                    ? null
                    : Text(
                        notSuccessfullMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.00),
                child: passwordMatch
                    ? const Text(
                        'Password does not match',
                        style: TextStyle(color: Colors.red, fontSize: 11),
                      )
                    : null),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).size.height * 0.0025,
                  0,
                  MediaQuery.of(context).size.height * 0.0025),
              child: LinearProgressIndicator(
                backgroundColor: Colors.black54,
                value: _strength,
                color: _strength <= 1 / 4
                    ? Colors.red
                    : _strength == 2 / 4
                        ? Colors.yellow
                        : _strength == 3 / 4
                            ? Colors.blue
                            : Colors.green,
                minHeight: 15,
              ),
            ),
          ],
        ));
  }
}
