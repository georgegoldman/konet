import 'package:curnect/src/pages/verification/hurray.dart';
import 'package:curnect/src/services/user.dart';
import 'package:curnect/src/style/animation/loading_gif.dart';
import 'package:curnect/src/widgets/emptyLoader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state_manager/add_service_manipulator.dart';
import '../../widgets/appbar.dart';
import '../../widgets/unauthenticatedPageHeader.dart';

class PublishProfile extends StatefulWidget {
  const PublishProfile({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<PublishProfile> createState() => _PublishProfileState();
}

class _PublishProfileState extends State<PublishProfile> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  // ignore: non_constant_identifier_names
  Future<bool>? _publish_future;
  final String _chosenValue = "Now";
  bool publishDone = false;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
          onComplete: _selectDate,
          onPresent: (NavigatorState navigator, Object? arguments) {
            return navigator.restorablePush(_datePickerRoute,
                arguments: _selectedDate.value.millisecondsSinceEpoch);
          });

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
              restorationId: 'date_picker_dialog',
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 7)));
        });
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}-${_selectedDate.value.month}-${_selectedDate.value.year}'),
        ));
      });
    }
  }

  Future<bool> publishProfile() async {
    User user = User(email: '', password: '');
    int userId = Provider.of<AddServiceManipulator>(context, listen: false)
        .user['user_id'];
    Map<String, String> body = {
      '_method': 'patch',
      'userId': userId.toString(),
      'goLiveDate':
          '${_selectedDate.value.day}-${_selectedDate.value.month}-${_selectedDate.value.year}'
    };

    bool response = await user.publishProfileController(body,
        'https://curnect.com/curnect-api/public/api/registerdatetogolive');
    return response;
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
            subTitle: 'Set a time for live launching.',
            title: 'Publish your\nprofile',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.07),
          child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xFFE6B325)))),
              isExpanded: true,
              items: <String>[
                'Now',
                'Custom',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text(_chosenValue),
              onChanged: (value) {
                if (value == 'Custom') {
                  _restorableDatePickerRouteFuture.present();
                }
                return;
              }),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(
                context: context,
                screeenInfo:
                    'To alleviate the nuisance of re-entering publishing options you may want to always use (such as backing up the database before publish, for instance), you can save publish profiles and refer to them every time you want to publish. These profiles are XML based files that reside in the root folder of your project.')
            .preferredSize(),
        body: _body(),
        persistentFooterButtons: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50)),
            //check if the validation is successful
            onPressed: () {
              //
              setState(() {
                _publish_future = publishProfile();
              });
              _publish_future!.then((value) {
                setState(() {
                  publishDone = value;
                });
              }).whenComplete(() {
                if (publishDone) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Hurray();
                  }));
                } else {
                  throw Exception("The publish proces was not successful");
                }
              });
            },
            child: const Text(
              'Continue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          )
        ],
      ),
      FutureBuilder(
        future: _publish_future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const EmptyLoader();
            case ConnectionState.waiting:
              return const LoadingPageGif();
            case ConnectionState.active:
              return const Text('Active');
            case ConnectionState.done:
              return const EmptyLoader();
          }
        },
      )
    ]);
  }
}
