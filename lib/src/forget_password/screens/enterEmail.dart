// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/forget_password/service/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common_widgets/appbar.dart';
import '../../common_widgets/formFields/formFields.dart';
import '../../common_widgets/snackBar/ErrorMessage.dart';
import '../../../utils/user/sevice/index.dart';
import '../../common_widgets/loading_gif.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({super.key});

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail>
    with ErrorSnackBar, FormInputFields {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verifyEmailController = TextEditingController();
  Future<void>? _checkEmail;
  int? connectionDone;
  String? userId;
  ResetPasswordService? resetPasswordService;

  @override
  void initState() {
    resetPasswordService = ResetPasswordService(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(
                context: context,
                screeenInfo: "Please enter a verified email from our platform")
            .preferredSize(),
        body: SafeArea(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.071,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                const SizedBox(
                  child:
                      Text("Enter email address associated with your account"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                enterEmailForm()
              ],
            ),
          ],
        )),
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
                debugPrint("active");
                return const Text('active');
              case ConnectionState.done:
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
            }
          })
    ]);
  }

  Widget enterEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          email(_verifyEmailController),
          const SizedBox(
            height: 27.0,
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
              onPressed: (_verifyEmailController.text.isNotEmpty &&
                      _formKey.currentState!.validate())
                  ? () async {
                      if (_formKey.currentState!.validate()) {}
                      setState(() {
                        _checkEmail = checkEmail();
                      });
                      _checkEmail;
                    }
                  : null,
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.001),
            child: Center(
                child: TextButton(
              child: const Text('Back',
                  style: TextStyle(
                    color: Color(0xFFE6B325),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () => context.replace('/signin'),
            )),
          )
        ],
      ),
    );
  }
}
