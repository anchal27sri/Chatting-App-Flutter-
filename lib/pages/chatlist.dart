import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'package:chatting_app/models/colorsmap.dart';

class ChatListWidget extends StatelessWidget {
  final String roomId;
  final User curUser;
  final User chatWithUser;
  ChatListWidget({this.roomId, this.curUser, this.chatWithUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chatrooms')
          .document(roomId)
          .collection(roomId)
          .orderBy('time', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemBuilder: (context, index) =>
                buildItem(index, snapshot.data.documents[index].data),
            itemCount: snapshot.data.documents.length,
            reverse: true,
          );
        }
      },
    );
  }

  ListTile buildItem(int index, Map<String, dynamic> mp) {
    DateTime dateTime = mp['time'].toDate();
    String time = '${dateTime.hour}:${dateTime.minute}';
    return ListTile(
      title: Wrap(
          alignment: (mp['uid'] == curUser.uid)
              ? WrapAlignment.end
              : WrapAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: (mp['uid'] == curUser.uid)
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0))
                        : BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0)),
                    color: (mp['uid'] == curUser.uid)
                        ? ColorMap().choiceColorMap[curUser.color]['dark']
                        : ColorMap().choiceColorMap[chatWithUser.color]
                            ['normal'],
                  ),
                  child: Column(
                    crossAxisAlignment: (mp['uid'] == curUser.uid)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      (mp['uid'] == curUser.uid)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 8.0),
                              child: Text(
                                curUser.username,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 8.0),
                              child: Text(
                                chatWithUser.username,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          mp['message'],
                          // textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          time,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
