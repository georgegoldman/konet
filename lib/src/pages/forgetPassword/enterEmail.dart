// ignore_for_file: file_names

import 'package:curnect/src/customException/unsuccessfulRequestException.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/user.dart';
import '../../style/animation/loading_gif.dart';
import '../../widgets/appbar.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({super.key});

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verifyEmailController = TextEditingController();
  Future<Map<String, dynamic>>? _checkEmail;
  int? connectionDone;
  String? userId;

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

  Future<Map<String, dynamic>> checkEmail() async {
    try {
      var user =
          User(email: _verifyEmailController.text, password: '', token: '');
      final response = await user.checkResetPasswordEmailAPI(
          {'email': user.email.toString()},
          'https://curnect.com/curnect-api/public/api/checkforgetemail');
      return response;
    } on UnsuccessfulRequestException catch (e) {
      return {"statusCode": 406, 'error': e.cause};
    } catch (e) {
      return {"statusCode": 401, 'error': e};
    }
  }

  Widget enterEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _verifyEmailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {});
              // _emailController.text = value;
            },
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return 'Please fill in the field';
              } else if (!(RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                  .hasMatch(value))) {
                return 'Please enter a valid email';
              } else {
                return null;
              }
            },
            style: const TextStyle(
              height: 1,
            ),
            decoration: const InputDecoration(
              labelText: 'Email',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              labelStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFFE6B325))),
              suffix: Icon(
                Icons.email_outlined,
                color: Colors.black54,
              ),
            ),
          ),
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
                      if (_formKey.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('Processing Data')));

                      }
                      setState(() {
                        _checkEmail = checkEmail();
                      });
                      _checkEmail!.then((value) {
                        setState(() {
                          connectionDone = value['statusCode'];
                          userId = value["userId"].toString();
                        });
                      }).whenComplete(() {
                        if (connectionDone == 200) {
                          // ignore: use_build_context_synchronously
                          context.replace('/getyourcode', extra: {
                            "email": _verifyEmailController.text.toString(),
                            "userId": userId
                          });
                        } else {
                          // ignore: use_build_context_synchronously
                          return;
                        }
                      });
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
