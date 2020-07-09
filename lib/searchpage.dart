import 'package:flutter/material.dart';
import 'package:chatting_app/searchservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class SearchPage extends StatefulWidget {
  final User user;
  final Function fn;
  SearchPage({this.user, this.fn});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final databaseReference = Firestore.instance;
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        print(docs.documents.length);
        for (int i = 0; i < docs.documents.length; ++i) {
          // print(docs.documents[i].data);
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
      // setState(() {});
    } else {
      tempSearchStore = [];

      queryResultSet.forEach((element) {
        // print(element['username']);
        if (element['username'].startsWith(value)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Friends'),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (val) {
              initiateSearch(val);
            },
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by username',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0))),
          ),
        ),
        SizedBox(height: 10.0),
        ListView(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            shrinkWrap: true,
            children: tempSearchStore.map((element) {
              // print(element);
              return buildResultCard(element);
            }).toList())
      ]),
    );
  }

  Widget buildResultCard(dynamic data) {
    // print(data['username']);
    // print(data['uid']);
    List<dynamic> l = List<dynamic>();
    l.add(data['uid']);
    return ListTile(
      title: Text(
        data['username'],
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.add_circle),
        onPressed: () async {
          print(data['uid']);
          print(widget.user.uid);
          databaseReference
              .collection('users')
              .document(widget.user.uid)
              .updateData({'friends': FieldValue.arrayUnion(l)});
          widget.fn(() {});
          Navigator.pop(context);
        },
      ),
    );
  }
}