import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';

/// Updates the clearance level of a user using firebases's cloud functions.
Future<dynamic> updateClearanceForUser({@required String email, @required int clearance}) async {
  // getting reference to cloud function
  final HttpsCallable updateClearance = CloudFunctions.instance.getHttpsCallable(
    functionName: "updateClearance"
  );

  // calling the function with the data
  HttpsCallableResult response = await updateClearance.call({
    "email": email,
    "clearance": clearance,
  });

  // returning response
  return response.data;
}