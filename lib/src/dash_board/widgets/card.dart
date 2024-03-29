import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceCard extends StatelessWidget {
  final String navigationEndPoint;
  const ServiceCard({super.key, required this.navigationEndPoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Card(
            elevation: 14,
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hair die with cut',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => print('you hit the elevated btn'),
                    child: const Text('Hair cut'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
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
                            icon: const Icon(Icons.edit_note_rounded),
                          ),
                          IconButton(
                            onPressed: () => print('trash'),
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.redAccent,
                            ),
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
      ),
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black,
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => context.push('/$navigationEndPoint'),
        ),
      ),
    );
  }
}
