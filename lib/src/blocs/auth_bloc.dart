import 'package:bloc/bloc.dart';
import 'package:cynergy_app_backend/src/services/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:cynergy_app_backend/src/models/user_model.dart';

// Defining the events

/// The base class for auth events
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

/// The event emitted when the app first starts
class AppStart extends AuthEvent {
  @override
  String toString() => "App started.";
}

/// The event emitted when the user attempts to log in
class LogIn extends AuthEvent {
  final String email;
  final String password;

  LogIn({@required this.email, @required this.password}) : super([email, password]);

  @override
  String toString() => "User is logging in";
}

/// The event emitted when the user attempts to logs out
class LogOut extends AuthEvent {
  @override
  String toString() => "User is logging out";
}

// Defining the states

/// The base class for auth states
abstract class AuthState extends Equatable {}

/// The state when the authentication is not initialized, initial state
/// The UI associated with this state is usually the splash screen
class AuthUninitialized extends AuthState {
  String toString() => "AuthenticationUninitialized";
}

/// The state when the authentication is valid.
/// The UI associated with this state is usually the home screen
class AuthValid extends AuthState {
  String toString() => "AuthenticationValid";
}

/// The state when authentication is invalid/when user has logged out/when user has not logged in
/// The UI associated with this state is usually the login screen
class AuthInvalid extends AuthState {
  String toString() => "AuthenticationInvalid";
}

/// The state when authentication is loading
class AuthLoading extends AuthState {
  String toString() => "AuthLoading";
}

/// The state when an error occurs while logging in
class AuthError extends AuthState {
  final Exception exception;
  
  AuthError({@required this.exception});
  String toString() => "AuthError { error: ${exception.toString()} }";
}

// Defining the Bloc. Logic goes here

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  LoginAuth _auth = LoginAuth.getInstance();

  @override
  AuthState get initialState => AuthUninitialized();

  /// Maps auth events to auth states.
  /// The function takes the event emitted [AuthEvent] and  
  /// yields a new [AuthState] as a response to the [AuthEvent].
  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    
    // checks if the user is logged in or not. If the user has logged 
    // in already, yield [AuthValid] state. if not, yield [AuthInvalid]
    // state.
    if (event is AppStart) {
      // yield uninitialized state first, since nothing has happened yet
      yield AuthUninitialized();

      // getting current user
      var user = User.instance;

      // checking if user is already logged in
      if (await _auth.isLoggedIn()) {
        // if the user is logged in, set the claims
        user.setClaims(await _auth.getClaims());

        // yield [AuthValid] state
        yield AuthValid();
      }
      else
        // user has not logged in, yield AuthInvalid
        yield AuthInvalid();
    }

    // if the user is trying to log in
    else if (event is LogIn) {
      // yield loading state
      yield AuthLoading();
      

      try{
        // logging in
        await _auth.login(email: event.email, password: event.password);

        // setting claims
        User.instance.setClaims(await _auth.getClaims());

        // yield [AuthValid] state
        yield AuthValid();
      }
      catch (e) {
        // error occured while logging in, yield [AuthError] state
        yield AuthError(exception: e);
        // yielding [AuthInvalid] state
        yield AuthInvalid();
      }
    }

    // if the user is trying to log out
    else if (event is LogOut){
      // yield loading state
      yield AuthLoading();

      // logging out
      await _auth.logout();

      // yield [AuthInvalid] state
      yield AuthInvalid();
    }
  }
  
}
