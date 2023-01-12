import 'package:flutter/material.dart';

import '../../../common_widgets/formFields/formFields.dart';
import '../widgets/getWidget.dart';

class AddAddons extends StatefulWidget {
  const AddAddons({super.key});

  @override
  State<AddAddons> createState() => _AddAddonsState();
}

class _AddAddonsState extends State<AddAddons>
    with FormInputFields, DashBoardWidgets {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _addOnName = TextEditingController();
  TextEditingController _addOnDescription = TextEditingController();
  TextEditingController _addOnAmount = TextEditingController();

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
                      textInput(_addOnDescription, 'Add Description', null, '',
                          1, TextInputType.multiline, true),
                      const SizedBox(
                        height: 15,
                      ),
                    ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
