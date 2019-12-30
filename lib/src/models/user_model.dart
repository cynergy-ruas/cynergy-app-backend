class User {

  Map<String, dynamic> claims;
  static User _instance;

  /// private constructor.
  User._();

  /// Setter for [claims]
  void setClaims(Map<String, dynamic> claims) => this.claims = claims;

  /// Returns the email id of the user.
  /// The claims need to be set before this function
  /// is called.
  String getEmailID() => claims["email"];

  /// Gets the clearance level of the user. If the value
  /// is null, 0 is returned. 
  /// The claims need to be set before this function
  /// is called.
  int getClearanceLevel() => claims["clearance"] ?? 0;

  /// Checks if user is a coordinator or not.
  bool isCoordinator() => claims["coordinator"] ?? false;

  /// Gets an instance of this class. Only one
  /// instance of this class should exist.
  static User get instance {
    if (_instance == null) {
      _instance = User._();
    }
    return _instance;
  }
}