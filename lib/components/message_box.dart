import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  String text;
  String sender;
  bool isMe;
  MessageBox({required this.text, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 12.0),
          ),
          Material(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                text,
                style: const TextStyle(color: Colors.black54, fontSize: 15.0),
              ),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlue : Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ],
      ),
    );
  }
}
