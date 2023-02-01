import 'package:flutter/material.dart';

import '../../utils/common_widgets/appbar.dart';
import '../../utils/common_widgets/emptyLoader.dart';
import '../../utils/common_widgets/formFields/formFields.dart';
import '../../utils/common_widgets/loading_gif.dart';
import '../../utils/common_widgets/unauthenticatedPageHeader.dart';
import '../services/validate_address.dart';

class ValidateAddress extends StatefulWidget {
  final Map<String, String> addresses;
  const ValidateAddress({super.key, required this.addresses});

  @override
  State<ValidateAddress> createState() => _ValidateAddressState();
}

class _ValidateAddressState extends State<ValidateAddress>
    with FormInputFields {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetOneController = TextEditingController();
  final TextEditingController _streetTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateMarkController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  Future<void>? _validateAddress;
  bool success = false;
  ValidateAddressService? _validateAddressService;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(
                context: context,
                screeenInfo:
                    "With our postal address verification and cleansing service you can easily verify if an address exists and is deliverable. Whether you want to clean up the addresses in your customer database or verify addresses directly on your website, we have exactly the right solution for you.")
            .preferredSize(),
        body: validateAddressForm(),
        persistentFooterButtons: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    setState(() {
                      _streetOneController.text = '';
                      _streetTwoController.text = '';
                      _zipController.text = '';
                      _cityController.text = '';
                      _stateMarkController.text = '';
                      _countryController.text = '';
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.redAccent),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // var validatingAddressFromMap =
                      //     await validateAddressRequest();
                      // debugPrint('the truth');
                      // debugPrint(validatingAddressFromMap.toString());
                      setState(() {
                        _validateAddress =
                            _validateAddressService?.verifyAddresss({
                          'address':
                              "${_streetOneController.text.toString()} ${_zipController.text.toString()} ${_cityController.text.toString()} ${_stateMarkController.text.toString()} ${_countryController.text}"
                        });
                      });
                      _validateAddress;
                    } else {
                      null;
                    }
                  },
                  child: const Text(
                    'Continue',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      FutureBuilder(
        future: _validateAddress,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // ignore: todo
              // TODO: Handle this case.
              return const EmptyLoader();
            case ConnectionState.waiting:
              // ignore: todo
              // TODO: Handle this case.
              return const LoadingPageGif();
            case ConnectionState.active:
              // ignore: todo
              // TODO: Handle this case.
              return const Text("Is Active");
            case ConnectionState.done:
              // ignore: todo
              // TODO: Handle this case.
              return const EmptyLoader();
          }
        },
      )
    ]);
  }

  @override
  void initState() {
    _validateAddressService = ValidateAddressService(context: context);
    _streetOneController.text = widget.addresses['street-adress'] ?? '';
    _streetTwoController.text = widget.addresses['region'] ?? '';
    _zipController.text = widget.addresses['postal-code'] ?? '';
    _cityController.text = widget.addresses['locality'] ?? '';
    _stateMarkController.text = widget.addresses['locality'] ?? '';
    _countryController.text = widget.addresses['country-name'] ?? '';
    super.initState();
  }

  Widget validateAddressForm() {
    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.1,
          child: const UnauthenticatedPageheader(
            subTitle: 'Where can your clients find you?',
            title: 'Validate your address',
          ),
        ),
        Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return textInput(
                              _streetOneController,
                              'Street Address Line 1',
                              null,
                              'Street Address Line 1',
                              1,
                              TextInputType.streetAddress,
                              true);
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return textInput(
                              _streetTwoController,
                              'Street Address Line 2',
                              null,
                              'Street Address Line 2',
                              1,
                              TextInputType.streetAddress,
                              false);
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return textInput(
                              _zipController,
                              'Zip code',
                              null,
                              'Zip code',
                              1,
                              TextInputType.streetAddress,
                              false);
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return textInput(_cityController, 'City', null,
                              'City', 1, TextInputType.streetAddress, false);
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.03),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return textInput(_stateMarkController, 'State', null,
                              'State', 1, TextInputType.streetAddress, true);
                        })),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height * 0.0,
                            0,
                            MediaQuery.of(context).size.height * 0.01),
                        child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return textInput(_countryController, 'Country', null,
                              'Country', 1, TextInputType.streetAddress, true);
                        })),
                  ],
                )),
            Text(
              errorMessage.toString(),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
        )
      ],
    ));
  }
}
