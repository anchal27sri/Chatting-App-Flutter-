import 'package:chatting_app/chatlist.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
// import 'package:quiver/time.dart';

class ChatRoom extends StatefulWidget {
  final User user1;
  final User user2;
  const ChatRoom({
    Key key,
    @required this.user1,
    @required this.user2,
  }) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String roomId;
  String _messageInput;
  final databaseReference = Firestore.instance;
  TextEditingController tec = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    roomId = widget.user1.uid + widget.user2.uid;
    if (widget.user1.uid.compareTo(widget.user2.uid) > 0) {
      roomId = widget.user2.uid + widget.user1.uid;
    }
    // print('room id: $roomId');
    // ThemeData.primaryColor = Colors.blue;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          title: Text('${widget.user2.username}'),
          backgroundColor: Colors.blue[900],
          elevation: 50,
          // automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Flexible(
                    child: ChatListWidget(
                  roomId: roomId,
                  curUser: widget.user1,
                  chatWithUser: widget.user2,
                )),
                Divider(
                  color: Colors.white,
                ),
                Container(
                  color: Colors.grey[900],
                  child: Row(
                    children: <Widget>[
                      Form(
                        key: _formkey,
                        child: Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: tec,
                              style: TextStyle(color: Colors.white),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'message empty';
                                }
                                return null;
                              },
                              onSaved: (input) => (_messageInput = input),
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 30,
                        color: Colors.green,
                        onPressed: () async {
                          setState(() {
                            sendMessage();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    print('sending..');
    final formstate = _formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      try {
        print(_messageInput);
        tec.clear();
        await databaseReference
            .collection('chatrooms')
            .document(roomId)
            .collection(roomId)
            .document(randomAlphaNumeric(20))
            .setData({
          'message': _messageInput,
          'time': DateTime.now().toUtc(),
          'uid': widget.user1.uid,
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
