import 'package:example/event_load.dart';
import 'package:example/login.dart';
import 'package:example/notifications.dart';
import 'package:example/qr.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:cynergy_app_backend/cynergy_app_backend.dart';


void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cynergy App Backend Example"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Event load example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventLoadExample()
                        )
                      );
                    },
                  ),
                  SizedBox(height: 30,),

                  RaisedButton(
                    child: Text("Login example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginExample()
                        )
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  
                  RaisedButton(
                    child: Text("Notifications example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationsExample()
                        )
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  
                  RaisedButton(
                    child: Text("QR example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QrExample()
                        )
                      );
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}