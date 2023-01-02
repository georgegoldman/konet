import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/src/services/user.dart';
import 'package:curnect/src/state_manager/add_service_manipulator.dart';
import 'package:curnect/src/widgets/emptyLoader.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

import '../../style/animation/loading_gif.dart';
import '../../widgets/appbar.dart';
import '../../widgets/unauthenticatedPageHeader.dart';
import 'fetch_g_address.dart';
import 'howToLocateYou.dart';

String title =
    'You can use the Select Categories page to select the categories to which to assign the software instance. You can select multiple categories. If your installation is using categories to control access to software instances and deployments and requires that all objects be assigned to a category, at least one category is required. Otherwise, assigning a software instance to a category is optional. The Categories table lists the categories that are defined in z/OSMF. For a description of the columns or actions, see Columns in the Categories table or Actions for categories. To define a new category, complete the steps provided in help topic Defining new categories. For more information about categories, see help topic Organizing your software and deployments.';

class Category {
  final int? id;
  final String? name;

  Category({this.id, this.name});
}

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final _formKey = GlobalKey<FormState>();
  List<String> _selected = [];
  Future<Map<String, dynamic>>? _selectCategory;
  User user = User(email: '', password: '');
  int? successful;
  Map<String, int> categoryMap = {
    "Dietician": 1,
    "Makeup Artist": 2,
    "Barber": 3,
    "Hair Salon": 4,
    "Skin Care": 5,
    "Day SPA": 6,
    "Home Service": 7,
    "Dental": 8,
    "Pet Service": 9,
    "Panel Beater": 10,
    "Plumber": 11,
    "Health and Wellness": 12,
    "Physiotherapist": 13,
    "Electrician": 14,
    "Generator Repairer": 15,
    "Piercing": 16,
    "Waxing": 17,
    "Tattoo": 18,
    "Nail Salon": 19,
    "Catering Service": 20,
    "Event Decorator": 21,
    "Home Interior Decorator": 22,
    "Laundry Service": 23,
    "Fashion Designer": 24,
    "Mechanic": 25,
    "Solar Engineer": 26,
    "Bricklayer": 27,
    "Real Estate": 28,
    "Transportation Service": 29,
    "Computer Mobile and IT": 30,
    "Entertainment": 31,
    "Legal Service": 32,
    "Veterinary": 33,
    "Painter": 34,
    "Signage": 35,
    "Security Services": 36,
    "Cobbler": 37,
    "Vulcanizer": 38,
    "Rewire": 39,
    "Battery Charger": 40,
    "Tiler": 41,
    "POP Service": 42,
    "Roofers": 43,
    "Woodwork": 44,
    "Event Planner": 45
  };

  Future<Map<String, dynamic>> selectCategoryRequest() async {
    try {
      String userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id']
          .toString();
      late List<Map<String, int>> businessCategoryArray = [];
      Map<String, dynamic> body = {};
      //iterate through the list of category
      print('ok');
      for (var x in categoryMap.keys) {
        for (var element in _selected) {
          // get selectd aervices
          if (element == x) {
            // add the selected service to list
            businessCategoryArray.add({
              "business_category": categoryMap[x]!.toInt(),
              "user_id": int.parse(userId)
            });
          }
        }
      }
      body["businesscat"] = businessCategoryArray;
      if (businessCategoryArray.isNotEmpty) {
        final response = await user.patchWithJson(
            'https://curnect.com/curnect-api/public/api/registerbusinesscategory',
            body);
        return response;
      } else {
        throw Exception("empty service category");
      }
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(context: context, screeenInfo: title)
            .preferredSize(),
        body: selectCategoryWidget(),
        persistentFooterButtons: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50)),
            onPressed: () async {
              setState(() {
                _selectCategory = selectCategoryRequest();
              });
              _selectCategory!.then((value) {
                setState(() {
                  successful = value["statusCode"];
                });
              }).whenComplete(() {
                // ignore: unrelated_type_equality_checks
                if (successful == 202) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                      RouteAnimation(Screen: const HowToLocateYou())
                          .createRoute());
                }
              });
            },
            child: const Text(
              'Continue',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          )
        ],
      ),
      FutureBuilder(
        future: _selectCategory,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const EmptyLoader();
            case ConnectionState.waiting:
              debugPrint("waiting");
              return const LoadingPageGif();
            case ConnectionState.active:
              debugPrint("active");
              return const Text('active');
            case ConnectionState.done:
              return const EmptyLoader();
          }
        },
      ),
    ]);
  }

  Widget selectCategoryWidget() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          // const SizedBox(
          //   height: 50.0,
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.1,
            child: const UnauthenticatedPageheader(
              subTitle: '',
              title: 'Select your\nBusiness category',
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropDownMultiSelect(
                    options: const [
                      "Dietician",
                      "Makeup Artist",
                      "Barber",
                      "Hair Salon",
                      "Skin Care",
                      "Day SPA",
                      "Home Service",
                      "Dental",
                      "Pet Service",
                      "Panel Beater",
                      "Plumber",
                      "Health and Wellness",
                      "Physiotherapist",
                      "Electrician",
                      "Generator Repairer",
                      "Piercing",
                      "Waxing",
                      "Tattoo",
                      "Nail Salon",
                      "Catering Service",
                      "Event Decorator",
                      "Home Interior Decorator",
                      "Laundry Service",
                      "Fashion Designer",
                      "Mechanic",
                      "Solar Engineer",
                      "Bricklayer",
                      "Real Estate",
                      "Transportation Service",
                      "Computer Mobile and IT",
                      "Entertainment",
                      "Legal Service",
                      "Veterinary",
                      "Painter",
                      "Signage",
                      "Security Services",
                      "Cobbler",
                      "Vulcanizer",
                      "Rewire",
                      "Battery Charger",
                      "Tiler",
                      "POP Service",
                      "Roofers",
                      "Woodwork",
                      "Event Planner"
                    ],
                    selectedValues: _selected,
                    onChanged: (List<String> x) {
                      setState(
                        () {
                          _selected = x;
                        },
                      );
                    },
                    whenEmpty: 'Select a category',
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
