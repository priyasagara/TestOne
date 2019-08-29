import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../helpers/ensure_visible.dart';
import '../../models/location_data.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;

  LocationInput(this.setLocation);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  LocationData _locationData;
  final FocusNode _addressInputsFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputsFocusNode.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInputsFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      _staticMapUri = null;
      widget.setLocation(null);
      return;
    }
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'address': address,
        'key': 'AIzaSyAlXPXVzpwAH56pHd7072L-H-6cFXgBRos',
        'sensor': 'true',
      },
    );
    final http.Response response = await http.get(uri);

    if (response.statusCode != 200 && response.statusCode != 201) {
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
          decodedResponse['result'][0]['formatted_address'];
      final cords = decodedResponse['result'][0]['geometry']['location'];
      _locationData = LocationData(
          address: formattedAddress,
          latitude: cords['lat'],
          longitude: cords['lng']);

      final StaticMapProvider staticMapProvider =
          StaticMapProvider('AIzaSyAlXPXVzpwAH56pHd7072L-H-6cFXgBRos');
      final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
        [
          Marker('position', 'Position', _locationData.latitude,
              _locationData.longitude)
        ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap,
      );
      widget.setLocation(_locationData);
      setState(() {
        _addressInputController.text = _locationData.address;
        _staticMapUri = staticMapUri;
      });
    }
  }

  void _updateLocation() {
    if (!_addressInputsFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputsFocusNode,
          child: TextFormField(
            focusNode: _addressInputsFocusNode,
            controller: _addressInputController,
            validator: (String value) {
              if (_locationData == null || value.isEmpty) {
                return 'No valid location found.';
              }
            },
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(_staticMapUri == null
            ? 'https://previews.123rf.com/images/jirkaejc/jirkaejc1601/jirkaejc160100076/50625951-top-view-of-variety-chocolate-pralines.jpg'
            : _staticMapUri.toString()),
      ],
    );
  }
}
