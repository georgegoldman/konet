// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/widgets/appbar.dart';
import 'package:curnect/src/widgets/snackBar/ErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../services/user.dart';
import '../state_manager/add_service_manipulator.dart';
import '../style/animation/loading_gif.dart';

class LoginPage extends StatefulWidget {
  final bool onLoginPage = true;

  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ErrorSnackBar {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;
  bool showMessageError = false;
  User user = User(email: '', password: '', logIn: false);
  Future<void>? _login;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> loginRequest() async {
    // final userToken = getUserToken();

    try {
      final response = await user.login(
          'https://curnect.com/curnect-api/public/api/login',
          {"email": user.email, "password": user.password, "token": ''});
      // ignore: use_build_context_synchronously
      Provider.of<AddServiceManipulator>(context, listen: false).loginUser({
        'user_token': json.decode(response.body)['token'],
        'user_id': json.decode(response.body)['success']['userId'],
        'loggedIn': response.statusCode,
      });

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        context.replace('/verify');
      } else {
        switch (response.statusCode) {
          case 401:
            sendErrorMessage(
                "System Error",
                json.decode(response.body)['error'] ??
                    'Something went wrong but it\'s not you.',
                context);

            break;
          case 500:
            sendErrorMessage(
                "System Error",
                response.reasonPhrase ??
                    'Something went wrong but it\'s not you.',
                context);
            break;
          default:
            sendErrorMessage("System Error",
                'Something went wrong but it\'s not you.', context);
        }
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } catch (e) {
      print("an error occured");
    }

    // debugPrint(Provider.of<AddServiceManipulator>(context, listen: false)
    //     .user['user_id']
    //     .toString());
    // debugPrint(response['loggedIn'].toString());
  }

  void addUserToken(userToken) {
    Provider.of<AddServiceManipulator>(context, listen: false)
        .loginUser(userToken);
  }

  String getUserToken() {
    var user = Provider.of<AddServiceManipulator>(context).getUserToken();
    return user['token'].toString();
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
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  user.email = value;
                });
                // _emailController.text = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: const TextStyle(
                height: 1,
              ),
              decoration: const InputDecoration(
                  labelText: 'Email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFE6B325))),
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.black54,
                  )),
            ),
            const SizedBox(
              height: 27.0,
            ),
            TextFormField(
              controller: _passwordController,
              onChanged: (value) {
                setState(() {
                  user.password = value;
                });
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
                onPressed: (user.email.isNotEmpty && user.password.isNotEmpty)
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('Processing Data')));

                        }
                        setState(() {
                          _login = loginRequest();
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
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () =>
                      debugPrint('you just hit the google login button'),
                  icon: SvgPicture.asset(
                    'assets/images/google_login_icon.svg',
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      debugPrint('you just hit the apple login button'),
                  icon: SvgPicture.asset(
                    'assets/images/apple_login_icon.svg',
                  ),
                ),
              ],
            )),
            TextButton(
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              onPressed: () => context.replace('/resetenteremail'),
            ),
            TextButton(
              child: const Text('Not a member Sign up',
                  style: TextStyle(color: Color(0xFFE6B325), fontSize: 12)),
              onPressed: () => context.replace('/signup'),
            )
          ],
        ));
  }
}
