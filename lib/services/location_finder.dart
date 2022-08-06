import 'package:geolocator/geolocator.dart';

class LocationFinder {
  static Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    var returnMsg = {'latitude': '', 'altitude': '', 'error': false};

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      returnMsg['error'] = true;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        returnMsg['error'] = true;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      returnMsg['error'] = true;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    returnMsg['error'] = false;
    returnMsg['latitude'] = position.latitude.toString();
    returnMsg['altitude'] = position.altitude.toString();
    return returnMsg;
  }
}
