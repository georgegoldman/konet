import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hair die with cut'),
                ElevatedButton(
                  onPressed: () => print('you hit the elevated btn'),
                  child: Text('Hair cut'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NGN 3,000'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => print('share'),
                          icon: Icon(Icons.share),
                        ),
                        IconButton(
                          onPressed: () => print('Edit'),
                          icon: Icon(Icons.edit_note_rounded),
                        ),
                        IconButton(
                          onPressed: () => print('trash'),
                          icon: Icon(Icons.delete_outline_outlined),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
