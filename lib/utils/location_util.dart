import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const googleApiKey = 'AIzaSyDf7OTq3OtAmHtKQOYATKxJHrQqBwhEC5k';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%$latitude,$longitude&markers=color:green%7Clabel:G%$latitude,$longitude&markers=color:red%7Clabel:C%$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getAddressFrom(LatLng position) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey');
    final response = await http.get(url);
    return json
        .decode(response.body)['results'][0]['formatted_address']
        .toString();
  }
}
