import 'package:flutter/material.dart';

import '../../../../common_widgets/formFields/formFields.dart';
import '../../../widgets/getWidget.dart';

class AddAddons extends StatefulWidget {
  const AddAddons({super.key});

  @override
  State<AddAddons> createState() => _AddAddonsState();
}

class _AddAddonsState extends State<AddAddons>
    with FormInputFields, DashBoardWidgets {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addOnName = TextEditingController();
  final TextEditingController _addOnDescription = TextEditingController();
  final TextEditingController _addOnAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        titleSpacing: 0.0,
        title: const Text(
          "Add Addons",
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
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      textInput(_addOnName, 'Ad ons Name', null, '', 1,
                          TextInputType.text, true),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (value!.isEmpty) {
                              return 'It is required';
                            }
                          }
                          return null;
                        },
                        controller: _addOnDescription,
                        maxLength: null,
                        maxLines: 5,
                        style: const TextStyle(height: 1),
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7)),
                            hintText: 'Add Description',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                  width: 2.0, color: Color(0xFFE6B325)),
                            )),
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      textInput(_addOnAmount, 'Amount', null, '', 1,
                          TextInputType.number, false),
                    ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
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
