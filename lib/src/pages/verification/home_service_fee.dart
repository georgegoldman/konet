import 'package:curnect/src/pages/verification/business_hours.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/user.dart';
import '../../state_manager/add_service_manipulator.dart';
import '../../style/animation/loading_gif.dart';
import '../../widgets/appbar.dart';
import '../../widgets/emptyLoader.dart';
import '../../widgets/unauthenticatedPageHeader.dart';

class GetHomeServiceFee extends StatefulWidget {
  const GetHomeServiceFee({super.key});

  @override
  State<GetHomeServiceFee> createState() => _GetHomeServiceFeeState();
}

class _GetHomeServiceFeeState extends State<GetHomeServiceFee> {
  final _formKey = GlobalKey<FormState>();
  String _priceType = 'Enter price type';
  String _maxTraveledDist = 'Select a mile distance in miles';
  final TextEditingController _travelFeeController = TextEditingController();
  final TextEditingController _homeServiceController = TextEditingController();
  int? successful;
  Future<Map<String, dynamic>>? _homeServiceFuction;

  void dropdownCallack(String? selectedValue) {
    if (selectedValue is String) {
      _priceType = selectedValue;
    }
  }

  Future<Map<String, dynamic>> homeServiceAPI() async {
    User user = User(email: '', password: '');
    int userId = Provider.of<AddServiceManipulator>(context, listen: false)
        .user['user_id'];
    Map<String, String> body = {
      '_method': 'patch',
      'userid': userId.toString(),
      'pricetype': _priceType.toString(),
      'travelfee': _travelFeeController.text.toString() == ''
          ? "0"
          : _travelFeeController.text.toString(),
      'maximumtraveldistance': _maxTraveledDist.toString(),
      'homeservicepolicy': _homeServiceController.text.toString() == ''
          ? "null"
          : _homeServiceController.text.toString()
    };

    Map<String, dynamic> response = await user.homeServiceAPIFunction(body,
        'https://curnect.com/curnect-api/public/api/registerhomeservicefee');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(),
        FutureBuilder(
          future: _homeServiceFuction,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // ignore: todo
                // TODO: Handle this case.
                return const EmptyLoader();
              case ConnectionState.waiting:
                // ignore: todo
                // TODO: Handle this case.
                return const LoadingPageGif();
              case ConnectionState.active:
                // ignore: todo
                // TODO: Handle this case.
                return const Text("Is Active");
              case ConnectionState.done:
                // ignore: todo
                // TODO: Handle this case.
                return const EmptyLoader();
            }
          },
        )
      ],
    );
  }

  Widget _body() {
    return Scaffold(
      appBar: UnauthenticatedAppBar(context: context, screeenInfo: title)
          .preferredSize(),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.1,
            child: const UnauthenticatedPageheader(
              subTitle: 'Charge your customer base on your location?',
              title: 'How far can you go',
            ),
          ),
          Column(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 12),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2.0,
                                            color: Color(0xFFE6B325)))),
                                isExpanded: true,
                                items: <String>[
                                  'Fixed',
                                  'Varies',
                                  'Free',
                                  'Starts at'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(_priceType),
                                onChanged: (value) {
                                  setState(() {
                                    _priceType = value!;
                                  });
                                });
                          },
                        ),
                      ),
                      _priceType == 'Fixed' || _priceType == 'Starts at'
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0,
                                  MediaQuery.of(context).size.height * 0,
                                  0,
                                  MediaQuery.of(context).size.height * 0.03),
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return TextFormField(
                                    controller: _travelFeeController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(height: 1),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 12),
                                        prefix: Text("₦"),
                                        label: Text("Travel Fee "),
                                        labelStyle:
                                            TextStyle(color: Colors.black54),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2.0,
                                                color: Color(0xFFE6B325)))),
                                    validator: (value) {
                                      return null;
                                    },
                                  );
                                },
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 12),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2.0,
                                            color: Color(0xFFE6B325)))),
                                isExpanded: true,
                                items: <String>[
                                  '10',
                                  '15',
                                  '20',
                                  '25'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(_maxTraveledDist),
                                onChanged: (value) {
                                  setState(() {
                                    _maxTraveledDist = value!;
                                  });
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.01),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return TextFormField(
                              maxLines: 5,
                              controller: _homeServiceController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  // label: Text(),
                                  hintText: "Home Service Fee Policy(Optional)",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0,
                                          color: Color(0xFFE6B325)))),
                              validator: null,
                            );
                          },
                        ),
                      ),
                    ],
                  ))
            ],
          )
        ],
      )),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50)),
          onPressed: (_priceType != 'Enter price type' &&
                  _maxTraveledDist != 'Select a mile distance')
              ? () {
                  setState(() {
                    _homeServiceFuction = homeServiceAPI();
                  });
                  _homeServiceFuction!.then((value) {
                    print(value);
                    setState(() {
                      successful = value["statusCode"];
                    });
                  }).whenComplete(() {
                    if (successful == 202) {
                      Navigator.of(context).push(
                          RouteAnimation(Screen: const BusinessHours())
                              .createRoute());
                    }
                  });
                }
              : null,
          child: const Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
