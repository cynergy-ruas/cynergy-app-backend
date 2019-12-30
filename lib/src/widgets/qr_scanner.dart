import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrScanner extends StatelessWidget {
  
  /// The child widget
  final Widget child;

  /// The error code for camera access denied
  static const String CameraAccessDenied = BarcodeScanner.CameraAccessDenied;

  /// The error code for user cancelled before scan was completed
  static const String UserCancelled = BarcodeScanner.UserCanceled;

  /// The error code for unknown error
  static const String UnknownError = "UNKNOWN_ERROR";

  QrScanner({this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  /// Spawns a camera view, scans the QR code and returns
  /// the result. [CameraAccessDenied] is returned when 
  /// the required camera permissions are not given.
  /// [UserCancelled] is returned when the user cancels the 
  /// scan operation before the scan is complete. [UnknownError]
  /// is returned in case of any other error.
  /// If the scan is successful, the resultant string is returned.
  static Future<String> scan() async {
    String res;
    try {
      res = await BarcodeScanner.scan();
    }
    on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) 
        return CameraAccessDenied;

      else 
        return UnknownError;
    } 
    on FormatException{
      return UserCancelled; 
    }
    catch (e) {
      return UnknownError;
    }

    return res;
  }
}