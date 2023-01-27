import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/preregistration/upload_workspace_image.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/utils/user/sevice/index.dart';
import 'package:curnect/utils/state/add_service_manipulator.dart';
import 'package:curnect/utils/common_widgets/loading_gif.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../utils/common_widgets/appbar.dart';
import '../../utils/common_widgets/emptyLoader.dart';
import '../../utils/common_widgets/snackBar/ErrorMessage.dart';
import '../../utils/common_widgets/unauthenticatedPageHeader.dart';

String title =
    'Business hours are the hours during the day in which business is commonly conducted. Typical business hours vary widely by country. By observing common informal standards for business hours, workers may communicate with each other more easily and find a convenient divide between work life and home life.';

class BusinessHours extends StatefulWidget {
  const BusinessHours({super.key});

  @override
  State<BusinessHours> createState() => _BusinessHoursState();
}

class _BusinessHoursState extends State<BusinessHours> with ErrorSnackBar {
  final Map<String, Map<String, dynamic>> days = {
    'sunday': {
      'on': false,
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    },
    'monday': {
      'on': false,
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    },
    'tuesday': {
      'on': false,
      'day': 'tuesday',
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    },
    'wednesday': {
      'on': false,
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    },
    'thursday': {
      'on': false,
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    },
    'friday': {
      'on': false,
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    },
    'saturday': {
      'on': false,
      'starttime': const TimeOfDay(hour: 00, minute: 00),
      'endtime': const TimeOfDay(hour: 00, minute: 00)
    }
  };

  Future<void>? _businessHour;
  User user = User(email: '', password: '');
  bool successful = false;
  Map<String, dynamic> body = {};
  List<Map<String, dynamic>> businessHours = [];

  Future<void> businessHourRequest() async {
    int userId = Provider.of<AddServiceManipulator>(context, listen: false)
        .user['user_id'];
    // String token = Provider.of<AddServiceManipulator>(context, listen: false)
    //     .user['user_token'];
    for (var day in days.keys) {
      businessHours.add({
        "user_id": userId,
        "days": day,
        "availability": days[day]!['on'],
        "start_time":
            "${days[day]!['starttime'].hour.toString().padLeft(2, '0')}:${days[day]!['starttime'].minute.toString().padLeft(2, '0')}"
                .toString(),
        "end_time":
            "${days[day]!['endtime'].hour.toString().padLeft(2, '0')}:${days[day]!['endtime'].minute.toString().padLeft(2, '0')}" ==
                    "24:00"
                ? "00:00"
                : "${days[day]!['endtime'].hour.toString().padLeft(2, '0')}:${days[day]!['endtime'].minute.toString().padLeft(2, '0')}",
      });
    }
    try {
      body["businessHours"] = businessHours;
      http.StreamedResponse response = await user.businessHour(
          'https://curnect.com/curnect-api/public/api/registerbusinesshour',
          body);

      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context).push(
              RouteAnimation(Screen: const UploadWorkspaceImage())
                  .createRoute());
        } else {
          sendErrorMessage(res.reasonPhrase.toString(),
              json.decode(res.body)['error'], context);
        }
      });
    } on SocketException catch (_) {
      sendErrorMessage(
          'Network error', 'Please check your networkconnection', context);
    } catch (e) {}
    // debugPrint(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(context: context, screeenInfo: title)
            .preferredSize(),
        body: businessHourWidget(),
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
              onPressed: days['sunday']!['on'] ||
                      days['monday']!['on'] ||
                      days['tuesday']!['on'] ||
                      days['wednesday']!['on'] ||
                      days['thursday']!['on'] ||
                      days['friday']!['on'] ||
                      days['saturday']!['on']
                  ? () async {
                      setState(() {
                        _businessHour = businessHourRequest();
                      });
                      _businessHour;
                      // debugPrint("this is the ouput of the program");
                      // debugPrint(successful.toString());
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
        future: _businessHour,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const EmptyLoader();
            case ConnectionState.waiting:
              // ignore: todo
              // TODO: Handle this case.
              return const LoadingPageGif();
            case ConnectionState.active:
              // ignore: todo
              // TODO: Handle this case.
              return const Text('active');
            case ConnectionState.done:
              // ignore: todo
              // TODO: Handle this case.
              return const EmptyLoader();
          }
        },
      )
    ]);
  }

  Widget businessHourWidget() {
    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.1,
          child: const UnauthenticatedPageheader(
            subTitle: 'where can you clients find you?',
            title: 'Business Hours',
          ),
        ),
        Column(
          children: <Widget>[
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['sunday']!['on'] = value;
                });
              },
              title: Text(
                "Sunday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['sunday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['sunday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['sunday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['sunday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['sunday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['sunday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['sunday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: days['sunday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['sunday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['sunday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['sunday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['sunday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['monday']!['on'] = value;
                });
              },
              title: Text(
                "Monday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['monday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['monday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['monday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['monday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['monday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['monday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['monday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: days['monday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['monday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['monday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['monday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['monday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['tuesday']!['on'] = value;
                });
              },
              title: Text(
                "Tuesday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['tuesday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['tuesday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['tuesday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['tuesday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['tuesday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['tuesday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['tuesday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: days['tuesday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['tuesday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['tuesday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['tuesday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['tuesday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['wednesday']!['on'] = value;
                });
              },
              title: Text(
                "Wednesday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['wednesday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['wednesday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['wednesday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['wednesday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['wednesday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['wednesday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['wednesday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['wednesday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['wednesday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['wednesday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['wednesday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['wednesday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['thursday']!['on'] = value;
                });
              },
              title: Text(
                "Thursday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['thursday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['thursday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['thursday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['thursday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['thursday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['thursday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['thursday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['thursday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['thursday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['thursday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['thursday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['thursday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['friday']!['on'] = value;
                });
              },
              title: Text(
                "Friday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['friday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['friday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['friday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['friday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['friday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['friday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['friday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: days['friday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['friday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['friday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['friday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['friday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
            SwitchListTile(
              onChanged: (value) {
                setState(() {
                  days['saturday']!['on'] = value;
                });
              },
              title: Text(
                "Saturday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: days['saturday']!['on'] ? null : Colors.black26),
              ),
              subtitle: days['saturday']!['on']
                  ? Wrap(children: [
                      TextButton(
                          onPressed: days['saturday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['saturday']!['starttime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['saturday']!['starttime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['saturday']!['starttime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325)))),
                      TextButton(
                          onPressed: days['saturday']!['on']
                              ? () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          days['saturday']!['endtime']);

                                  if (newTime == null) return;
                                  setState(() {
                                    days['saturday']!['endtime'] = newTime;
                                  });
                                }
                              : null,
                          child: Text(
                              days['saturday']!['endtime'].format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6B325))))
                    ])
                  : null,
              secondary: days['saturday']!['on']
                  ? null
                  : const Text("Closed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26)),
              value: days['saturday']!['on'],
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFE6B325),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.00010,
              thickness: 2,
            ),
          ],
        )
      ],
    ));
  }
}
