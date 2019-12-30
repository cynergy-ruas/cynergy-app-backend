import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  /// The speaker of the session.
  String by;

  /// Date and time of the session.
  Timestamp datetime;

  /// The details of the session
  Map<dynamic, dynamic> details;

  /// The document id of the firebase document containing
  /// the event's information.
  String documentID;

  /// The duration of the session.
  int duration;

  /// The name of the session.
  String name;

  /// The topic of the session
  String topic;

  /// The type of the session.
  String type;
  
  /// The venue of the session.
  String venue;

  Event({
    @required this.by,
    @required this.datetime,
    @required this.details,
    @required this.duration,
    @required this.name,
    @required this.topic,
    @required this.type,
    @required this.venue,
    this.documentID
  });

  Event.fromBareBones({
    @required this.by,
    @required this.datetime,
    @required String description,
    @required this.duration,
    @required this.name,
    @required List<Map<String, String>> links,
    @required this.topic,
    @required this.type,
    @required this.venue,
    this.documentID
  }) {
    this.details = {
      "description": description,
      "materials": {
        "links": links
      }
    };
  }

  /// Adds a link to a session resource to the session details.
  void addLink({@required String title, @required String url}) {
    (details["materials"]["links"] as List).add({"title": title, "url": url});
  }

  String toString(){
    return "Session[Name: $name]";
  }

  /// Formats [datetime]. Example: "Tuesday, March 26, 2019"
  String getLongDate(){
    return DateFormat.yMMMMEEEEd().format(datetime.toDate());
  }

  /// Formats [datetime]. Example: "26th March, 2019"
  String getShortDate() {
    DateTime _date = this.datetime.toDate();
    
    String day = DateFormat.d().format(_date);
    String daySuffix = "th";
    if (day.endsWith("1")) daySuffix = "st";
    else if (day.endsWith("2")) daySuffix = "nd";
    else if (day.endsWith("3")) daySuffix = "rd";

    return day + daySuffix + " " + 
           DateFormat.MMMM().format(_date) + ", " +
           DateFormat.y().format(_date); 
  }

  /// Formats [datetime]. Example: 2:00 pm
  String getTime() {
    return DateFormat.jm().format(datetime.toDate());
  }

  /// The session description
  String get description => details["description"];
  set description(String description) => details["description"] = description;

  /// The links to the resources of the session.
  List<Map<String, String>> get links => details["materials"]["links"];
  set links(List<Map<String, String>> links) => details["materials"]["links"] = links;

  /// Sets the documentID.
  void setDocumentID(String documentID) {
    this.documentID = documentID;
  } 
}

class EventPool {
  static List<Event> events = [];

  /// Sets the events in the [EventPool] to the one provided 
  /// in the argument.
  static void setEvents(List<Event> events) {
    EventPool.events = events;
  }

  /// Adds the [event] to the [EventPool]
  static void addEvent(Event event) {
    EventPool.events.add(event);
  }

  /// Clears all the [event]s in the list
  static void clearEvents() {
    EventPool.events = [];
  }

  /// Gets the index of the first past session among the list of past sessions.
  static int getIndexOfFirstPastEvent() {
    for (int i = 0; i < events.length; i++) 
      if (DateTime.now().difference(events[i].datetime.toDate()) > Duration(seconds: 0))
        return i;
    
    return 0;
  }
}
