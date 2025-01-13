import 'package:chatapp/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatroomScreen extends StatefulWidget {
  ChatroomScreen(
      {super.key, required this.chatroomName, required this.chatroomId});
  String chatroomName;
  String chatroomId;

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  TextEditingController messageText = TextEditingController();
  var db = FirebaseFirestore.instance;

  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) {
      return;
    }
    Map<String, dynamic> messageToSend = {
      "text": messageText.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "chatroom_id": widget.chatroomId,
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
      "timestamp": FieldValue.serverTimestamp(),
    };
    messageText.text = "";
    try {
      await db.collection("messages").add(messageToSend);
    } catch (e) {
      // ignore: avoid_print
      print("message not sent: $e");
    }
  }

  Widget singleChatItem(
      {required String sender_name,
      required String text,
      required String senderId}) {
    return Column(
      crossAxisAlignment:
          senderId == Provider.of<UserProvider>(context, listen: false).userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Text(
            sender_name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: senderId ==
                        Provider.of<UserProvider>(context, listen: false).userId
                    ? Colors.green[800]
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: db
                      .collection("messages")
                      .where("chatroom_id", isEqualTo: widget.chatroomId)
                      .limit(100)
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // ignore: avoid_print
                      print(snapshot.error);
                      return const Text("Some Error has occured");
                    }
                    var allMessages = snapshot.data?.docs ?? [];

                    // ignore: prefer_is_empty
                    if (allMessages.length < 1) {
                      return const Center(
                        child: Text("No Messages ... "),
                      );
                    }
                    return ListView.builder(
                        reverse: true,
                        itemCount: allMessages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: singleChatItem(
                                  senderId: allMessages[index]["sender_id"],
                                  sender_name: allMessages[index]
                                      ["sender_name"],
                                  text: allMessages[index]["text"]));
                        });
                  })),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageText,
                        decoration: const InputDecoration(
                            hintText: "Write your message here ...",
                            border: InputBorder.none),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(onTap: sendMessage, child: const Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
