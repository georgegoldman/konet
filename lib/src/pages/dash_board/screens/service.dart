import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          elevation: 4,
          bottom: TabBar(
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xFFE6B325)),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.edit_off,
                          size: 15,
                        ),
                        label: const Text('service')),
                  ),
                  // icon: Icon(Icons.edit_off),
                  // text: 'service',
                ),
                Tab(
                    child: TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.layers_outlined, size: 15),
                  label: const Text('Bundle'),
                )),
                Tab(
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(
                      Icons.add_to_photos_rounded,
                      size: 15,
                    ),
                    label: const Text('addons'),
                  ),
                ),
              ]),
        ),
        body: const TabBarView(children: [
          Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
        ]),
      ),
    );
  }
}
