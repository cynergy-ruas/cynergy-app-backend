import 'package:flutter/material.dart';
import 'package:cynergy_app_backend/cynergy_app_backend.dart';

class EventLoadExample extends StatefulWidget {
  @override
  _EventLoadExampleState createState() => _EventLoadExampleState();
}

class _EventLoadExampleState extends State<EventLoadExample> {
  /// Global key for accessing the state of the [EventLoader].
  /// Used to begin loading the events
  final GlobalKey<EventLoaderState> loaderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Load Example"),
      ),
      body: Center(
        // using a [Builder] widget so that snackbars can be 
        // shown.
        child: EventLoader(
          key: loaderKey,

          // widget to display when the event loading has not begun.
          onUninitialized: RaisedButton(
            child: Text("Load events"),
            onPressed: () => loaderKey.currentState.loadData(),
          ),

          // widget to display when the event loading is going on.
          onLoading: CircularProgressIndicator(),

          // widget to display when the events are loaded.
          onLoaded: (List<Event> events) {
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                Event event = events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.description),
                );
              },
            );
          },

          onError: (BuildContext context, Exception e) => Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${e.toString()}'),
              backgroundColor: Colors.red,
            )
          ),
        ),
      ),
    );
  }
}