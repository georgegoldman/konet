// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/pages/verification/verification.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/utils/user.dart';
import 'package:curnect/src/common_widgets/loading_gif.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common_widgets/appbar.dart';
import '../../common_widgets/snackBar/ErrorMessage.dart';
import '../../common_widgets/unauthenticatedPageHeader.dart';
import '../../common_widgets/verificatoin/add_service.dart';
import '../../state_manager/add_service_manipulator.dart';

String title =
    "In Business Profile, you may get an option to add the services you offer, along with their descriptions and prices. If your business has multiple categories, group services together into sections under the appropriate category to keep your services organized. When local customers search on Google for a service you offer, that service may be highlighted on your profile. Customers on mobile devices can also find all your services under  \"Services.\"";

class AddService extends StatefulWidget {
  AddService({super.key, addedService});
  List<Map<String, dynamic>> addedService = [];

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> with ErrorSnackBar {
  bool successful = false;

  Future<void>? _adderviceFutureFunction;
  void _checkIsServiceAdded() {
    if (widget.addedService.isEmpty) {
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _checkIsServiceAdded();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(context: context, screeenInfo: title)
            .preferredSize(),
        body: addServeicWidget(),
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
              onPressed:
                  Provider.of<AddServiceManipulator>(context, listen: false)
                          .addedService
                          .isNotEmpty
                      ? () async {
                          setState(() {
                            _adderviceFutureFunction = addServiceRequest();
                          });
                          _adderviceFutureFunction;
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
          future: _adderviceFutureFunction,
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
                return const Text("active");
              case ConnectionState.done:
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
            }
          })
    ]);
  }

  Future<void> addServiceRequest() async {
    try {
      List allAddedService =
          Provider.of<AddServiceManipulator>(context, listen: false)
              .addedService;
      User user = User(email: '', password: '');
      Map<String, dynamic> body = {
        "_method": "patch",
        "services": allAddedService
      };
      http.StreamedResponse response = await user.addService(
          body, 'https://curnect.com/curnect-api/public/api/registerservice');
      // for (var i in allAddedService) {
      //   final response = await user.addService(
      //       i, 'https://curnect.com/curnect-api/public/api/registerservice');
      //   allRequest.add(response);
      // }
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context)
              .push(RouteAnimation(Screen: const Verification()).createRoute());
        } else {
          sendErrorMessage('Opps!', json.decode(res.body)['error'], context);
        }
      });
    } on SocketException catch (_) {
      sendErrorMessage(
          'Network Error', 'Please check your internet connection', context);
    } catch (e) {
      print(e);
    }
  }

  Widget addServeicWidget() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.1,
            child: const UnauthenticatedPageheader(
              subTitle:
                  'Add at least one service now. Later you can add more, creditdetails, and group services into categories.',
              title: 'Add Services',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03),
            child: InkWell(
                onTap: () => _dialogBuilder(context),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.add),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        const Text("Add Service"),
                      ],
                    ),
                    const Divider(
                      height: 16,
                      thickness: 1,
                      color: Colors.black,
                    )
                  ],
                )),
          ),
          Wrap(
            children: Provider.of<AddServiceManipulator>(context)
                .addedService
                .map<Widget>((e) => Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.03),
                      child: Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: e["mobileService"] != null
                              ? const Icon(Icons.moving_sharp)
                              : const Icon(Icons.pin_drop_outlined),
                        ),
                        label: Text("${e["serviceName"]}"),
                        onDeleted: () => Provider.of<AddServiceManipulator>(
                                context,
                                listen: false)
                            .deleteServiceList(e),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            title: const Text("Add Service"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 100,
              child: const SingleChildScrollView(
                child: AddServicePop(),
              ),
            ),
          );
        });
  }
}
