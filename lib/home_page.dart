import 'package:flutter/material.dart';
import 'package:flutterandroid/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
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

//verifica si esta logeado o no el usuario
  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: Text("Verifica tu acceso"),
          content: Text("Se envio verificacion para validar Email"),
          actions: <Widget>[
            FlatButton(
              child: Text("Descartar"),
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
    return Container(
      padding: EdgeInsets.all(26.0),
      child: ListView(
        children: <Widget>[
          //cambio de Email
          _showChangeEmailContainer(),
          SizedBox(
            height: 20.0,
          ),
          //Card de Cambio de Passpord
          _showChangePasswordContainer(),
          SizedBox(
            height: 40.0,
          ),

          ///lista elementos
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login'),
        actions: <Widget>[
          FlatButton(
              child: Text('Salir',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut),
        ],
      ),

      //lista de elemendos en la clase showButoonlst
      body: _showButtonList(),
    );
  }

  _showChangeEmailContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.amberAccent[200],
      ),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailFilter,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Ingresa nuevo Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              _changeEmail();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text(
              "Cambiar Email",
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
      print("Error al Ingresar Email");
    }
  }

//Cambio de password
  void _changePassword() {
    if (_password != null && _password.isNotEmpty) {
      print("============>" + _password);
      widget.auth.changePassword(_password);
    } else {
      print("Error al ingresar Password");
    }
  }

  _showChangePasswordContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: Colors.brown[400]),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _passwordFilter,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Nuevo Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              _changePassword();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent[400],
            textColor: Colors.white,
            child: Text(
              "Cambiar  Password",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
