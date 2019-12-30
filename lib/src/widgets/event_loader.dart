import 'package:cynergy_app_backend/src/blocs/data_load_bloc.dart';
import 'package:cynergy_app_backend/src/managers/event_manager.dart';
import 'package:cynergy_app_backend/src/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that loads and displays the events.
class EventLoader extends StatefulWidget {
  /// callback to execute when exception occurs.
  final void Function(BuildContext, Exception) onError;

  /// Widget to display when the data is loading
  final Widget onLoading;

  /// Widget to display when the data is not loaded
  final Widget onUninitialized;

  /// Function that returns the widget to display when
  /// the data is loaded. The [List<Event>] provided as an 
  /// argument is empty if the client (phone) is not 
  /// connected to the internet.
  final Widget Function(List<Event>) onLoaded;

  /// Specifies whether to begin loading the data
  /// immediately. If false (default is false), the 
  /// [loadData] method should be called externally.
  final bool beginLoad;

  EventLoader({Key key, @required this.onUninitialized, @required this.onLoading, 
                @required this.onLoaded, @required this.onError, this.beginLoad = false}) : super(key: key);

  @override
  EventLoaderState createState() => EventLoaderState();
}

class EventLoaderState extends State<EventLoader> {
  final DataLoadBloc _bloc = DataLoadBloc(manager: EventManager());
  
  // getting the parameters from widget
  bool get beginLoad => widget.beginLoad;
  Widget get onUninitialized => widget.onUninitialized;
  Widget get onLoading => widget.onLoading;
  Widget Function(List<Event>) get onLoaded => widget.onLoaded;
  void Function(BuildContext, Exception) get onError => widget.onError;

  @override
  void initState() {
    super.initState();

    if (beginLoad)
      _bloc.add(BeginDataLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataLoadBloc, DataLoadState> (
      bloc: _bloc,

      // listening for errors.
      listener: (BuildContext context, DataLoadState state) {
        // if there is an error,
        if (state is DataLoadError)
          // execute [onError] callback
          onError(context, state.exception);
      },

      child: BlocBuilder<DataLoadBloc, DataLoadState> (
        bloc: _bloc,

        // building widget based on other states
        builder: (BuildContext context, DataLoadState state) {
          // if the data load is not started,
          if (state is DataLoadUnintialized)
            return onUninitialized;
          
          // if the data is loading,
          if (state is DataLoadOnGoing)
            return onLoading;

          // if the data is loaded,
          else
            return onLoaded(EventPool.events);
        },
      ),
    );
  }

  void loadData() {
    _bloc.add(BeginDataLoad());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
