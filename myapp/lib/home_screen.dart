import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
          ButtonTheme(
            height: 50,
            disabledColor: Colors.blueAccent,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isProcessing = true;
                });
                await signOutGoogle().then((result) {
                  print(result);
                  //Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => LoginPage(),
                    ),
                  );
                }).catchError((error) {
                  print('Signout Error: $error');
                });
                setState(() {
                  _isProcessing = false;
                });
              },
              child: Text('Sign out from Google',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
