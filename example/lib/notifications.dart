import 'package:cynergy_app_backend/cynergy_app_backend.dart';
import 'package:flutter/material.dart';

class NotificationsExample extends StatefulWidget {
  @override
  _NotificationsExampleState createState() => _NotificationsExampleState();
}

class _NotificationsExampleState extends State<NotificationsExample> {
  List<Widget> pages;
  int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    pages = [page1(context), page2()];
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Test"),
      ),

      // Building the [NotificationProvider]
      body: NotificationProvider(
        // What to do when a notification arrives when the app is in foreground
        onMessage: (BuildContext context, Map<String, dynamic> message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(message.toString()),
            )
          );
        },

        // the rest of the app
        child: pages[currentPage],
      ),

      // normal [BottomNavigationBar] stuff
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Container()
          )
        ]
      ),
    );
  }

  /// Random home page
  Widget page1(BuildContext context) {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Home"),
                SizedBox(height: 40),
                RaisedButton(
                  child: Text("Subscribe to new events"),
                  onPressed: () {
                    NotificationProvider.of(context).subscribe(topic: "new_events")
                    .then((value) => Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Subscribed"),)
                    ));
                  },
                ),
                SizedBox(height: 40,),
                RaisedButton(
                  child: Text("Unsubscribe from new events"),
                  onPressed: () {
                    NotificationProvider.of(context).unsubscribe(topic: "new_events")
                    .then((value) => Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Unsubscribed"),)
                    ));
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  Widget page2() {
    return Center(
      child: Text("Profile"),
    );
  }
}