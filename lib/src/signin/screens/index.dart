// ignore_for_file: file_names, use_build_context_synchronously

import 'package:curnect/src/signin/service/index.dart';
import 'package:curnect/src/signin/widgets/forgetPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common_widgets/appbar.dart';
import '../../common_widgets/formFields/formFields.dart';
import '../../common_widgets/snackBar/ErrorMessage.dart';
import '../../common_widgets/loading_gif.dart';
import '../widgets/socialMediaSignIn.dart';

class LoginPage extends StatefulWidget {
  final bool onLoginPage = true;

  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with ErrorSnackBar, FormInputFields {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;
  bool showMessageError = false;
  Future<void>? _login;
  SigninService? _service;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    _service = SigninService(context: context);
    super.initState();
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
              const SizedBox(
                height: 50.0,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.055,
                  ),
                  const Text(
                    'Sign in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              loginForm(),
            ],
          ),
        ),
      ),
      FutureBuilder(
          future: _login,
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

  Widget loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            email(_emailController),
            const SizedBox(
              height: 27.0,
            ),
            TextFormField(
              controller: _passwordController,
              onChanged: (value) {
                // _passwordController.text = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a pasword';
                }
                return null;
              },
              style: const TextStyle(height: 1),
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  labelStyle: const TextStyle(color: Colors.black54),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFE6B325), width: 2)),
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHidden
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.black54,
                    ),
                  )),
              obscureText: _isHidden,
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
                  const Text('Other sign in options'),
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty)
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('Processing Data')));

                        }
                        setState(() {
                          _login = _service?.signInUser(
                            _emailController.text.toString(),
                            _passwordController.text.toString(),
                          );
                        });
                        _login;
                      }
                    : null,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            const SocialMediaSignIn(),
            const ForgetPassword(),
            TextButton(
              child: const Text('Not a member Sign up',
                  style: TextStyle(color: Color(0xFFE6B325), fontSize: 12)),
              onPressed: () => context.replace('/signup'),
            )
          ],
        ));
  }
}
