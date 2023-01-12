import 'package:flutter/material.dart';

import '../../../common_widgets/formFields/formFields.dart';
import '../widgets/dashBoardForm/dropdownFormDash.dart';
import '../widgets/getWidget.dart';

class AddBundle extends StatefulWidget {
  const AddBundle({super.key});

  @override
  State<AddBundle> createState() => _AddBundleState();
}

class _AddBundleState extends State<AddBundle>
    with FormInputFields, DashBoardWidgets {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bundleName = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _addDescription = TextEditingController();
  String _serviceuDuration = '1hr 45m';

  @override
  Widget build(BuildContext context) {
    DashBoardDropDownFormField serviceDuration = createDropDownpList(
      _serviceuDuration,
      'Service Duration',
      const [
        '15m',
        '30m',
        '45m',
        '1h',
        '1hr 45m',
        '2hr',
        '2hr 30m',
        '5hr',
      ],
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        titleSpacing: 0.0,
        title: const Text(
          "Add Bundle",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      const SizedBox(
                        height: 15,
                      ),
                      textInput(_bundleName, 'bundle name', null,
                          'hair styling', 1, TextInputType.text, true),
                      const SizedBox(
                        height: 15,
                      ),
                      textInput(_category, 'category', null, 'No category', 1,
                          TextInputType.text, true),
                      const SizedBox(
                        height: 15,
                      ),
                      serviceDuration,
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: const Text('AB'),
                            ),
                            label: const Text('Aaron Burr'),
                          ),
                          Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: const Text('AB'),
                            ),
                            label: const Text('Aaron Burr'),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      textInput(_addDescription, 'Add description', null, '', 1,
                          TextInputType.multiline, true)
                    ]),
                  )
                ],
              ))
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
