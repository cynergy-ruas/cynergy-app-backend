import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Defining the events

/// The base class for notification events
abstract class NotificationEvent extends Equatable {
  NotificationEvent([List props = const []]) : super(props);
}

/// The event emitted when a notification is received
class NotificationReceived extends NotificationEvent { 
  final Map<String, dynamic> message;

  NotificationReceived({@required this.message});

  @override
  String toString() => "Notification Received";
}

// Defining the states

/// The base class for notification events
abstract class NotificationState extends Equatable {
  NotificationState([List props = const []]) : super(props);
}

/// The initial state
class NotificationUninitialized extends NotificationState {
  @override
  String toString() => "Notification uninitialized state";
}

/// The state to transit to when a notification occurs.
/// This state signals that an appropriate UI should be shown.
class ShowNotificationUI extends NotificationState {
  final Map<String, dynamic> message;

  ShowNotificationUI({@required this.message});

  @override
  String toString() => "Showing notification UI";
}

// Defining the Bloc. Logic goes here

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  @override 
  NotificationState get initialState => NotificationUninitialized();

  /// Maps notification events to states.
  /// The function yields a [ShowNotificationUI] state when
  /// A notification ([NotificationRecieved]) occurs to signal 
  /// the app to show the appropriate UI.
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationReceived) {
      yield ShowNotificationUI(message: event.message);
      yield initialState;
    }
  }
}

