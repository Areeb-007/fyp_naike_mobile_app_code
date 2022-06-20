
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naike_ui_3/data/models/counter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/helper/string_res.dart';
import '../../ui/screens/bottom_navigation_screen/home_screen.dart';
import '../../ui/screens/detail_screens.dart';
import '../services/dio_services.dart';
import 'categories.dart';
import 'donation.dart';
import 'need.dart';
import 'sub_category.dart';
import 'user.dart';

class MasterData extends Model {
//--------------------------------------------------------- Models -----------------------------------------------------------
  BuildContext context;
  User _user = User(firstName: 'Guest', id: -1);
  DioServices _dioServices = DioServices();
  List<String> _deliveryType = [
    'Select a delivery type',
    'Pick Up',
    'Drop Off',
    'Pick Up and Drop Off'
  ];
  Counter counter;
  List<Categories> _categories = [];
  List<SubCategory> _subCategories = [];
  List<Need> _needsList = [];
  List<Donation> _donationsList = [];
  Set<Marker> _needsMarkers = {};
  Set<Marker> _donationsMarkers = {};
  Set<Marker> _allMarkers = {};
//--------------------------------------------------------- Getters -----------------------------------------------------------
  User get getUser => _user;
  List<Categories> get getListOfCategories => _categories;
  List<SubCategory> get getListOfSubCategories => _subCategories;
  List<Need> get getListOfNeeds => _needsList;
  List<Donation> get getListOfDonations => _donationsList;
  List<String> get getListOfDeliveryType => _deliveryType;
  DioServices get getDioServices => _dioServices;
  Set<Marker> get getNeedsMarkers => _needsMarkers;
  Set<Marker> get getDonationsMarkers => _donationsMarkers;
  Set<Marker> get getAllMarkers => _allMarkers;
//--------------------------------------------------------- Data Loading Functions -----------------------------------------------------------
  void l1() async {
    await loadUpData().whenComplete(() => print('Data Loaded'));
  }

  Future<void> loadUpData() async {
    List<SubCategory> tempList = await _dioServices.getTheSubCategoriesList();
    List<Categories> tempList2 = await _dioServices.getTheCategoriesList();
    await loadUpUser();
    await loadUpNeeds();
    await loadUpDonations();
    _categories.clear();
    _categories.add(Categories(categoryID: 0, name: 'Select a Category'));
    _categories.addAll(tempList2);
    _subCategories.clear();
    _subCategories.add(SubCategory(
        subID: 0, categoryID: 0, name: 'Select a Sub Category', unit: 'unit'));
    _subCategories.addAll(tempList);
    notifyListeners();
  }

  Future<void> loadUpUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey(StringsRes.userIdInSharedPrefs)) {
      _user = await _dioServices.getTheUser(
          int.parse(pref.getString(StringsRes.userIdInSharedPrefs) as String));
      print('User ID : ${pref.getString(StringsRes.userIdInSharedPrefs)}');
      print('User TOKEN : ${pref.getString(StringsRes.tokenInSharedPrefs)}');
      notifyListeners();
    }
  }

//------------------------------------ Load Up Needs -------------------------------------------------------
  Future<void> loadUpNeeds() async {
    _needsList = await _dioServices.getNeedsList();
    for (int i = 0; i < _needsList.length; i++) {
      _needsMarkers.add(Marker(
          markerId: MarkerId(_needsList[i].id.toString()),
          position: LatLng(_needsList[i].latitude!, _needsList[i].longitude!),
          infoWindow: InfoWindow(
              title: _needsList[i].title,
              snippet: _needsList[i].description,
              onTap: () {
                onInfoWindowClicked(_needsList[i].id!, SelectedOption.Need);
              }),
          draggable: false,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
      _allMarkers.add(Marker(
          markerId: MarkerId(_needsList[i].id.toString()),
          position: LatLng(_needsList[i].latitude!, _needsList[i].longitude!),
          infoWindow: InfoWindow(
              title: _needsList[i].title,
              snippet: _needsList[i].description,
              onTap: () {
                onInfoWindowClicked(_needsList[i].id!, SelectedOption.Need);
              }),
          draggable: false,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    }
    notifyListeners();
  }

//------------------------------------ Load Up Donations -------------------------------------------------------
  Future<void> loadUpDonations() async {
    _donationsList = await _dioServices.getDonationsList();
    for (int i = 0; i < _donationsList.length; i++) {
      _donationsMarkers.add(Marker(
          markerId: MarkerId(_donationsList[i].id.toString()),
          position:
              LatLng(_donationsList[i].latitude!, _donationsList[i].longitude!),
          infoWindow: InfoWindow(
              title: _donationsList[i].title,
              snippet: _donationsList[i].description,
              onTap: () {
                onInfoWindowClicked(
                    _donationsList[i].id!, SelectedOption.Donation);
              }),
          draggable: false,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
      _allMarkers.add(Marker(
          markerId: MarkerId(_donationsList[i].id.toString()),
          position:
              LatLng(_donationsList[i].latitude!, _donationsList[i].longitude!),
          infoWindow: InfoWindow(
              title: _donationsList[i].title,
              snippet: _donationsList[i].description,
              onTap: () {
                onInfoWindowClicked(
                    _donationsList[i].id!, SelectedOption.Donation);
              }),
          draggable: false,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    }

    notifyListeners();
  }

//--------------------------------------------------------- change User  -----------------------------------------------------------

  void setUserFirstName(User user) {
    _user = user;
    loadUpData();
    notifyListeners();
  }

//--------------------------------------------------------- On Info Window Clicked  -----------------------------------------------------------
  void onInfoWindowClicked(int id, SelectedOption selectedOption) {
    if (_user.id != -1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(id: id, selectedOption: selectedOption)));
    } else {
      print('Called with id : ' + id.toString());
      showTheLoginAlertErrorDialog(context, 'Login / Singup',
          'You are not logged in. \n Either Login or SgnUp to continue further');
    }
  }

//--------------------------------------------------------- Log Out  -----------------------------------------------------------
  Future<void> logOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(StringsRes.userIdInSharedPrefs);
    pref.remove(StringsRes.tokenInSharedPrefs);
    _user = User(
        id: -1,
        firstName: 'Guest',
        lastName: 'Guest',
        email: '',
        password: '',
        phone: '',
        gender: '',
        dateOfBirth: DateTime.now(),
        emailChecked: false,
        phoneChecked: false);
    notifyListeners();
  }

//--------------------------------------------------------- Constructor -----------------------------------------------------------
  MasterData(this.context, this.counter) {
    this.counter.setCounterValue(0);
    print('Constructor Called');
    // loadUpData().whenComplete(() => print('Completed + ${_user.firstName}'));
    l1();
  }

  //----------------------------------------------------------------------------------------------------------
  String getSubCategoryName(int id) {
    String name = 'SubCategory';
    try {
      name = _subCategories.where((element) => element.subID == id).first.name!;
    } catch (e) {
      print('Error Occured : ' + e.toString());
    }
    return name;
  }

//---------------------------------------------------------------------------------------------------------
  String getCategoryName(int subID) {
    String name = 'Category';
    try {
      int catID = _subCategories
          .where((element) => element.subID == subID)
          .first
          .categoryID!;
      name = _categories
          .where((element) => element.categoryID == catID)
          .first
          .name;
    } catch (e) {
      print('Error Occured : ' + e.toString());
    }
    return name;
  }

//----------------------------------------------------------------------------------------------------------
  List<String> getCategoriesNames() {
    List<String> catNames = [];
    _categories.forEach((element) {
      catNames.add(element.name);
    });
    return catNames;
  }

//----------------------------------------------------------------------------------------------------------
  void addNeed(Need need) {
    _needsList.add(need);
    notifyListeners();
  }

  void addDonation(Donation donation) {
    _donationsList.add(donation);
    notifyListeners();
  }

  void deleteNeed(int id) {
    _needsList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void deleteDonation(int id) {
    _donationsList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateNeed(Need need) {
    int index = _needsList.indexWhere((element) => element.id == need.id);
    _needsList[index] = need;
    notifyListeners();
  }

  void updateDonation(Donation donation) {
    int index =
        _donationsList.indexWhere((element) => element.id == donation.id);
    _donationsList[index] = donation;
    notifyListeners();
  }

//----------------------------------------------------------------------------------------------------------
  String getSubCategoryNameBasedOnId(int id) {
    return _subCategories.where((subCat) => subCat.subID == id).first.name!;
  }
//----------------------------------------------------------------------------------------------------------

  int getCategoryID(String catName) {
    return _categories.where((cat) => cat.name == catName).first.categoryID;
  }

//----------------------------------------------------------------------------------------------------------
  Need getNeedBasedOnID(int id) {
    return _needsList.where((element) => element.id == id).first;
  }

//----------------------------------------------------------------------------------------------------------
  Donation getDonationBasedOnID(int id) {
    return _donationsList.where((element) => element.id == id).first;
  }

//----------------------------------------------------------------------------------------------------------
  List<String> getSubCategoriesNames(String catName) {
    List<String> subCatNames = [];
    int catID = _categories
        .where((element) => element.name == catName)
        .first
        .categoryID;
    _subCategories.forEach((element) {
      if (element.categoryID == catID) {
        subCatNames.add(element.name!);
      }
    });
    return subCatNames;
  }

  void showTheLoginAlertErrorDialog(BuildContext context, String s, String t) {}
}
