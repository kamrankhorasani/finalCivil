import 'package:latlong/latlong.dart' as coordinates;

class SimpleLocationResult {
  /// The latitude of the result.
  final double latitude;

  /// The longitude of the result.
  final double longitude;

  /// Construct the result with a latitude and longitude.
  SimpleLocationResult(this.latitude, this.longitude);

  /// returns the SimpleLocationResult location as a LatLng object
  getLatLng() => coordinates.LatLng(latitude, longitude);
}