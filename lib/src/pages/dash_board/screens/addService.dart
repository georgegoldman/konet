import 'package:curnect/src/common_widgets/formFields/formFields.dart';
import 'package:flutter/material.dart';

class DashboardAddService extends StatefulWidget {
  const DashboardAddService({super.key});

  @override
  State<DashboardAddService> createState() => _DashboardAddServiceState();
}

class _DashboardAddServiceState extends State<DashboardAddService>
    with FormInputFields {
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _servicePrice = TextEditingController();
  String _priceType = "Price Type";
  String _serviceDuration = "service duration";
  int _defaultMinutes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
          child: ListView(
        children: [
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
                      _priceType = value!;
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
            child: Column(children: const [
              ListTile(
                title: Text('Service color'),
                trailing: Icon(
                  Icons.color_lens_rounded,
                  color: Colors.blueAccent,
                ),
              )
            ]),
          )
        ],
      )),
    );
  }
}
