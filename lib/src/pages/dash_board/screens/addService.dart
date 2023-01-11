import 'package:curnect/src/common_widgets/formFields/formFields.dart';
import 'package:curnect/src/pages/dash_board/widgets/getWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../widgets/dashBoardForm/dropdownFormDash.dart';

class DashboardAddService extends StatefulWidget {
  const DashboardAddService({super.key});

  @override
  State<DashboardAddService> createState() => _DashboardAddServiceState();
}

class _DashboardAddServiceState extends State<DashboardAddService>
    with FormInputFields, DashBoardWidgets {
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _servicePrice = TextEditingController();
  String _priceType = "Price Type";
  String _serviceDuration = "service duration";
  final String _interval = '15m';
  final String _newinterval = '15m';
  final String _processTimeDuringService = '15m';
  final String _processTimeAterService = '15m';
  final String _taxRate = '5.00%';
  final int _defaultMinutes = 0;
  final _formKey = GlobalKey<FormState>();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  bool _bookOnline = false;
  bool _mobileService = false;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    DashBoardDropDownFormField taxRating = createDropDownpList(
      _taxRate,
      'Tax Rate',
      const [
        '5.00%',
        '10.00%',
        '15.00%',
        '25.00%',
        '45.00%',
        '50.00%',
        '75.00%',
        '100.00%',
      ],
    );
    DashBoardDropDownFormField processingTime = createDropDownpList(
      _processTimeDuringService,
      'Processing Time During Service',
      const [
        '15m',
        '30m',
        '45min',
        '1h',
        '1h-30m',
        '2h',
        '2h-30m',
        '5h',
      ],
    );
    DashBoardDropDownFormField processingAfter = createDropDownpList(
      _processTimeAterService,
      'Processing Time After Service',
      const [
        '15m',
        '30m',
        '45min',
        '1h',
        '1h-30m',
        '2h',
        '2h-30m',
        '5h',
      ],
    );
    DashBoardDropDownFormField paddingTime = createDropDownpList(
      _newinterval,
      'Padding time',
      const [
        '15m',
        '30m',
        '45min',
        '1h',
        '1h-30m',
        '2h',
        '2h-30m',
        '5h',
      ],
    );
    DashBoardDropDownFormField interval = createDropDownpList(
      _interval,
      'interval',
      const [
        '15m',
        '30m',
        '45min',
        '1h',
        '1h-30m',
        '2h',
        '2h-30m',
        '5h',
      ],
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  textInput(_serviceName, 'Service name', null, 'Hair curve', 1,
                      TextInputType.text, true),
                  const SizedBox(
                    height: 15,
                  ),
                  textInput(_category, 'category', null, 'Not Category', 1,
                      TextInputType.text, true),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xFFE6B325)))),
                      isExpanded: true,
                      items: <String>[
                        '30min',
                        '45min',
                        '1hr',
                        '1hr 30min',
                        '2hr',
                        '2hr 30min',
                        '5hr',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(_serviceDuration),
                      onChanged: (value) {
                        setState(() {
                          _serviceDuration = value!;
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xFFE6B325)))),
                            isExpanded: true,
                            items: <String>[
                              'Fixed',
                              'Varies',
                              'Don’t show',
                              'Free',
                              'Starts at',
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
                            }),
                      )),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: textInput(_servicePrice, 'Price', null,
                            'Enter amount', 1, TextInputType.number, true),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textInput(_description, 'description', null, 'optional', 2,
                      TextInputType.multiline, true),
                ]),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(left: 24),
                alignment: Alignment.centerLeft,
                width: 500,
                height: MediaQuery.of(context).size.width * 0.1,
                color: Colors.black12,
                child: const Text('Details'),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(left: 24),
                alignment: Alignment.centerLeft,
                width: 500,
                height: MediaQuery.of(context).size.width * 0.1,
                color: Colors.black12,
                child: const Text('Settings'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  ListTile(
                    title: const Text('Service color'),
                    trailing: IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      currentColor = pickerColor;
                                      print(currentColor);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('OK'),
                                )
                              ],
                            );
                          }),
                      icon: Icon(
                        Icons.circle,
                        color: pickerColor,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    onChanged: (value) {
                      setState(() {
                        _bookOnline = value;
                      });
                    },
                    title: Text('Allow clients to book online'),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: _bookOnline,
                  ),
                  SwitchListTile(
                    onChanged: (value) {
                      setState(() {
                        _mobileService = value;
                      });
                    },
                    title: const Text('Mobile service'),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: _mobileService,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  interval,
                  const SizedBox(
                    height: 15,
                  ),
                  paddingTime,
                  const SizedBox(
                    height: 15,
                  ),
                  processingTime,
                  const SizedBox(
                    height: 15,
                  ),
                  processingAfter,
                  const SizedBox(
                    height: 15,
                  ),
                  taxRating,
                  const SizedBox(
                    height: 25,
                  )
                ]),
              )
            ]),
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
          //check if the validation is successful
          onPressed: (false) ? () async {} : null,
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
