import 'package:flutter/material.dart';

import '../common_widgets/appbar.dart';

String title = '';

class Hurray extends StatelessWidget {
  const Hurray({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnauthenticatedAppBar(context: context, screeenInfo: title)
          .preferredSize(),
      body: Stack(children: [
        SafeArea(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: <Widget>[
            const SizedBox(
              height: 30.0,
            ),
            Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Text('Hurray!!!\nThe time to Curnect\nis now.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.height * 0.03,
                      0,
                      MediaQuery.of(context).size.height * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.004),
                        child: const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Malesuada massa habitant a rhoncus felis, risus tincidunt nisl. Nunc odio imperdiet mauris sapien elit convallis lectus dui quis.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Malesuada massa habitant a rhoncus felis, risus tincidunt nisl.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        )),
      ]),
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
            onPressed: () => debugPrint("moivng on"),
            child: const Text(
              'Explore',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
