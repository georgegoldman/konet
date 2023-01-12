import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String clientName;
  const ChatRoom({super.key, required this.clientName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Padding(
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
          Text(
            widget.clientName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.grey[300],
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[300],
            )
          ]),
    );
  }
}
