import 'package:curnect/src/common_widgets/formFields/formFields.dart';
import 'package:flutter/material.dart';

class ChatBaseClass extends StatefulWidget {
  const ChatBaseClass({super.key});

  @override
  State<ChatBaseClass> createState() => _ChatBaseClassState();
}

class _ChatBaseClassState extends State<ChatBaseClass> with FormInputFields {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(7),
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://images.pexels.com/photos/301367/pexels-photo-301367.jpeg?auto=compress&cs=tinysrgb&w=400'),
                    fit: BoxFit.fill)),
          ),
        ),
        title: const Text(
          'chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => print('loading contacts...'),
            ),
          )
        ],
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.grey[300],
      ),
      body: SafeArea(
          child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 60,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(7),
                      image: const DecorationImage(
                          image: NetworkImage(
                              'https://images.pexels.com/photos/301367/pexels-photo-301367.jpeg?auto=compress&cs=tinysrgb&w=400'),
                          fit: BoxFit.fill)),
                ),
                title: const Text(
                  'Chiwendu Michael',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Am coming over for home'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Text('16:45'),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.circle,
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
                onTap: () => print('hi'),
              ),
              Divider(),
            ],
          );
        },
      )),
    );
  }
}
