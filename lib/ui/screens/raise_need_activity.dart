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

class RaiseNeedActivity extends StatefulWidget {
  static const String pageRoute = '/RaiseNeedActivity';
  // const RaiseNeedActivity({Key? key} ) : super(key: key);
  RaiseNeedActivity(this._selectedOption);
  SelectedOption _selectedOption;
  @override
  _RaiseNeedActivityState createState() => _RaiseNeedActivityState();
}

class _RaiseNeedActivityState extends State<RaiseNeedActivity> {
  Need need = Need();
  Donation donation = Donation();
  int stepsCount = 3;
  int _index = 0;
  final _key1 = GlobalKey<FormState>();
  String deliveryType = 'Select a delivery type';
  bool _stepOneActive = true;
  bool _stepTwoActive = false;
  bool _stepThreeActive = false;
  StepState step1State = StepState.editing;
  StepState step2State = StepState.disabled;
  StepState step3State = StepState.disabled;
  List<SubCategory> _subCategories = [];
  List<SubCategory> _subCategoriesDropDown = [];
  SubCategory? _selectedSubCategory;
  Set<Marker> _markers = {};
  Categories? _selectedCategory;
  double latitude = 30.3753;
  double longitude = 69.3451;
  late GoogleMapController _googleMapController;
  late LocationData _locationData;
  DateTime? _selectedDateTime;
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

  void initializeController(GoogleMapController controller) {
    _googleMapController = controller;
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation().whenComplete(() => {
          latitude = _locationData.latitude!,
          longitude = _locationData.longitude!,
          print(
              'Completed ----------------------------------------------------------------------------------------------'),
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(zoom: 20, target: LatLng(latitude, longitude)))),
        });
  }

  @override
  Widget build(BuildContext context) {
    final MasterData masterData =
        ScopedModel.of<MasterData>(context, rebuildOnChange: true);
    final List<Categories> _categories = masterData.getListOfCategories;
    _selectedCategory =
        _selectedCategory == null ? _categories.first : _selectedCategory;
    _subCategories = masterData.getListOfSubCategories;
    _subCategoriesDropDown = _subCategories
        .where((sub) => sub.categoryID == _selectedCategory!.categoryID)
        .toList();
    _selectedSubCategory = _selectedSubCategory == null
        ? _subCategories
            .where((sub) => sub.categoryID == _categories.first.categoryID)
            .first
        : _selectedSubCategory;
    return SafeArea(
        child: Theme(
      data: ThemeData(
        colorScheme:
            Theme.of(context).colorScheme.copyWith(primary: ColorsRes.appcolor),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsRes.appcolor,
          backwardsCompatibility: true,
        ),
        body: Container(
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                if (_index == 1) {
                  setState(() {
                    step2State = StepState.disabled;
                    _stepTwoActive = false;
                    step1State = StepState.editing;
                    _stepOneActive = true;
                  });
                }
                if (_index == 2) {
                  setState(() {
                    step3State = StepState.disabled;
                    _stepThreeActive = false;
                    step2State = StepState.editing;
                    _stepTwoActive = true;
                  });
                }
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_index == 2) {
                if ((need.latitude == null || need.longitude == null) &&
                    widget._selectedOption == SelectedOption.Need) {
                  showTheFormAlertWarningDialog(context, '(*-*)',
                      'You have not selected any Location please select a Location');
                } else if ((donation.latitude == null ||
                        donation.longitude == null) &&
                    widget._selectedOption == SelectedOption.Donation) {
                  showTheFormAlertWarningDialog(context, '(*-*)',
                      'You have not selected any Location please select a Location');
                } else {
                  print('ok hogia');

                  showTheDeleteConfirmationDialog(
                      context, '?', 'Are you sure you want to create this need',
                      () {
                    if (widget._selectedOption == SelectedOption.Need) {
                      need.userID = masterData.getUser.id;
                      masterData.getDioServices.raiseNeed(need, context);

                      masterData.loadUpData();
                      // showTheFormAlertSuccessDialog(context, 'Need Raised',
                      //     'Your Need has applied for approval successfully and will be updated after the approval.');
                      Timer(const Duration(seconds: 4), () {
                        // Navigator.pushReplacement(context, newRoute)
                        Navigator.pop(context);
                      });
                    } else {
                      donation.userID = masterData.getUser.id;

                      masterData.getDioServices
                          .raiseDonation(donation, context);
                      masterData.loadUpData();
                      // showTheFormAlertSuccessDialog(context, 'Donation Raised',
                      //     'Your Need has applied for approval successfully and will be updated after the approval.');
                      Timer(const Duration(seconds: 4), () {
                        // Navigator.pushReplacement(context, newRoute)
                        Navigator.pop(context);
                      });
                    }
                  });
                }
              }
              if (_index == 1) {
                if (_key1.currentState!.validate()) {
                  if (deliveryType == 'Select a delivery type') {
                    showTheFormAlertWarningDialog(context, '(*-*)',
                        'You have not selected any Type of delivery please select a at least one');
                  } else if (need.deadLine == null &&
                      widget._selectedOption == SelectedOption.Need) {
                    showTheFormAlertWarningDialog(context, '(*-*)',
                        'You have not selected any due date please select a due date');
                  } else if (_index < stepsCount) {
                    setState(() {
                      _index += 1;
                    });
                    setState(() {
                      _stepTwoActive = false;
                      _stepThreeActive = true;
                      step3State = StepState.editing;
                      step2State = StepState.complete;
                    });
                  }
                }
              }
              if (_index == 0) {
                if (_selectedCategory == _categories[0]) {
                  showTheFormAlertWarningDialog(context, '(*-*)',
                      'You have not selected any category please select a category');
                } else if (_selectedSubCategory == null) {
                  showTheFormAlertWarningDialog(context, '(*-*)',
                      'You have not selected any Sub-category please select a sub-category');
                } else {
                  if (_index < stepsCount) {
                    setState(() {
                      _index += 1;
                    });
                    setState(() {
                      _stepOneActive = false;
                      _stepTwoActive = true;
                      step2State = StepState.editing;
                      step1State = StepState.complete;
                    });
                  }
                }
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
                if (_index == 0) {
                  step1State = StepState.editing;
                  _stepOneActive = true;
                  step2State = StepState.indexed;
                  _stepTwoActive = false;
                  step3State = StepState.indexed;
                  _stepThreeActive = false;
                } else if (_index == 1) {
                  step1State = StepState.indexed;
                  _stepOneActive = false;
                  step2State = StepState.editing;
                  _stepTwoActive = true;
                  step3State = StepState.indexed;
                  _stepThreeActive = false;
                } else {
                  step1State = StepState.indexed;
                  _stepOneActive = false;
                  step2State = StepState.indexed;
                  _stepTwoActive = false;
                  step3State = StepState.editing;
                  _stepThreeActive = true;
                }
              });
            },
            steps: <Step>[
              Step(
                  state: step1State,
                  isActive: _stepOneActive,
                  title: const Text('Step 1'),
                  content: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCategory!.name,
                        hint: const Text(
                          'Categories',
                        ),
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = _categories
                                .where((cat) => cat.name == value.toString())
                                .first;
                            if (_subCategories
                                    .where((sub) =>
                                        sub.categoryID ==
                                        _selectedCategory!.categoryID)
                                    .toList()
                                    .length ==
                                0) {
                              print('Came Here');
                              _subCategoriesDropDown = [];
                              _selectedSubCategory = null;
                            } else {
                              _subCategoriesDropDown = _subCategories
                                  .where((sub) =>
                                      sub.categoryID ==
                                      _selectedCategory!.categoryID)
                                  .toList();
                              _selectedSubCategory =
                                  _subCategoriesDropDown.first;
                              if (widget._selectedOption ==
                                  SelectedOption.Need) {
                                need.subID = _selectedSubCategory!.subID;
                              } else {
                                donation.subID = _selectedSubCategory!.subID;
                              }
                            }

                            // print(_subCategoriesDropDown.first.name);
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
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      // ----------------------------- Sub Categories ------------------------
                      DropdownButtonFormField<String>(
                        value: _selectedSubCategory!.name,
                        hint: const Text(
                          'Sub Categories',
                        ),
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: _selectedCategory == _categories[0]
                            ? null
                            : (value) {
                                print('in sub cat');
                                setState(() {
                                  _selectedSubCategory = _subCategories
                                      .where(
                                          (sub) => sub.name == value.toString())
                                      .first;
                                  print(_selectedSubCategory!.name);
                                  if (widget._selectedOption ==
                                      SelectedOption.Need) {
                                    need.subID = _selectedSubCategory!.subID;
                                  } else {
                                    donation.subID =
                                        _selectedSubCategory!.subID;
                                  }
                                });
                              },
                        validator: (value) => value == null
                            ? 'Please Select a Sub Category'
                            : null,
                        items: _subCategoriesDropDown
                            .map<DropdownMenuItem<String>>((SubCategory value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
                    ],
                  )),
              Step(
                state: step2State,
                isActive: _stepTwoActive,
                title: const Text('Step 2 title'),
                content: Form(
                  key: _key1,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: need.title == null ? null : need.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                        },
                        onChanged: (value) {
                          if (widget._selectedOption == SelectedOption.Need) {
                            need.title = value;
                          } else {
                            donation.title = value;
                          }
                        },
                        decoration: InputDecoration(
                          icon: const Icon(Icons.title),
                          labelText: 'Title',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: ColorsRes.appcolor,
                              )),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: ColorsRes.txtdarkcolor,
                              width: 2.0,
                            ),
                          ),
                          // alignLabelWithHint: true,
                        ),
                        keyboardType: TextInputType.text,
                        showCursor: true,
                      ),
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      // ----------------------------- Descriptions ------------------------
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                        },
                        initialValue:
                            need.description == null ? null : need.description,
                        maxLines: 3,
                        onChanged: (value) {
                          if (widget._selectedOption == SelectedOption.Need) {
                            need.description = value;
                          } else {
                            donation.description = value;
                          }
                        },
                        decoration: InputDecoration(
                          icon: const Icon(Icons.description),
                          labelText: 'Description',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: ColorsRes.appcolor,
                              )),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: ColorsRes.txtdarkcolor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        showCursor: true,
                      ),
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      // ----------------------------- Quantity ------------------------
                      TextFormField(
                        initialValue: need.initialQuantity == null
                            ? null
                            : need.initialQuantity.toString(),
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
                          if (widget._selectedOption == SelectedOption.Need) {
                            need.initialQuantity = double.parse(value);
                            need.currentQuantity = double.parse(value);
                          } else {
                            donation.initialQuantity = double.parse(value);
                            donation.currentQuantity = double.parse(value);
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: ColorsRes.appcolor,
                              )),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: ColorsRes.txtdarkcolor,
                              width: 2.0,
                            ),
                          ),
                          icon: const Icon(Icons.production_quantity_limits),
                          labelText: 'Quantity',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        showCursor: true,
                      ),
                      const SizedBox(
                        height: 50,
                        width: 10,
                      ),
                      // ----------------------------- Delivery Type ------------------------
                      // Text('Select a type delivery'),
                      DropdownButtonFormField<String>(
                        value: deliveryType,
                        hint: const Text(
                          'Delivery Types',
                        ),
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (value) {
                          setState(() {
                            if (widget._selectedOption == SelectedOption.Need) {
                              need.deliveryType = value;
                            } else {
                              donation.deliveryType = value;
                            }
                            deliveryType = value!;
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
                      const SizedBox(
                        height: 40,
                        width: 10,
                      ),
                      // ----------------------------- Due date ------------------------
                      widget._selectedOption == SelectedOption.Need
                          ? InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _selectedDateTime == null
                                        ? 'Select a DueDate'
                                        : DateFormat.yMMMMd('en_US')
                                            .format(_selectedDateTime!),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const Icon(Icons.calendar_today, size: 20)
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              Step(
                state: step3State,
                isActive: _stepThreeActive,
                title: const Text('Step 3'),
                content: Column(
                  children: [
                    // ----------------------------- Maps ------------------------
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _markers.clear();
                                      if (widget._selectedOption ==
                                          SelectedOption.Need) {
                                        need.latitude = null;
                                        need.longitude = null;
                                      } else {
                                        donation.latitude = null;
                                        donation.longitude = null;
                                      }
                                    });
                                  },
                                  child: const Text('Remove marker')),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _markers.clear();
                                      if (widget._selectedOption ==
                                          SelectedOption.Need) {
                                        need.latitude = latitude;
                                        need.longitude = longitude;
                                      } else {
                                        donation.latitude = latitude;
                                        donation.longitude = longitude;
                                      }
                                    });
                                    if (_index == 2) {
                                      if ((need.latitude == null ||
                                              need.longitude == null) &&
                                          widget._selectedOption ==
                                              SelectedOption.Need) {
                                        showTheFormAlertWarningDialog(
                                            context,
                                            '(*-*)',
                                            'You have not selected any Location please select a Location');
                                      } else if ((donation.latitude == null ||
                                              donation.longitude == null) &&
                                          widget._selectedOption ==
                                              SelectedOption.Donation) {
                                        showTheFormAlertWarningDialog(
                                            context,
                                            '(*-*)',
                                            'You have not selected any Location please select a Location');
                                      } else {
                                        print('ok hogia');

                                        showTheDeleteConfirmationDialog(
                                            context,
                                            '?',
                                            'Are you sure you want to create this need',
                                            () {
                                          if (widget._selectedOption ==
                                              SelectedOption.Need) {
                                            need.userID = masterData.getUser.id;
                                            masterData.getDioServices
                                                .raiseNeed(need, context);

                                            masterData.loadUpData();
                                            // showTheFormAlertSuccessDialog(context, 'Need Raised',
                                            //     'Your Need has applied for approval successfully and will be updated after the approval.');
                                            Timer(const Duration(seconds: 4),
                                                () {
                                              // Navigator.pushReplacement(context, newRoute)
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            donation.userID =
                                                masterData.getUser.id;

                                            masterData.getDioServices
                                                .raiseDonation(
                                                    donation, context);
                                            masterData.loadUpData();
                                            // showTheFormAlertSuccessDialog(context, 'Donation Raised',
                                            //     'Your Need has applied for approval successfully and will be updated after the approval.');
                                            Timer(const Duration(seconds: 4),
                                                () {
                                              // Navigator.pushReplacement(context, newRoute)
                                              Navigator.pop(context);
                                            });
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: const Text('Get My Current Location')),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5)),
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
                            padding: const EdgeInsets.all(10),
                            buildingsEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            onLongPress: (loc) {
                              setState(() {
                                print('location : ' + loc.toString());
                                if (widget._selectedOption ==
                                    SelectedOption.Need) {
                                  need.latitude = loc.latitude;
                                  need.longitude = loc.longitude;
                                } else {
                                  donation.latitude = loc.latitude;
                                  donation.longitude = loc.longitude;
                                }
                                _markers.add(Marker(
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueGreen),
                                    markerId: const MarkerId('1'),
                                    infoWindow:
                                        const InfoWindow(title: 'Current Need'),
                                    draggable: true,
                                    onDragEnd: (loc) {
                                      print('Prev Lattitude = ' +
                                          latitude.toString() +
                                          ' : Prev Longitude = ' +
                                          longitude.toString());
                                      print('Latest Lattitude = ' +
                                          loc.latitude.toString() +
                                          ' : Latest Longitude = ' +
                                          loc.longitude.toString());
                                      setState(() {
                                        need.latitude = loc.latitude;
                                        need.longitude = loc.longitude;
                                      });
                                    },
                                    position:
                                        LatLng(loc.latitude, loc.longitude)));
                              });
                            },
                            initialCameraPosition: CameraPosition(
                                zoom: 12, target: LatLng(latitude, longitude)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                  ],
                ),
              )
            ],
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
        if (widget._selectedOption == SelectedOption.Need) {
          need.deadLine = _selectedDateTime;
        }
      });
  }
}
