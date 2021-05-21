import 'package:civil_project/screens/locationpicker/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as slpMap;
class SimpleLocationPicker extends StatefulWidget {
  final double initialLatitude;

  final double initialLongitude;

  final double zoomLevel;

  final bool displayOnly;

  final Color markerColor;

  SimpleLocationPicker(
      {this.initialLatitude = 32.4279,
      this.initialLongitude = 53.6880,
      this.zoomLevel = 18,
      this.displayOnly = false,
      this.markerColor = Colors.blueAccent});

  @override
  _SimpleLocationPickerState createState() => _SimpleLocationPickerState();
}

class _SimpleLocationPickerState extends State<SimpleLocationPicker> {
  // Holds the value of the picked location.
  SimpleLocationResult _selectedLocation;

  void initState() {
    super.initState();
    _selectedLocation =
        SimpleLocationResult(widget.initialLatitude, widget.initialLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.displayOnly
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_selectedLocation);
              },
            ),
      body: _osmWidget(),
    );
  }

  /// Returns a widget containing the openstreetmaps screen.
  Widget _osmWidget() {
    return slpMap.FlutterMap(
        options: slpMap.MapOptions(
            center: _selectedLocation.getLatLng(),
            zoom: widget.zoomLevel,
            onTap: (tapLoc) {
              if (!widget.displayOnly) {
                setState(() {
                  _selectedLocation =
                      SimpleLocationResult(tapLoc.latitude, tapLoc.longitude);
                });
              }
            }),
        layers: [
          slpMap.TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          slpMap.MarkerLayerOptions(markers: [
            slpMap.Marker(
                width: 80.0,
                height: 80.0,
                anchorPos: slpMap.AnchorPos.align(slpMap.AnchorAlign.top),
                point: _selectedLocation.getLatLng(),
                builder: (ctx) {
                  return Icon(Icons.room, size: 60, color: widget.markerColor);
                })
          ])
        ]);
  }
}
