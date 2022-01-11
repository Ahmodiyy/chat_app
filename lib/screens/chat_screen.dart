import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/components/message_box.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _cloudStore = FirebaseFirestore.instance;
  late String message;

  User? user;
  void getUser() {
    user = _auth.currentUser;
    try {
      if (user != null) {
        print('user ${user!.email}');
      }
    } catch (e) {
      print('user $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: chatMessageUi(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.

                      textController.clear();
                      _cloudStore.collection('messages').add({
                        'sender': user!.email,
                        'text': message,
                        'timestamp': FieldValue.serverTimestamp()
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> chatMessageUi() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _cloudStore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }

        Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
            snapShot.data!.docs;

        List<MessageBox> listMessageBox = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in documents) {
          MessageBox messageBok = MessageBox(
            text: '${document['text']}',
            sender: '${document['sender']}',
            isMe: document['sender'] == user!.email,
          );
          listMessageBox.add(messageBok);

          // realData.forEach((key, value) {
          //   MessageBox messageBok = MessageBox(
          //     text: '$key key',
          //     sender: '${value.toString()}  value',
          //   );
          //   listMessageBox.add(messageBok);
          // });
        }
        return ListView(
          reverse: true,
          children: listMessageBox,
        );
      },
    );
  }
}
