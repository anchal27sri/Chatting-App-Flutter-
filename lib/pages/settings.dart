import 'package:chatting_app/services/signin.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatting_app/models/colorsmap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  final User user; 
  final FirebaseAuth auth;
  final Function fn;
  Settings({this.user, this.auth, this.fn});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorMap().choiceColorMap[widget.user.color]['dark'],
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircleAvatar(
                backgroundColor: ColorMap().choiceColorMap[widget.user.color]
                    ['normal'],
                radius: 60,
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          ListTile(
            title: Text('Username'),
            subtitle: Text(widget.user.username),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                createAlertDialogForEditing(
                        context, 'Username', widget.user.username)
                    .then((value) async {
                  if (value != null) {
                    widget.user.username = value;
                    setState(() {});
                    await databaseReference
                        .collection('users')
                        .document(widget.user.uid)
                        .updateData({'username': value});
                    await databaseReference
                        .collection('users')
                        .document(widget.user.uid)
                        .updateData({'searchKey': value[0][0]});    
                    widget.fn(() {});
                  }
                });
              },
            ),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(widget.user.email),
            trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
              createAlertDialogForEditing(
                        context, 'Email', widget.user.email)
                    .then((value) async {
                  if (value != null) {
                    widget.user.email = value;
                    await databaseReference
                        .collection('users')
                        .document(widget.user.uid)
                        .updateData({'email': value});
                    widget.fn(() {});
                    setState(() {});
                  }
                });
            },),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Color'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: ('Blue' != widget.user.color)
                        ? null
                        : BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                    child: FloatingActionButton(
                      heroTag: null,
                      shape: CircleBorder(),
                      elevation: 0,
                      backgroundColor: ColorMap().choiceColorMap['Blue']
                          ['normal'],
                      onPressed: () {
                        setState(() {
                          widget.user.color = 'Blue';
                        });
                        databaseReference
                            .collection('users')
                            .document(widget.user.uid)
                            .updateData({'color': 'Blue'});
                        widget.fn(() {});
                      },
                    ),
                  ),
                  Container(
                    decoration: ('Red' != widget.user.color)
                        ? null
                        : BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    30.0)
                                ),
                          ),
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: ColorMap().choiceColorMap['Red']
                          ['normal'],
                      onPressed: () {
                        setState(() {
                          widget.user.color = 'Red';
                        });
                        databaseReference
                            .collection('users')
                            .document(widget.user.uid)
                            .updateData({'color': 'Red'});
                        widget.fn(() {});
                      },
                    ),
                  ),
                  Container(
                    decoration: ('Green' != widget.user.color)
                        ? null
                        : BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    30.0)
                                ),
                          ),
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: ColorMap().choiceColorMap['Green']
                          ['normal'],
                      onPressed: () {
                        setState(() {
                          widget.user.color = 'Green';
                        });
                        databaseReference
                            .collection('users')
                            .document(widget.user.uid)
                            .updateData({'color': 'Green'});
                        widget.fn(() {});
                      },
                    ),
                  ),
                  Container(
                    decoration: ('Yellow' != widget.user.color)
                        ? null
                        : BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    30.0)
                                ),
                          ),
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: ColorMap().choiceColorMap['Yellow']
                          ['normal'],
                      onPressed: () {
                        setState(() {
                          widget.user.color = 'Yellow';
                        });
                        databaseReference
                            .collection('users')
                            .document(widget.user.uid)
                            .updateData({'color': 'Yellow'});
                        widget.fn(() {});
                      },
                    ),
                  ),
                  Container(
                    decoration: ('Dark' != widget.user.color)
                        ? null
                        : BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    30.0)
                                ),
                          ),
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: ColorMap().choiceColorMap['Dark']
                          ['normal'],
                      onPressed: () {
                        setState(() {
                          widget.user.color = 'Dark';
                        });
                        databaseReference
                            .collection('users')
                            .document(widget.user.uid)
                            .updateData({'color': 'Dark'});
                        widget.fn(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          Center(
            child: RaisedButton(
              onPressed: () async {
                await signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    try {
      return await widget.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> createAlertDialogForEditing(
      context, String title, String content) {
    TextEditingController textController = TextEditingController(text: content);
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              margin: EdgeInsets.only(left: 26.0, right: 26.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Edit $title',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: textController,
                      decoration: InputDecoration(labelText: title),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter The $title';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                            // height: 20,
                            child: Text('Done'),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                Navigator.of(context).pop(
                                  textController.text.toString(),
                                );
                              }
                            }),
                        MaterialButton(
                            // height: 20,
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
