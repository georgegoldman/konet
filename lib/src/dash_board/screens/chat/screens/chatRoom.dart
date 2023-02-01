import 'dart:math';

import 'package:curnect/src/models/chatMessageModel.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String clientName;
  final String clientImage;
  const ChatRoom(
      {super.key, required this.clientName, required this.clientImage});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _messages = TextEditingController();
  List<ChatMessage> _chatHisitory = [];
  GlobalKey key = GlobalKey();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.clientImage),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Kriss Benwat",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: ListView.builder(
                itemCount: _chatHisitory.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Align(
                      alignment: (_chatHisitory[index].messageType == "receiver"
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                (_chatHisitory[index].messageType == "receiver"
                                    ? Colors.grey.shade200
                                    : const Color.fromARGB(75, 230, 179, 37))),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _chatHisitory[index].messageContent,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _chatHisitory.add(ChatMessage(
                              messageContent: _messages.text.toString(),
                              messageType: 'receiver'));
                          _messages.text = "";
                        });
                        Scrollable.ensureVisible(key.currentContext!,
                            duration: Duration(seconds: 1));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messages,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _chatHisitory.add(ChatMessage(
                            messageContent: _messages.text.toString(),
                            messageType: 'sender'));

                        _messages.text = '';
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
