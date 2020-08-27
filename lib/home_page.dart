import 'package:flutter/material.dart';
import 'package:flutterandroid/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  String _resetPasswordEmail = "";
  String _errorMessage;
  bool _isIos;
  _HomePageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  Query _todoQuery;
  bool _isEmailVerified = false;
  @override
  void initState() {
    super.initState();
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget _showButtonList() {
    return new Container(
      padding: EdgeInsets.all(26.0),
      child: new ListView(
        children: <Widget>[
          _showChangeEmailContainer(),
          new SizedBox(
            height: 40.0,
          ),
          _showChangePasswordContainer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter login demo'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      body: _showButtonList(),
    );
  }

  _showChangeEmailContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(30.0),
        color: Colors.amberAccent,
      ),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          new TextFormField(
            controller: _emailFilter,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter New Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
          new MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
// widget.auth.changeEmail("abc@gmail.com
              _changeEmail();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text(
              "Change Email",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _changeEmail() {
    if (_email != null && _email.isNotEmpty) {
      try {
        print("============>" + _email);
        widget.auth.changeEmail(_email);
      } catch (e) {
        print("============>" + e);
        setState(() {
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      print("email feild empty");
    }
  }

//Cambio de password
  void _changePassword() {
    if (_password != null && _password.isNotEmpty) {
      print("============>" + _password);
      widget.auth.changePassword(_password);
    } else {
      print("password feild empty");
    }
  }

  _showChangePasswordContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: Colors.brown),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          new TextFormField(
            controller: _passwordFilter,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter New Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
          new MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              _changePassword();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text(
              "Change Password",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
