import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/models/donation.dart';
import '../../../data/models/master_data.dart';
import '../../../data/models/need.dart';
import '../../helper/colors_res.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double latitude = 30.3753;
  double longitude = 69.3451;
  late GoogleMapController _googleMapController;
  late LocationData _locationData;
  // Set<Marker> _donationsMarkers = {};
  // Set<Marker> _needsMarkers = {};
  // Set<Marker> _allMarkers = {};
  List<Need> needList = [];
  bool isNeedChecked = false;
  bool isDonationChecked = false;
  bool isAllChecked = false;
  List<Donation> donationList = [];
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    if (isNeedChecked) {
      return Colors.blueAccent;
    }
    if (isDonationChecked) {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }

  void initializeController(GoogleMapController controller) {
    _googleMapController = controller;

    setState(() {
      // // _markers.add(marker3);
      // for (int i = 0; i < needList.length; i++) {
      //   _needsMarkers.add(Marker(
      //     markerId: MarkerId(needList[i].id.toString()),
      //     position: LatLng(needList[i].latitude!, needList[i].longitude!),
      //     infoWindow: InfoWindow(
      //         title: needList[i].title, snippet: needList[i].description),
      //   ));
      // }
      // _needsMarkers = ScopedModel.of<MasterData>(context).getNeedsMarkers;
      // _donationsMarkers =
      //     ScopedModel.of<MasterData>(context).getDonationsMarkers;
      // _allMarkers = ScopedModel.of<MasterData>(context).getAllMarkers;
    });
  }

  Future<void> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    ScopedModel.of<MasterData>(context).context = context;
    getCurrentLocation().whenComplete(() => {
          latitude = _locationData.latitude!,
          longitude = _locationData.longitude!,
          print(
              'Completed ----------------------------------------------------------------------------------------------'),
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(zoom: 12, target: LatLng(latitude, longitude)))),
        });
  }

  @override
  Widget build(BuildContext context) {
    needList = ScopedModel.of<MasterData>(context, rebuildOnChange: true)
        .getListOfNeeds;
    donationList = ScopedModel.of<MasterData>(context, rebuildOnChange: true)
        .getListOfDonations;
    int id = 0;
    return ScopedModelDescendant<MasterData>(
        builder: (context, child, masterData) {
      double msgcount = 0;
      double leftrightpadding = 20;
      return SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: GoogleMap(
                markers: isAllChecked
                    ? masterData.getAllMarkers
                    : isNeedChecked
                        ? masterData.getNeedsMarkers
                        : masterData.getDonationsMarkers,
                onMapCreated: initializeController,
                padding: EdgeInsets.all(10),
                buildingsEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    zoom: 12, target: LatLng(latitude, longitude)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              padding: EdgeInsets.only(top: 25),
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 15, left: 20, right: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("\t\Needs",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                )),
                            Checkbox(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              checkColor: Colors.white,
                              value: isNeedChecked,
                              shape: CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  isNeedChecked = value!;
                                  isDonationChecked = false;
                                  isAllChecked = false;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("\t\tDonations",
                                style: TextStyle(
                                  color: ColorsRes.green.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                )),
                            Checkbox(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              checkColor: Colors.white,
                              value: isDonationChecked,
                              shape: CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  isDonationChecked = value!;
                                  isNeedChecked = false;
                                  isAllChecked = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("\tAll",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                )),
                            Checkbox(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              checkColor: Colors.white,
                              value: isAllChecked,
                              shape: CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  isAllChecked = value!;
                                  isNeedChecked = false;
                                  isDonationChecked = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ));
    });
  }
}
