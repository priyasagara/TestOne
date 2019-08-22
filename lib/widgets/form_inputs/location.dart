import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
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

  void getStatisMap(String address) async {
    if (address.isEmpty) {
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

      final StaticMapProvider staticMapProvider =
          StaticMapProvider('AIzaSyAlXPXVzpwAH56pHd7072L-H-6cFXgBRos');
      final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', cords['lat'], cords['lng'])],
        center: Location(cords['lat'], cords['lng']),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap,
      );
      setState(() {
        _addressInputController.text = formattedAddress;
        _staticMapUri = staticMapUri;
      });
    }
  }

  void _updateLocation() {
    if (!_addressInputsFocusNode.hasFocus) {
      getStatisMap(_addressInputController.text);
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
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(_staticMapUri.toString().isEmpty
            ? 'https://previews.123rf.com/images/jirkaejc/jirkaejc1601/jirkaejc160100076/50625951-top-view-of-variety-chocolate-pralines.jpg'
            : _staticMapUri.toString()),
      ],
    );
  }
}
