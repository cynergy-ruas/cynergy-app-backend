import 'package:cynergy_app_backend/src/blocs/notification_bloc.dart';
import 'package:cynergy_app_backend/src/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Provides a notification stream and builds the widget (or whatever is provided)
/// when the app is in foreground. This widget should be at the root of every widget
/// tree for the notifications to be received and the appropriate UI to be shown.
class NotificationProvider extends StatefulWidget {

  /// Builder function that builds the UI when a notification arrives
  final void Function(BuildContext, Map<String, dynamic>) onMessage;

  /// Callback to execute when a notification arrives when the application
  /// is in background. If not given, resumes the app by default.
  final NotificationCallback onResume;

  /// Callback to execute when a notification arrives and the application
  /// is not open. If not given, launches the app by default.
  final NotificationCallback onLaunch;

  /// A child widget
  final Widget child;

  const NotificationProvider({@required this.onMessage, this.onResume, this.onLaunch, this.child});

  @override
  _NotificationProviderState createState() => _NotificationProviderState();

  /// Used to obtain the [FirebaseNotificationServices] object (an [InheritedWidget])
  /// that is present higher up in the widget tree. The [FirebaseNotificationServices]
  /// object can be used to subscribe to events and unsubscribe from events.
  static FirebaseNotificationServices of(BuildContext context) => 
    context.dependOnInheritedWidgetOfExactType(aspect: FirebaseNotificationServices);
}

class _NotificationProviderState extends State<NotificationProvider> {

  /// The [NotificationBloc]
  NotificationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = NotificationBloc();

    // Configuring callbacks to execute when notification arrives
    // and providing the bloc to use when a notification arrives
    // when the app is in foreground
    FirebaseNotificationSettings.instance.configure(
      bloc: _bloc,
      onResume: widget.onResume,
      onLaunch: widget.onLaunch
    );
  }

  @override
  Widget build(BuildContext context) {

    // A [BlocListener] is used to execute [onMessage] as the UI to be shown
    // is assumed to be an alert, snackbar, a navigation, etc.
    // When a notification is recieved, the notification service 
    // (configured using [FirebaseNotificationSettings] in [initState]) adds 
    // a [NotificationRecieved] event to the [NotificationBloc]. 
    // The [NotificationBloc] receives this event and emits a 
    // [ShowNotificationUI] state, which is used to show an appropriate 
    // UI to the user.
    return FirebaseNotificationServices(
      child: BlocListener<NotificationBloc, NotificationState>(
        bloc: _bloc,
        listener: (BuildContext context, NotificationState state) {
          if (state is ShowNotificationUI) 
            widget.onMessage(context, state.message);
        },
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}