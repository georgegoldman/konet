// ignore_for_file: file_names

import 'package:curnect/src/services/base_service.dart';
import 'package:curnect/src/services/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../customException/unsuccessfulRequestException.dart';
import '../../style/animation/loading_gif.dart';
import '../../widgets/appbar.dart';

class GetYourCode extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const GetYourCode({super.key, required this.userData});

  @override
  State<GetYourCode> createState() => _GetYourCodeState();
}

class _GetYourCodeState extends State<GetYourCode> {
  final _formKey = GlobalKey<FormState>();
  Future<Map<String, dynamic>>? _sendCodeFuture;
  String? pinCode;
  int? successCode;

  Future<Map<String, dynamic>> pinCodeAPI() async {
    try {
      var user = User(email: '', password: '', token: '');
      print(pinCode);
      var response = await user.checkResetPasswordPincodeAPI({
        "_method": "patch",
        "userid": widget.userData!["userId"].toString(),
        "token": pinCode!.toString()
      }, 'https://curnect.com/curnect-api/public/api/checktoken');
      return response;
    } on UnsuccessfulRequestException catch (e) {
      return {"statusCode": 406, 'error': e.cause};
    } catch (e) {
      return {"statusCode": 401, 'error': e};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: UnauthenticatedAppBar(
                  context: context,
                  screeenInfo:
                      "Please enter a verified emial from our plateform")
              .preferredSize(),
          body: SafeArea(
              child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(
                height: 50.0,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    // child: Text("${widget.userData!["email"]}"),
                  ),
                  const Text(
                    'VerificationPin here',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    child: Text("Enter verification pin"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  getCodeForm(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    child: TextButton(
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(fontSize: 17),
                        ),
                        onPressed: () async {
                          var response = await BaseService().ResetPincode({
                            'email': widget.userData!["email"].toString()
                          }, 'https://curnect.com/curnect-api/public/api/checkforgetemail');
                        }),
                  ),
                  // TextButton(
                  //     onPressed: () => context.pop(),
                  //     child: Text(
                  //       "Back",
                  //       style: TextStyle(fontSize: 18),
                  //     ))
                ],
              ),
            ],
          ))),
      FutureBuilder(
          future: _sendCodeFuture,
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
          }),
    ]);
  }

  Widget getCodeForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[buildPinPut()],
      ),
    );
  }

  Widget buildPinPut() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE6B325)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      closeKeyboardWhenCompleted: true,
      onCompleted: (pin) async {
        setState(() {
          pinCode = pin;
          _sendCodeFuture = pinCodeAPI();
        });

        _sendCodeFuture!.then((value) {
          setState(() {
            successCode = value["statusCode"];
          });
        }).whenComplete(() {
          if (successCode == 202) {
            context.replace('/resetpasword',
                extra: {"userId": widget.userData!["userId"]});
          }
        });
      },
    );
  }
}
