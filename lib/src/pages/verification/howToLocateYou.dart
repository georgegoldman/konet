import 'dart:convert';

import 'package:curnect/src/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common_widgets/appbar.dart';
import '../../common_widgets/emptyLoader.dart';
import '../../common_widgets/snackBar/ErrorMessage.dart';
import '../../common_widgets/unauthenticatedPageHeader.dart';
import '../../routes/route_animation.dart';
import '../../state_manager/add_service_manipulator.dart';
import '../../style/animation/loading_gif.dart';
import 'fetch_g_address.dart';

class HowToLocateYou extends StatefulWidget {
  const HowToLocateYou({super.key});

  @override
  State<HowToLocateYou> createState() => _HowToLocateYouState();
}

class _HowToLocateYouState extends State<HowToLocateYou> with ErrorSnackBar {
  Future<void>? _howtoLocateYouFuture;

  bool _myplace = false;
  bool _homeservice = false;
  int? successful;

  Future<void> howTolocateYouRequest() async {
    try {
      User user = User(email: '', password: '');
      String userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id']
          .toString();
      Map<String, String> body = {
        "_method": "patch",
        "userid": userId,
        'myplace': _myplace == false ? 0.toString() : 1.toString(),
        'homeservice': _homeservice == false ? 0.toString() : 1.toString()
      };
      final response = await user.locateUser(body,
          "https://curnect.com/curnect-api/public/api/registerservicelocation");
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context).push(
              RouteAnimation(Screen: const SearchPlacesScreen()).createRoute());
        } else {
          sendErrorMessage(
              res.reasonPhrase.toString(), json.decode(res.body), context);
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: UnauthenticatedAppBar(
                  context: context,
                  screeenInfo:
                      "Verify customer IDs with AI-powered biometric recognition service. Ensure quality identity verification with iDenfy's team that manually reviews every audit.")
              .preferredSize(),
          body: _body(),
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
                onPressed: ((_homeservice) || (_myplace))
                    ? () async {
                        setState(() {
                          _howtoLocateYouFuture = howTolocateYouRequest();
                        });
                        _howtoLocateYouFuture;
                      }
                    : null,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: _howtoLocateYouFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const EmptyLoader();
              case ConnectionState.waiting:
                debugPrint("waiting");
                return const LoadingPageGif();
              case ConnectionState.active:
                debugPrint("active");
                return const Text('active');
              case ConnectionState.done:
                return const EmptyLoader();
            }
          },
        )
      ],
    );
  }

  Widget _body() {
    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.1,
          child: const UnauthenticatedPageheader(
            subTitle:
                'Do your client come to you, do you go\nto them, or both?',
            title: 'How to Locate you',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01),
          child: CheckboxListTile(
            title: const Text("At my place"),
            subtitle: const Text(
                'My client come to me. I own the place of work\nin a salon/ suit alongside other professionals'),
            controlAffinity: ListTileControlAffinity.leading,
            value: _myplace,
            onChanged: (bool? value) {
              setState(() {
                _myplace = value ?? false;
              });
            },
            activeColor: const Color(0xFFE6B325),
            checkColor: Colors.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01),
          child: CheckboxListTile(
            title: const Text("At the client's location"),
            subtitle: const Text(
                'My client come to me. I own the place of work\nin a salon/ suit alongside other professionals'),
            controlAffinity: ListTileControlAffinity.leading,
            value: _homeservice,
            onChanged: (bool? value) {
              setState(() {
                _homeservice = value ?? false;
              });
            },
            activeColor: const Color(0xFFE6B325),
            checkColor: Colors.black,
          ),
        ),
      ],
    ));
  }
}
