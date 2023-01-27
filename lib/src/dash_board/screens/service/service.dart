import 'package:curnect/src/dash_board/widgets/card.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/appBar/dashboardAppbar.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> with ApplicationBar {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: dashboardAppbar(),
        body: Scaffold(
          // ,
          appBar: AppBar(
            backgroundColor: Colors.black12,
            bottom: PreferredSize(
              preferredSize:
                  Size(50, MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.01),
                width: MediaQuery.of(context).size.width * 1,
                child: TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFE6B325)),
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 3,
                    ),
                    tabs: [
                      Container(
                        alignment: Alignment.center,
                        // height: MediaQuery.of(context).size.height * 0.07,
                        child: Tab(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.edit_off),
                                Text('service'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Tab(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check_box_outline_blank_rounded),
                                Text('bundle'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Tab(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.add),
                                Text('addons'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            elevation: 0,
          ),
          body: TabBarView(children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01),
              child: const ServiceCard(
                navigationEndPoint: 'dashboardaddservice',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01),
              child: const ServiceCard(
                navigationEndPoint: 'dashboardaddbunle',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01),
              child: const ServiceCard(
                navigationEndPoint: 'dashboardaddaddons',
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
