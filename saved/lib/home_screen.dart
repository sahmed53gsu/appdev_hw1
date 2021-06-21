import 'package:flutter/material.dart';

import 'auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ButtonTheme(
            height: 50,
            disabledColor: Colors.blueAccent,
            child: ElevatedButton(
              onPressed: () {
                AuthService().signOut();
              },
              child: Text('Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
