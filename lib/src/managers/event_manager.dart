import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cynergy_app_backend/src/models/events_model.dart';
import 'package:cynergy_app_backend/src/services/database.dart';

/// Loads the event data using the database API and stores it
/// in the [EventPool]
class EventManager {
  static const int numberOfSessions = 4;

  Future <void> loadData() async {
    // getting instance of database
    Database db = await Database.instance;

    // getting raw information about all events
    List<Map<String, dynamic>> data = await db.getRecentEvents(count: numberOfSessions);

    // clearing the events from the [EventPool]
    EventPool.clearEvents();

    // creating events and updating [EventPool]
    for (int i = 0; i < data.length; i++) {
      // skipping the template document if present
      // in the database
      if (data[i]["docRef"] == "template")
        continue;

      EventPool.addEvent(Event(
        by: data[i]["by"],
        datetime: data[i]["date"],
        details: data[i]["details"],
        duration: data[i]["duration"],
        documentID: data[i]["docRef"],
        name: data[i]["eventName"],
        topic: data[i]["eventTopic"],
        type: data[i]["type"],
        venue: data[i]["venue"],
      ));
    }
  }

  /// Adds an event to the database
  Future<void> addEvent({String by, DateTime date, DateTime time, String description, int duration,
     String name, List<Map<String, String>> links, String topic, String type, String venue}) async {
         
    // creating event object
    Event event = Event.fromBareBones(
      by: by,
      datetime: Timestamp.fromDate(
        DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
          time.second
        )
      ),
      description: description,
      duration: duration,
      name: name,
      links: links,
      topic: topic,
      type: type,
      venue: venue
    );

    // getting instance of database
    Database db = await Database.instance;
    db.uploadEvent(event: event);
  }

  /// Updates an event referenced by [documentID] with the values given as arguments.
  Future<void> updateEvent({@required Event event, String by, DateTime datetime, String description,
    int duration, String name, List<Map<String, String>> links, String topic, String type, String venue}) async {
      
    // modifying event object if the given parameter is not null
    // and if its not same as the old one.
    if (by != null && event.by != by)
      event.by = by;
    if (datetime != null && event.datetime != Timestamp.fromDate(datetime))
      event.datetime = Timestamp.fromDate(datetime);
    if (description != null && event.description != description)
      event.description = description;
    if (duration != null && event.duration != duration)
      event.duration = duration;
    if (name != null && event.name != name)
      event.name = name;
    if (links != null && event.links != links)
      event.links = links;
    if (topic != null && event.topic != topic)
      event.topic = topic;
    if (type != null && event.type != type)
      event.type = type;
    if (venue != null && event.venue != venue)
      event.venue = venue;

    // getting instance of database
    Database db = await Database.instance;

    // updating event
    await db.updateEvent(event: event);
  }

  /// Deletes an event.
  Future<void> deleteEvent({@required Event event}) async {
    // getting instance of database
    Database db = await Database.instance;

    // deleting the event
    await db.deleteEvent(event: event);
  }
}