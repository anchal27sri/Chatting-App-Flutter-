import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatting_app/pages/home.dart';
import 'package:chatting_app/services/signup.dart';
import 'package:chatting_app/models/loading.dart';
import 'package:chatting_app/models/user.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false; // bool variable for showing the loading screen
  String error;
  String _email, _password;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>(); // form key for Form widget that wraps the List of TextFormField
  final databaseReference = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loading = false;
    error = "";
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading() // loading = true => show loading page, otherwise show scaffold
        : SafeArea( // safe area for preventing cut off screens
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Form( // by wrapping in a form widget, we can validate all the TextFormFields at once before editing database
                key: _formkey,
                child: ListView( // to make it scrollable
                  children: <Widget>[
                    SizedBox( // sized boxes are used to separate elements
                      height: 30,
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 40.0),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'please type your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email', 
                            border: OutlineInputBorder(
                                )),
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
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            )),
                        obscureText: true,
                        onSaved: (input) => (_password = input),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 140, vertical: 8),
                      child: RaisedButton(
                        onPressed: () {
                          signIn();
                        },
                        child: Text(
                          'Sign In',
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
                      child: Container(child: Text('Do not have an account?')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 250, 0),
                      child: GestureDetector(
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> signIn() async {
    final formstate = _formkey.currentState; // saving the current state of the form in a new variable

    if (formstate.validate()) {
      formstate.save();
      setState(() {
        loading = true; // show loading screen while doing sign in
      });
      try {
        FirebaseUser fuser = (await _auth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        dynamic user = await fetchUserData(fuser).then((value) {
          return value;
        }, onError: (er) {
          print(er);
        });
        error = "";
        setState(() {
          loading = false;
        });
        // replace the page with the Home page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      user: user,
                      auth: _auth,
                    )));
      } catch (e) {
        error = e.toString();
        setState(() {
          loading = false; // close loading screen after signed in and Home Page is loaded
        });
      }
    }
  }

  Future<User> fetchUserData(FirebaseUser fuser) async {
    User user;
    await databaseReference
        .collection("users")
        .document(fuser.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      // each snapshot is contains a data that is a map of the field and information
      Map<String, dynamic> mp = snapshot.data;
      user = User(
        username: mp['username'],
        email: _email,
        uid: fuser.uid,
        color: mp['color'],
      );
    });
    return user;
  }
}
