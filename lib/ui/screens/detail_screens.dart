import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/donation.dart';
import '../../data/models/master_data.dart';
import '../../data/models/need.dart';
import '../../data/models/user.dart';
import '../helper/colors_res.dart';
import '../widgets/details_text_fields.dart';
import '../widgets/form_dialogue.dart';
import 'bottom_navigation_screen/home_screen.dart';

class DetailScreen extends StatefulWidget {
  int id;

  SelectedOption selectedOption;
  late GoogleMapController _googleMapController;
  DetailScreen({required this.id, required this.selectedOption});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late User temp1;
  User temp = User(
      id: 12,
      firstName: 'firstName',
      lastName: 'lastName',
      email: 'email',
      password: 'password',
      phone: 'phone',
      gender: 'gender',
      dateOfBirth: DateTime.now(),
      emailChecked: false,
      phoneChecked: false);
  Set<Marker> _markers = {};
  final _formKey = GlobalKey<FormState>();
  Future<void> getNeedInfo() async {}

  Need need = Need();
  Donation donation = Donation();

  @override
  void initState() {
    super.initState();
  }

  void initializeController(GoogleMapController controller) {
    widget._googleMapController = controller;
    setState(() {
      print('Setting state');
      _markers.add(Marker(
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //     BitmapDescriptor.hueGreen),
          markerId: MarkerId(
            widget.selectedOption == SelectedOption.Need
                ? need.id.toString()
                : donation.id.toString(),
          ),
          infoWindow: InfoWindow(
              title: widget.selectedOption == SelectedOption.Need
                  ? need.title
                  : donation.title,
              snippet: widget.selectedOption == SelectedOption.Need
                  ? need.description
                  : donation.description),
          // infoWindow: InfoWindow(title: need.title),
          position: LatLng(
              widget.selectedOption == SelectedOption.Need
                  ? need.latitude!
                  : donation.latitude!,
              widget.selectedOption == SelectedOption.Need
                  ? need.longitude!
                  : donation.longitude!)));
      print('Length 1 ' + _markers.length.toString());
    });
    print('latitude of details : ' +
        _markers.first.position.latitude.toString() +
        ' ' +
        _markers.first.position.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedOption == SelectedOption.Need) {
      need = ScopedModel.of<MasterData>(context).getNeedBasedOnID(widget.id);
    } else {
      donation =
          ScopedModel.of<MasterData>(context).getDonationBasedOnID(widget.id);
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsRes.appcolor,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (widget.selectedOption == SelectedOption.Need
                              ? 'Need'
                              : 'Donation') +
                          ' Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.appcolor,
                      ),
                    ),
                    Divider(
                      height: 12,
                      thickness: 3,
                      color: ColorsRes.txtdarkcolor,
                    ),
                    detailsTextField(
                        Icon(
                          Icons.title,
                          color: ColorsRes.appcolor,
                        ),
                        'Title',
                        widget.selectedOption == SelectedOption.Need
                            ? need.title!
                            : donation.title!,
                        1),
                    detailsTextField(
                        Icon(
                          Icons.description,
                          color: ColorsRes.appcolor,
                        ),
                        'Description',
                        widget.selectedOption == SelectedOption.Need
                            ? need.description!
                            : donation.description!,
                        widget.selectedOption == SelectedOption.Need
                            ? ((need.description!.length) / 20).round() == 0
                                ? 1
                                : ((need.description!.length) / 20).round()
                            : (donation.description!.length / 20).round() == 0
                                ? 1
                                : ((donation.description!.length) / 20)
                                    .round()),
                    detailsTextField(
                        Icon(
                          Icons.upload,
                          color: ColorsRes.appcolor,
                        ),
                        'Uploaded',
                        widget.selectedOption == SelectedOption.Need
                            ? DateFormat.yMMMMd('en_US').format(need.createdOn!)
                            : DateFormat.yMMMMd('en_US')
                                .format(donation.createdOn!),
                        1),
                    widget.selectedOption == SelectedOption.Need
                        ? detailsTextField(
                            Icon(
                              Icons.date_range,
                              color: ColorsRes.appcolor,
                            ),
                            'Due Date',
                            DateFormat.yMMMMd('en_US').format(need.deadLine!),
                            1)
                        : Container(),
                    detailsTextField(
                        Icon(
                          Icons.production_quantity_limits,
                          color: ColorsRes.appcolor,
                        ),
                        'Initial Quantity',
                        widget.selectedOption == SelectedOption.Need
                            ? need.initialQuantity.toString()
                            : donation.initialQuantity.toString(),
                        1),
                    detailsTextField(
                        Icon(
                          Icons.production_quantity_limits,
                          color: ColorsRes.appcolor,
                        ),
                        'Current Quantity',
                        widget.selectedOption == SelectedOption.Need
                            ? need.currentQuantity.toString()
                            : donation.currentQuantity.toString(),
                        1),

                    detailsTextField(
                        Icon(
                          Icons.category,
                          color: ColorsRes.appcolor,
                        ),
                        'Category',
                        ScopedModel.of<MasterData>(context).getCategoryName(
                            widget.selectedOption == SelectedOption.Need
                                ? need.subID!
                                : donation.subID!),
                        1),
                    detailsTextField(
                        Icon(
                          Icons.subdirectory_arrow_right,
                          color: ColorsRes.appcolor,
                        ),
                        'Subcategory',
                        ScopedModel.of<MasterData>(context).getSubCategoryName(
                            widget.selectedOption == SelectedOption.Need
                                ? need.subID!
                                : donation.subID!),
                        1),
                    detailsTextField(
                        Icon(
                          Icons.wheelchair_pickup,
                          color: ColorsRes.appcolor,
                        ),
                        'Delivery Type',
                        widget.selectedOption == SelectedOption.Need
                            ? need.deliveryType!
                            : donation.deliveryType!,
                        1),

                    SizedBox(
                      height: 30,
                    ),

                    // ---------------------------- USER INFO ----------------------------
                    Text(
                      ('User' + ' Details'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.appcolor,
                      ),
                    ),
                    Divider(
                      height: 12,
                      thickness: 3,
                      color: ColorsRes.txtdarkcolor,
                    ),
                    detailsTextField(
                        Icon(
                          Icons.person,
                          color: ColorsRes.appcolor,
                        ),
                        'Name',
                        widget.selectedOption == SelectedOption.Need
                            ? ((need.user!.firstName ?? '') +
                                ' ' +
                                (need.user!.lastName ?? ''))
                            : ((donation.user!.firstName ?? '') +
                                ' ' +
                                (donation.user!.lastName ?? '')),
                        1),
                    detailsTextField(
                        Icon(
                          Icons.contact_mail,
                          color: ColorsRes.appcolor,
                        ),
                        'Email',
                        widget.selectedOption == SelectedOption.Need
                            ? need.user!.email ?? ''
                            : donation.user!.email ?? '',
                        1),
                    detailsTextField(
                        Icon(
                          Icons.contact_phone,
                          color: ColorsRes.appcolor,
                        ),
                        'Phone',
                        widget.selectedOption == SelectedOption.Need
                            ? need.user!.phone ?? ''
                            : donation.user!.phone ?? '',
                        1),
                    detailsTextField(
                        Icon(
                          Icons.person,
                          color: ColorsRes.appcolor,
                        ),
                        'Gender',
                        widget.selectedOption == SelectedOption.Need
                            ? need.user!.gender ?? ''
                            : donation.user!.gender ?? '',
                        1),
                    SizedBox(
                      height: 30,
                    ),

                    // ---------------------------- LOCATION ----------------------------
                    Text(
                      ('Location'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.appcolor,
                      ),
                    ),
                    Divider(
                      height: 12,
                      thickness: 3,
                      color: ColorsRes.txtdarkcolor,
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: ColorsRes.appcolor,
                            width: 4,
                          )),
                      height: MediaQuery.of(context).size.height * 0.40,
                      child: GoogleMap(
                        onMapCreated: initializeController,
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                        markers: _markers,
                        onLongPress: (loc) {
                          setState(() {
                            print('Length 2 ' + _markers.length.toString());
                            print('user ' + temp.firstName!);
                            _markers.add(Marker(
                                markerId: MarkerId('asd'),
                                position: LatLng(loc.latitude, loc.longitude)));
                          });
                        },
                        padding: EdgeInsets.all(10),
                        buildingsEnabled: true,
                        zoomControlsEnabled: false,
                        // mapType: MapType.hybrid,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                            zoom: 12,
                            target: LatLng(
                                widget.selectedOption == SelectedOption.Need
                                    ? need.latitude!
                                    : donation.latitude!,
                                widget.selectedOption == SelectedOption.Need
                                    ? need.longitude!
                                    : donation.longitude!)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsRes.appcolor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          print('Clicked');
                          if (widget.selectedOption == SelectedOption.Need) {
                            showTheHelpDialog(
                                context, '', '', need.currentQuantity!);
                          } else {
                            showTheHelpDialog(
                                context, '', '', donation.currentQuantity!);
                          }
                        },
                        icon: Icon(Icons.person),
                        label: Text('Help'))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
