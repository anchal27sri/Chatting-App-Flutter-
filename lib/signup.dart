import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'loading.dart';
import 'user.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email, _password;
  String _username;
  bool loading = false;
  String error = "";
  final databaseReference = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loading = false;
    error = "";
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: _formkey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        'Register',
                        style: TextStyle(fontSize: 40.0),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email', border: OutlineInputBorder()),
                        onSaved: (input) => (_email = input),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.length < 6) {
                            return 'length of password should be greater than 5';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                        obscureText: true,
                        onSaved: (input) => (_password = input),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'please enter your username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name', border: OutlineInputBorder()),
                        onSaved: (input) => (_username = input),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 130, vertical: 8),
                      child: RaisedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                      child: Container(child: Text('Already have an account?')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 250, 0),
                      child: GestureDetector(
                        child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> signUp() async {
    final formstate = _formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      setState(() {
        loading = true;
      });
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _email);
        prefs.setString('password', _password);
        FirebaseUser fuser = (await _auth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        dynamic user = await registerUser(fuser).then((value) {
          return value;
        }, onError: (er) {
          print(er);
        });
        setState(() {
          loading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      user: user,
                      auth: _auth,
                    )));
        print(user.email);
      } catch (e) {
        print(e.message);
        print("here");
      }
    }
  }

  Future<User> registerUser(FirebaseUser fuser) async {
    await databaseReference.collection("users").document(fuser.uid).setData({
      'username': _username,
      'uid': fuser.uid,
      'email': fuser.email,
    });
    return User(username: _username, uid: fuser.uid, email: fuser.email);
  }
}