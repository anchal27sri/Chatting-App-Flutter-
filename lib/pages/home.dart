import 'package:chatting_app/pages/chatroom.dart';
import 'package:chatting_app/pages/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'searchpage.dart';

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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Your Friends'),
        backgroundColor: Colors.blue[900],
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
      body: StreamBuilder<List<User>>(
          stream: getAllUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 3, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final item = snapshot.data[index];
                    return Container(
                      color: Colors.blue,
                      child: ListTile(
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
                            print(widget.user.color);
                            print(item.color);
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
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPage(
                        user: widget.user,
                        fn: setState,
                      )));
        },
      ),
    );
  }

  Future<void> signOut(FirebaseAuth auth) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', 'email');
      prefs.setString('password', 'password');
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<User>> getAllUsers() async* {
    DocumentSnapshot docRef = await Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .get();
    print(docRef['email']);
    List<String> uids = List.from(docRef['friends']);
    print('number of friends: ${uids.length}');
    List<User> ll = List<User>();
    for (int i = 0; i < uids.length; i++) {
      print('this is it: ${uids[i]}');
      DocumentSnapshot tempDocRef =
          await Firestore.instance.collection('users').document(uids[i]).get();
      print(tempDocRef['username']);
      ll.add(User(
          color: tempDocRef['color'],
          uid: tempDocRef['uid'],
          username: tempDocRef['username'],
          email: tempDocRef['email']));
      print(ll.length);
    }
    print(ll.length);
    yield ll;
    // setState(() {
    // });
  }
}
