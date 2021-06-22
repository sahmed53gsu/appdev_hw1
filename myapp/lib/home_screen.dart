import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(title: Text("Saadh's Messages")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          SizedBox(
            height: 100,
          ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((document) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.width / 6,
                        child: Column(
                          children: [
                            Text('Message: ' + document['message'].toString()),
                            Text('Date: ' +
                                document['dtime'].toDate().toString()),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}
