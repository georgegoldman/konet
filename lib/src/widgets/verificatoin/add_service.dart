import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state_manager/add_service_manipulator.dart';

class AddServicePop extends StatefulWidget {
  const AddServicePop({super.key});

  @override
  State<AddServicePop> createState() => _AddServicePopState();
}

class _AddServicePopState extends State<AddServicePop> {
  final _formKey = GlobalKey<FormState>();
  String _priceType = "Price Type";
  int _defaultHours = 0;
  int _defaultMinutes = 0;
  bool _mobileService = false;
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _decriptionCodeController =
      TextEditingController();

  static List<int> getMinutes() {
    var minuteList = <int>[];
    for (int min = 0; min <= 60; min++) {
      minuteList.add(min);
    }
    return minuteList;
  }

  static List<int> getHours() {
    var minuteList = <int>[];
    for (int hrs = 0; hrs <= 24; hrs++) {
      minuteList.add(hrs);
    }
    return minuteList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).size.height * 0.03,
                  0,
                  MediaQuery.of(context).size.height * 0.03),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return TextFormField(
                    controller: _serviceNameController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(height: 1),
                    validator: (value) {
                      if (value!.length < 8) {
                        return 'Service name must be up 8';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        label: Text("Service name"),
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xFFE6B325)))),
                  );
                },
              ),
            ),
            const Text("Service duration"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return DropdownButtonFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              label: Text(
                                "Hour(s)",
                                style: TextStyle(color: Colors.black54),
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFE6B325)))),
                          items: getHours()
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                                value: value, child: Text("$value"));
                          }).toList(),
                          value: _defaultHours,
                          onChanged: (value) {
                            setState(() {
                              _defaultHours = value as int;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return DropdownButtonFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              label: Text(
                                "Minute(s)",
                                style: TextStyle(color: Colors.black54),
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFE6B325)))),
                          items: getMinutes()
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                                value: value, child: Text("$value"));
                          }).toList(),
                          value: _defaultMinutes,
                          onChanged: (value) {
                            setState(() {
                              _defaultMinutes = value as int;
                            });
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xFFE6B325)))),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
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
                          textInputAction: TextInputAction.done,
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(height: 1),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              label: Text("Price"),
                              prefix: Text("₦"),
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Color(0xFFE6B325)))),
                        );
                      },
                    ),
                  )
                : const Text(''),
            SizedBox(
              child: FormField<String>(builder: (FormFieldState<String> state) {
                return TextFormField(
                  validator: (value) {
                    if (value!.length < 100 && !value.isNotEmpty) {
                      return 'Service name must not be null and must be more than 100';
                    }
                    return null;
                  },
                  controller: _decriptionCodeController,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(height: 1),
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFFE6B325))),
                      label: Text("Service description"),
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                      hintText: 'Do your service have a description?'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                );
              }),
            ),
            SwitchListTile(
              onChanged: (bool value) {
                setState(() {
                  _mobileService = value;
                });
              },
              title: const Text("Mobile Service"),
              value: _mobileService,
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: const Color(0xFFE6B325),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  bottom: MediaQuery.of(context).size.height * 0.00),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: _serviceNameController.text.isEmpty &&
                        _defaultHours == 0 &&
                        _defaultMinutes == 0
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          int userId = Provider.of<AddServiceManipulator>(
                                  context,
                                  listen: false)
                              .user['user_id'];
                          setState(() {
                            Provider.of<AddServiceManipulator>(context,
                                    listen: false)
                                .updateServiceList({
                              "user_id": userId,
                              "serviceName":
                                  _serviceNameController.text.toString(),
                              "serviceDuration":
                                  "${_defaultHours.toString().padLeft(2, '0')}:${_defaultMinutes.toString().padLeft(2, '0')}",
                              "serviceAmount": _priceController.text.isEmpty
                                  ? 0.toString()
                                  : _priceController.text,
                              "servicePriceType": _priceType.toString(),
                              "mobileService": _mobileService,
                              "servicesDescription": _decriptionCodeController
                                          .text
                                          .toString() ==
                                      ''
                                  ? "null"
                                  : _decriptionCodeController.text.toString()
                            });
                          });
                          Navigator.of(context).pop();
                        }
                      },
                child: const Text(
                  'Add Service',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ));
  }
}
