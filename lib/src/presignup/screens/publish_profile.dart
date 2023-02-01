import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/common_widgets/appbar.dart';
import '../../utils/common_widgets/emptyLoader.dart';
import '../../utils/common_widgets/loading_gif.dart';
import '../../utils/common_widgets/unauthenticatedPageHeader.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../services/publish_profile.dart';
import 'hurray.dart';

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
  Future<void>? _publish_future;
  final String _chosenValue = "Now";
  bool publishDone = false;
  PublishService? _publishService;

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

  @override
  void initState() {
    _publishService = PublishService(context: context);
    super.initState();
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
              onPressed: () {
                //
                setState(() {
                  _publish_future = _publishService?.publishProfile({
                    'goLiveDate':
                        '${_selectedDate.value.day}-${_selectedDate.value.month}-${_selectedDate.value.year}'
                  });
                });
                _publish_future;
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
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
