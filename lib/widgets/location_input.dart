import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/product.dart';
import '../screens/map_screen.dart';
import '../utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;
  final Map<String, Object> formData;

  LocationInput(this.onSelectPosition, this.formData, {Key? key})
      : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();

      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPosition(LatLng(
        locData.latitude!,
        locData.longitude!,
      ));
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    if (widget.formData['latitude'] == null) {
      widget.formData['latitude'] = 37.419857;
      widget.formData['longitude'] = -122.078827;
    }
    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          initialLocation: PlaceLocation(
            latitude: widget.formData['latitude'] as double,
            longitude: widget.formData['longitude'] as double,
          ),
        ),
      ),
    );

    if (selectedPosition == null) return;

    _showPreview(selectedPosition.latitude, selectedPosition.longitude);

    widget.onSelectPosition(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.formData['latitude'] != null) {
      _showPreview(
        widget.formData['latitude'] as double,
        widget.formData['longitude'] as double,
      );
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Localização atual'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Selecione no Mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
