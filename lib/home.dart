import 'package:chatting_app/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final User user;
  final FirebaseAuth auth;
  const Home({Key key, @required this.user, @required this.auth})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  final databaseReference = Firestore.instance;
  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.username}'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              await signOut(widget.auth);
              setState(() {
                loading = false;
              });
              print('popping');
              Navigator.pop(context);
            },
            icon: Icon(Icons.person),
            label: Text('Logout'),
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
          future: getAllUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 3, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final item = snapshot.data[index];
                    return ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('${item.username}'),
                      trailing: FlatButton(
                        textColor: Colors.white,
                        disabledColor: Colors.blue[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue[900])),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        user1: widget.user,
                                        user2: item,
                                      )));
                        },
                        child: Text('Chat'),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     getAllUsers();
      //   },
      // ),
    );
  }

  Future<void> signOut(FirebaseAuth auth) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email','email');
      prefs.setString('password','password');
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<User>> getAllUsers() async {
    // User user;
    final QuerySnapshot result =
        await Firestore.instance.collection('users').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    List<User> l = List<User>();
    documents.forEach((data) {
      Map<String, dynamic> mp = data.data;
      print(mp['uid']);
      print(widget.user.uid);
      if (mp['uid'] != widget.user.uid) {
        l.add(User(
          uid: mp['uid'],
          username: mp['username'],
          email: mp['email'],
        ));
      }
    });
    return l;
  }
}
