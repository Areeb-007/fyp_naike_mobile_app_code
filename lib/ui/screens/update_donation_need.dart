import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/categories.dart';
import '../../data/models/donation.dart';
import '../../data/models/master_data.dart';
import '../../data/models/need.dart';
import '../../data/models/sub_category.dart';
import '../helper/colors_res.dart';
import '../widgets/form_dialogue.dart';
import 'bottom_navigation_screen/home_screen.dart';

class UpdateScreen extends StatefulWidget {
  Function fun;
  int id;
  SelectedOption selectedOption;
  UpdateScreen(this.id, this.selectedOption, this.fun);
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  Need need = Need();
  Donation donation = Donation();
  List<SubCategory> _subCategories = [];
  List<Categories> _categories = [];
  List<SubCategory> _subCategoriesDropDown = [];
  SubCategory? _selectedSubCategory;
  Set<Marker> _markers = {};
  Categories? _selectedCategory;
  double latitude = 30.3753;
  double longitude = 69.3451;
  late GoogleMapController _googleMapController;
  late LocationData _locationData;
  DateTime? _selectedDateTime;
  final _key1 = GlobalKey<FormState>();
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
    print('Option ' + widget.selectedOption.index.toString());
  }

  void initializeController(GoogleMapController controller) {
    _googleMapController = controller;
    if (widget.selectedOption == SelectedOption.Need) {
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 12, target: LatLng(need.latitude!, need.longitude!))));
    } else {
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 12,
              target: LatLng(donation.latitude!, donation.longitude!))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final MasterData masterData =
        ScopedModel.of<MasterData>(context, rebuildOnChange: true);
    final List<Categories> _categories = masterData.getListOfCategories;
    _subCategories = masterData.getListOfSubCategories;
    if (widget.selectedOption == SelectedOption.Need) {
      need = ScopedModel.of<MasterData>(context).getNeedBasedOnID(widget.id);
      _selectedSubCategory = _selectedSubCategory == null
          ? _subCategories.where((element) => element.subID == need.subID).first
          : _selectedSubCategory;
      _selectedDateTime = need.deadLine;
      _markers.add(Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          markerId: MarkerId('1'),
          infoWindow: InfoWindow(title: 'Your Marker'),
          draggable: true,
          onDragEnd: (loc) {
            setState(() {
              need.latitude = loc.latitude;
              need.longitude = loc.longitude;
            });
          },
          position: LatLng(need.latitude!, need.longitude!)));
    } else {
      donation =
          ScopedModel.of<MasterData>(context).getDonationBasedOnID(widget.id);
      _selectedSubCategory = _selectedSubCategory == null
          ? _subCategories
              .where((element) => element.subID == donation.subID)
              .first
          : _selectedSubCategory;
      _markers.add(Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          markerId: MarkerId('1'),
          infoWindow: InfoWindow(title: 'Your Marker'),
          draggable: true,
          onDragEnd: (loc) {
            setState(() {
              donation.latitude = loc.latitude;
              donation.longitude = loc.longitude;
            });
          },
          position: LatLng(donation.latitude!, donation.longitude!)));
    }
    _selectedCategory = _selectedCategory == null
        ? _categories
            .where((element) =>
                element.categoryID == _selectedSubCategory!.categoryID)
            .first
        : _selectedCategory;
    _subCategoriesDropDown = _subCategories
        .where((sub) => sub.categoryID == _selectedCategory!.categoryID)
        .toList();

    return SafeArea(
        child: Theme(
      data: ThemeData(
        colorScheme:
            Theme.of(context).colorScheme.copyWith(primary: ColorsRes.appcolor),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsRes.appcolor,
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _key1,
              child: Column(children: [
                Text('Category'),
                DropdownButtonFormField<String>(
                  value: _selectedCategory!.name,
                  hint: Text(
                    'Categories',
                  ),
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = _categories
                          .where((cat) => cat.name == value.toString())
                          .first;
                      _subCategoriesDropDown = _subCategories
                          .where((sub) =>
                              sub.categoryID == _selectedCategory!.categoryID)
                          .toList();
                      _selectedSubCategory = _subCategoriesDropDown.first;
                      if (widget.selectedOption == SelectedOption.Need) {
                        need.subID = _selectedSubCategory!.subID;
                      } else {
                        donation.subID = _selectedSubCategory!.subID;
                      }
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please Select a Category' : null,
                  items: _categories
                      .map<DropdownMenuItem<String>>((Categories value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
                // ----------------------------- Sub Categories ------------------------
                Text('Sub Category'),
                DropdownButtonFormField<SubCategory>(
                  value: _subCategories
                      .where((element) =>
                          element.subID ==
                          (widget.selectedOption == SelectedOption.Need
                              ? need.subID
                              : donation.subID))
                      .first,
                  hint: Text(
                    'Sub Categories',
                  ),
                  icon: Icon(Icons.arrow_downward),
                  onChanged: _selectedCategory != _categories[0]
                      ? (value) {
                          print('in sub cat');
                          setState(() {
                            _selectedSubCategory = _subCategories
                                .where((sub) => sub.name == value.toString())
                                .first;
                            print(_selectedSubCategory!.name);
                            if (widget.selectedOption == SelectedOption.Need) {
                              need.subID = _selectedSubCategory!.subID;
                            } else {
                              donation.subID = _selectedSubCategory!.subID;
                            }
                          });
                        }
                      : null,
                  validator: (value) =>
                      value == null ? 'Please Select a Sub Category' : null,
                  items: _subCategoriesDropDown
                      .map<DropdownMenuItem<SubCategory>>((SubCategory value) {
                    return DropdownMenuItem<SubCategory>(
                      value: value,
                      child: Text(value.name!),
                    );
                  }).toList(),
                ),
                //------------------------------------------- Title ------------------------------------------------
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  initialValue: widget.selectedOption == SelectedOption.Need
                      ? need.title
                      : donation.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                  },
                  onChanged: (value) {
                    if (widget.selectedOption == SelectedOption.Need) {
                      need.title = value;
                    } else {
                      donation.title = value;
                    }
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    labelText: 'Title',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: ColorsRes.appcolor,
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: ColorsRes.txtdarkcolor,
                        width: 2.0,
                      ),
                    ),
                    // alignLabelWithHint: true,
                  ),
                  keyboardType: TextInputType.text,
                  showCursor: true,
                ),
                SizedBox(
                  height: 30,
                  width: 10,
                ),
                // ----------------------------- Descriptions ------------------------
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                  },
                  initialValue: widget.selectedOption == SelectedOption.Need
                      ? need.description
                      : donation.description,
                  maxLines: 3,
                  onChanged: (value) {
                    if (widget.selectedOption == SelectedOption.Need) {
                      need.description = value;
                    } else {
                      donation.description = value;
                    }
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'Description',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: ColorsRes.appcolor,
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: ColorsRes.txtdarkcolor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  showCursor: true,
                ),
                SizedBox(
                  height: 30,
                  width: 10,
                ),
                // -----------------------------Initial Quantity ------------------------
                TextFormField(
                  initialValue: widget.selectedOption == SelectedOption.Need
                      ? need.initialQuantity.toString()
                      : donation.initialQuantity.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    try {
                      if (double.parse(value.toString()) < 0) {
                        return 'Please enter a positive value';
                      }
                    } catch (e) {
                      return 'Please enter quantity in numbers only';
                    }
                  },
                  onChanged: (value) {
                    if (widget.selectedOption == SelectedOption.Need) {
                      need.initialQuantity = double.parse(value);
                      // need.currentQuantity = double.parse(value);
                    } else {
                      donation.initialQuantity = double.parse(value);
                      // donation.currentQuantity = double.parse(value);
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: ColorsRes.appcolor,
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: ColorsRes.txtdarkcolor,
                        width: 2.0,
                      ),
                    ),
                    icon: Icon(Icons.production_quantity_limits),
                    labelText: 'Initial Quantity',
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  showCursor: true,
                ),
                SizedBox(
                  height: 30,
                  width: 10,
                ),
                // ----------------------------- Current Quantity ------------------------
                TextFormField(
                  initialValue: widget.selectedOption == SelectedOption.Need
                      ? need.currentQuantity.toString()
                      : donation.currentQuantity.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    try {
                      if (double.parse(value.toString()) < 0) {
                        return 'Please enter a positive value';
                      }
                    } catch (e) {
                      return 'Please enter quantity in numbers only';
                    }
                  },
                  onChanged: (value) {
                    if (widget.selectedOption == SelectedOption.Need) {
                      // need.initialQuantity = double.parse(value);
                      need.currentQuantity = double.parse(value);
                    } else {
                      // donation.initialQuantity = double.parse(value);
                      donation.currentQuantity = double.parse(value);
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: ColorsRes.appcolor,
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: ColorsRes.txtdarkcolor,
                        width: 2.0,
                      ),
                    ),
                    icon: Icon(Icons.production_quantity_limits),
                    labelText: 'Current Quantity',
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  showCursor: true,
                ),
                SizedBox(
                  height: 30,
                  width: 10,
                ),

                // ----------------------------- Delivery Type ------------------------
                // Text('Select a type delivery'),
                DropdownButtonFormField<String>(
                  value: widget.selectedOption == SelectedOption.Need
                      ? need.deliveryType
                      : donation.deliveryType,
                  hint: Text(
                    'Delivery Types',
                  ),
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (value) {
                    setState(() {
                      if (widget.selectedOption == SelectedOption.Need) {
                        need.deliveryType = value;
                      } else {
                        donation.deliveryType = value;
                      }
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please Select a Category' : null,
                  items: masterData.getListOfDeliveryType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 30,
                  width: 10,
                ),
                // ----------------------------- Due date ------------------------
                widget.selectedOption == SelectedOption.Need
                    ? InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              _selectedDateTime == null
                                  ? 'Select a DueDate'
                                  : DateFormat.yMMMMd('en_US')
                                      .format(_selectedDateTime!),
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(Icons.calendar_today,
                                size: 30, color: ColorsRes.appcolor)
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                // ----------------------------- Maps ------------------------
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _markers.clear();
                            if (widget.selectedOption == SelectedOption.Need) {
                              need.latitude = null;
                              need.longitude = null;
                            } else {
                              donation.latitude = null;
                              donation.longitude = null;
                            }
                          });
                        },
                        child: Text('Remove marker')),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: ColorsRes.appcolor,
                            width: 4,
                          )),
                      height: MediaQuery.of(context).size.height * 0.40,
                      child: GoogleMap(
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                        markers: _markers,
                        onMapCreated: initializeController,
                        padding: EdgeInsets.all(10),
                        buildingsEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        onLongPress: (loc) {
                          setState(() {
                            print('location : ' + loc.toString());
                            if (widget.selectedOption == SelectedOption.Need) {
                              need.latitude = loc.latitude;
                              need.longitude = loc.longitude;
                            } else {
                              donation.latitude = loc.latitude;
                              donation.longitude = loc.longitude;
                            }
                            _markers.add(Marker(
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen),
                                markerId: MarkerId('1'),
                                infoWindow: InfoWindow(title: 'Current Need'),
                                draggable: true,
                                onDragEnd: (loc) {
                                  setState(() {
                                    if (widget.selectedOption ==
                                        SelectedOption.Need) {
                                      need.latitude = loc.latitude;
                                      need.longitude = loc.longitude;
                                    } else {
                                      donation.latitude = loc.latitude;
                                      donation.longitude = loc.longitude;
                                    }
                                  });
                                },
                                position: LatLng(loc.latitude, loc.longitude)));
                          });
                        },
                        initialCameraPosition: CameraPosition(
                            zoom: 12, target: LatLng(latitude, longitude)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
              ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_key1.currentState!.validate()) {
              if (_selectedCategory == _categories[0]) {
                showTheFormAlertWarningDialog(
                    context, 'Warning', 'You Have Not Selected Any Category');
              } else if ((_selectedDateTime == null ||
                      _selectedDateTime!.isBefore(
                          DateTime.now().subtract(Duration(days: 1)))) &&
                  widget.selectedOption == SelectedOption.Need) {
                showTheFormAlertWarningDialog(
                    context, 'Warning', 'Your Due Date is not valid');
              } else if (widget.selectedOption == SelectedOption.Need &&
                  need.deliveryType == masterData.getListOfDeliveryType.first) {
                showTheFormAlertWarningDialog(context, 'Warning',
                    'You Have Not Selected A Delivery Type');
              } else if (widget.selectedOption == SelectedOption.Donation &&
                  donation.deliveryType ==
                      masterData.getListOfDeliveryType.first) {
                showTheFormAlertWarningDialog(context, 'Warning',
                    'You Have Not Selected A Delivery Type');
              } else if (widget.selectedOption == SelectedOption.Need &&
                  (need.latitude == null || need.longitude == null)) {
                showTheFormAlertWarningDialog(
                    context, 'Warning', 'You Have Not Selected Any Location ');
              } else if (widget.selectedOption == SelectedOption.Donation &&
                  (donation.latitude == null || donation.longitude == null)) {
                showTheFormAlertWarningDialog(
                    context, 'Warning', 'You Have Not Selected Any Location');
              } else {
                print('ok scene hai');
                showTheDeleteConfirmationDialog(context, '?',
                    'Are you sure you want to update with these changes', () {
                  if (widget.selectedOption == SelectedOption.Need) {
                    masterData.getDioServices
                        .updateNeed(need, context)
                        .whenComplete(() => {
                              masterData.loadUpData(),
                              widget.fun(),
                            });
                    Timer(Duration(seconds: 4), () {
                      // Navigator.pushReplacement(context, newRoute)
                      Navigator.pop(context);
                    });
                    // Navigator.pop(context);
                  } else {
                    masterData.getDioServices
                        .updateDonation(donation, context)
                        .whenComplete(() => {
                              masterData.loadUpData(),
                              widget.fun(),
                            });
                    Timer(Duration(seconds: 4), () {
                      // Navigator.pushReplacement(context, newRoute)
                      // TODO: TO automatically send to dashboard screen
                      // Navigator.pop(context);
                    });
                  }
                });
              }
            }
          },
          backgroundColor: ColorsRes.appcolor,
          child: Icon(
            Icons.update,
            color: ColorsRes.white,
          ),
        ),
      ),
    ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _selectedDateTime = picked;
        if (widget.selectedOption == SelectedOption.Need) {
          need.deadLine = _selectedDateTime;
        }
      });
  }
}
