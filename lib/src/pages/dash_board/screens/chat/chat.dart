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
        toolbarHeight: 3,
        elevation: 0,
        backgroundColor: Colors.grey[300],
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://images.pexels.com/photos/301367/pexels-photo-301367.jpeg?auto=compress&cs=tinysrgb&w=400'),
                          fit: BoxFit.fill)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    const Text(
                      'Clinton Paul',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'Brand Name:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Paulo Cosmetics')
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                searchField(_searchController, 'Search', null, '', 1,
                    TextInputType.text, false)
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
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
              )
            ],
          ),
        ],
      )),
    );
  }
}
