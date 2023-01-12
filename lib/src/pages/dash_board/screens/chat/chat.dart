import 'package:curnect/src/common_widgets/formFields/formFields.dart';
import 'package:flutter/material.dart';

class ChatBaseClass extends StatefulWidget {
  const ChatBaseClass({super.key});

  @override
  State<ChatBaseClass> createState() => _ChatBaseClassState();
}

class _ChatBaseClassState extends State<ChatBaseClass> with FormInputFields {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> chatHistory = [
    {
      "image":
          "https://images.pexels.com/photos/6109504/pexels-photo-6109504.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "image":
          "https://images.pexels.com/photos/6109280/pexels-photo-6109280.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "image":
          "https://images.pexels.com/photos/6109280/pexels-photo-6109280.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "image":
          "https://images.pexels.com/photos/7561910/pexels-photo-7561910.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "image":
          "https://images.pexels.com/photos/9409753/pexels-photo-9409753.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "image":
          "https://images.pexels.com/photos/10415856/pexels-photo-10415856.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "image":
          "https://images.pexels.com/photos/10083753/pexels-photo-10083753.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "image":
          "https://images.pexels.com/photos/6599705/pexels-photo-6599705.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "image":
          "https://images.pexels.com/photos/11696003/pexels-photo-11696003.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "image":
          "https://images.pexels.com/photos/14965546/pexels-photo-14965546.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
  ];
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () => print('loading contacts...'),
              ),
            ),
          )
        ],
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.grey[300],
      ),
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 0),
          itemCount: chatHistory.length,
          prototypeItem: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 60,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                          image: NetworkImage(chatHistory.first['image']!),
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
              const Divider(),
            ],
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(chatHistory[index]['image']!),
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
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
