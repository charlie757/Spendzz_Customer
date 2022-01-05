import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
  late String _currentAddress;

/*  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }*/
  @override
  void initState() {
    super.initState();
    _getCurrentLocation().whenComplete(()
    {
      setState(() {});
    });
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      var position;
      List<Placemark> p = await placemarkFromCoordinates(position.latitude, position.longitude);


      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DASHBOARD"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Location',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              if (_currentPosition != null &&
                                  _currentAddress != null)
                                Text(_currentAddress,
                                    style:
                                    Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}