import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../utils/common_widgets/appbar.dart';
import '../../utils/common_widgets/emptyLoader.dart';
import '../../utils/common_widgets/loading_gif.dart';
import '../../utils/common_widgets/unauthenticatedPageHeader.dart';
import '../services/howToLocateYou.dart';

class HowToLocateYou extends StatefulWidget {
  const HowToLocateYou({super.key});

  @override
  State<HowToLocateYou> createState() => _HowToLocateYouState();
}

class _HowToLocateYouState extends State<HowToLocateYou> {
  Future<void>? _howtoLocateYouFuture;

  bool _myplace = false;
  bool _homeservice = false;
  int? successful;
  HowToLocateService? _howToLocateService;
  bool _keyboardOpen = false;

  @override
  void initState() {
    _howToLocateService = HowToLocateService(context: context);
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() => _keyboardOpen = visible);
    });
    super.initState();
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _keyboardOpen
              ? const SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
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
                              _howtoLocateYouFuture =
                                  _howToLocateService?.howTolocateYouRequest({
                                'myplace': _myplace == false
                                    ? 0.toString()
                                    : 1.toString(),
                                'homeservice': _homeservice == false
                                    ? 0.toString()
                                    : 1.toString()
                              });
                            });
                            _howtoLocateYouFuture;
                          }
                        : null,
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
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
