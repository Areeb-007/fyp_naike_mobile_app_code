import 'dart:async';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/helper/string_res.dart';
import '../../ui/screens/landing_page.dart';
import '../../ui/widgets/form_dialogue.dart';
import '../models/categories.dart';
import '../models/donation.dart';
import '../models/master_data.dart';
import '../models/need.dart';
import '../models/sub_category.dart';
import '../models/user.dart';
import 'alert_dialogue.dart';

class DioServices {
  late Dio _dio;
  late BuildContext _context;
  late String message = '';
  late String _token = '';
  DateTime? _expireTime;
  final String LOGIN_USER_PATH = '/v1/auth/login';
  final String CREATE_NEED = '/v1/need/';
  final String GET_NEEDS_USER = '/v1/need/';
  final String DELETE_NEED = '/v1/need/';
  final String UPDATE_NEED = '/v1/need/';
  final String GET_NEEDS_GUEST = '/v1/guest/need';
  final String GET_NEEDS_BY_USER_ID = '/v1/need/user/';
  final String CREATE_DONATION = '/v1/donation';
  final String GET_DONATIONS_USER = '/v1/donation/';
  final String GET_DONATIONS_GUEST = '/v1/guest/donation';
  final String GET_DONATIONS_BY_USER_ID = '/v1/donation/user/';
  final String UPDATE_DONATION = '/v1/donation/';
  final String DELETE_DONATION = '/v1/donation/';
  final String GET_CATEGORIES = '/v1/category/';
  final String GET_SUB_CATEGORIES = '/v1/subcategory/';
  final String LOGIN_FAKE_API_TESTING = 'https://reqres.in//api/login';
  final String REGISTER_USER_PATH = '/register';
  final String GET_USER_BY_ID = '/v1/user/';
  final String mujtabaApiUrl = 'http://192.168.18.118:3000/areeb';

  //-------------------------------- Constructor ----------------------------------//

  DioServices() {
    _dio = Dio(BaseOptions(
        baseUrl: 'https://naike.herokuapp.com', connectTimeout: 30000));
    initializeToken();
    initializeInterceptors();
  }
  //-------------------------------- Initialize TOKEN ----------------------------------//
  void initializeToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(StringsRes.tokenInSharedPrefs)) {
      _token = pref.getString(StringsRes.tokenInSharedPrefs)!;
      print('Token from the DIO SERVICES COnstructor : ' + _token);
    }
  }

  //-------------------------------- Interceptors ----------------------------------//

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(

        // Error Interceptor

        onError: (error, handler) {
      print('On Error Called from the Interceptors');
      // print('Error : ' + error.message.toString());

      // print(error.error);
      // apiResponse.error = true;
      // apiResponse.errorMessage = error.message.toString();
      switch (error.type) {
        case DioErrorType.cancel:
          message = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          message = "Connection timeout with API server";
          break;
        case DioErrorType.other:
          print('Message' + error.message);
          message =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          message = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          print(error.response!.data);
          message =
              _handleError(error.response!.statusCode, error.response!.data);
          break;
        case DioErrorType.sendTimeout:
          message = "Send timeout in connection with API server";
          break;
        default:
          message = "Something went wrong";
          break;
      }

      return handler.next(error);
    },

        // Request Interceptor

        onRequest: (request, handler) {
      print('On Request Called from the Interceptors');
      print('Request Path : ' + request.path);
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token'
      };
      print('Bearer $_token');
      request.headers = headers;
      return handler.next(request);
    },

        // Response Interceptor

        onResponse: (response, handler) {
      // print('On Response Called from the Interceptors');
      // print('Response data : ' + response.data.toString());
      return handler.next(response);
    }));
  }

  //-------------------------------- Handle Error --------------------------------//
  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Request Failed';
      case 401:
        return 'Bad Request';
      case 403:
        return error["error"];
      case 404:
        return error["error"] == null ? 'Not Found' : error['error'];
      case 500:
        return 'Internal server error';
      case 502:
        return error["error"];
      default:
        return 'Oops something went wrong';
    }
  }
  //-------------------------------- Login User ----------------------------------//

  Future<bool> loginUser(BuildContext context, bool rememberMe) async {
    _context = context;

    bool status = false;
    try {
      // var formData =
      //     FormData.fromMap({'email': user.email, 'password': user.password});
      Map<String, dynamic> data = {
        "email": "${ScopedModel.of<MasterData>(context).getUser.email}",
        "password": "${ScopedModel.of<MasterData>(context).getUser.password}"
      };

      // print(data);
      Response response =
          await _dio.post(_dio.options.baseUrl + LOGIN_USER_PATH, data: data);
      var tokenData = response.data['Data']['token'];
      var userData = response.data['Data']['data'];
      print(userData);
      User user1 = User.fromJson(userData);
      // print(user1.firstName);
      // print(user1.id);
      _token = tokenData['access_token'];
      // print('Token Data : ' + _token);
      _expireTime =
          (DateTime.fromMillisecondsSinceEpoch(tokenData['exp'] * 1000));
      // print(_expireTime);
      if (rememberMe) {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString(StringsRes.userIdInSharedPrefs, user1.id.toString());
        pref.setString(StringsRes.tokenInSharedPrefs, _token);
      }
      // showTheFormAlertSuccessDialog(
      //     context, 'Success', 'Successfully Logged In');

      ScopedModel.of<MasterData>(
        context,
      ).setUserFirstName(user1);
      Navigator.pop(context);
      // apiResponse.data = _token;
      // apiResponse.error = false;
      // apiResponse.errorMessage = '';
      status = true;
    } on DioError catch (_) {
      print('Landed on the login catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
      status = false;
      return false;
    }
    return status;
  }

  //-------------------------------- Register User ----------------------------------//
  Future<bool> registerUser(User user, BuildContext context) async {
    _context = context;
    bool status = false;
    try {
      Map<String, dynamic> data = {
        "user": {
          "firstName": user.firstName,
          "lastName": user.lastName,
          "email": user.email,
          "password": user.password,
          "phone": user.phone,
          "gender": user.gender,
          "dateOfBirth":
              DateFormat('yyyy-MM-dd HH:mm:ss').format(user.dateOfBirth!),
        },
      };

      Response response = await _dio
          .post(_dio.options.baseUrl + REGISTER_USER_PATH, data: data);
      // print(response.data);

      // sleep(const Duration(seconds: 5));
      status = true;
    } on DioError catch (_) {
      print('Landed on the sigunUp catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return status;
  }

//-------------------------------- Get the User Data ----------------------------------//
  Future<User> getTheUser(int id) async {
    User user = User(
        id: 1,
        firstName: 'Anas',
        lastName: 'Ahmed',
        email: 'email@gmail.com',
        password: '123',
        phone: '090078601',
        gender: 'Male',
        dateOfBirth: DateTime.now(),
        emailChecked: false,
        phoneChecked: false);
    try {
      Response response =
          await _dio.get(_dio.options.baseUrl + GET_USER_BY_ID + '$id');
      print(response.data['Data']);
      user = User.fromJson(response.data['Data']['data']);
      // var currentUser = response.data['data'];
      // Image img;
      // print('User ID : $id');

      // user = User.fromJson(currentUser)

    } on DioError catch (_) {
      print('Landed on the Get User catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return user;
  }

  //-------------------------------- Get the Categories List Data ----------------------------------//
  Future<List<Categories>> getTheCategoriesList() async {
    List<Categories> categories = [
      // Categories(categoryID: 1, name: 'Food'),
      // Categories(categoryID: 2, name: 'Clothes'),
      // Categories(categoryID: 3, name: 'Education'),
    ];
    try {
      Response response = await _dio.get(_dio.options.baseUrl + GET_CATEGORIES);
      // print(response.data);
      Iterable l = response.data['Data']['data'];
      categories =
          List<Categories>.from(l.map((model) => Categories.fromJson(model)));
      // print(categories[0].name);
    } on DioError catch (_) {
      print('Landed on the Get Categories catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return categories;
  }

//-------------------------------- Get the Needs List + CRUD ----------------------------------//
  Future<void> raiseNeed(Need need, BuildContext context) async {
    _context = context;

    try {
      // var formData =
      //     FormData.fromMap({'email': user.email, 'password': user.password});
      Map<String, dynamic> data = {
        "userID": need.userID,
        "subCategoryID": need.subID,
        "donationID": null,
        "description": need.description,
        "deadline": need.deadLine.toString(),
        "longitude": need.longitude,
        "latitude": need.latitude,
        "deliveryType": need.deliveryType,
        "initialQuantity": need.initialQuantity,
        "currentQuantity": need.currentQuantity,
        "title": need.title
      };
      print(data);
      Response response =
          await _dio.post(_dio.options.baseUrl + CREATE_NEED, data: data);
      showTheFormAlertSuccessDialog(
          context, 'Raised', 'Need raised successfully');

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute<void>(
      //       builder: (BuildContext context) => LandingPage()),
      //   ModalRoute.withName(LandingPage.pageRoute),
      // );
      Timer(Duration(seconds: 4), () {
        // Navigator.pushReplacement(context, newRoute)
        Navigator.pop(context);
      });

      // print(response.data);
      // print(response.data['token']);
      // _token = response.data['token'];

      // apiResponse.data = _token;
      // apiResponse.error = false;
      // apiResponse.errorMessage = '';
      // status = true;

    } on DioError catch (_) {
      print('Landed on the need create catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
      // status = false;
    }
  }

  Future<List<Need>> getNeedsList() async {
    List<Need> needs = [];
    try {
      Response response = await _dio.get(_dio.options.baseUrl +
          (_token == '' ? GET_NEEDS_GUEST : GET_NEEDS_USER));

      Iterable L = response.data['Data']['data'];

      print('FROM NEEDS : ' + response.data.toString());
      needs = List<Need>.from(L.map((model) => Need.fromJson(model)));
      // print(needs[0].id);
    } on DioError catch (_) {
      print('Landed on the Get Needs catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return needs;
  }

  Future<List<Need>> getNeedsListByUserID(int id) async {
    List<Need> temp = [];
    try {
      Response response =
          await _dio.get(_dio.options.baseUrl + GET_NEEDS_BY_USER_ID + '$id');
      // print(response.data);
      Iterable L = response.data['Data']['data'];

      temp = List<Need>.from(L.map((model) => Need.fromJson(model)));
      // print(temp[0].id);
    } on DioError catch (_) {
      print('Landed on the Get Needs List By ID catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return temp;
  }

  Future<void> updateNeed(Need need, BuildContext context) async {
    try {
      Map<String, dynamic> data = {
        "userID": need.userID,
        "subCategoryID": need.subID,
        "donationID": null,
        "description": need.description,
        "deadline": need.deadLine.toString(),
        "longitude": need.longitude,
        "latitude": need.latitude,
        "deliveryType": need.deliveryType,
        "initialQuantity": need.initialQuantity,
        "currentQuantity": need.currentQuantity,
        "title": need.title
      };
      Response response = await _dio
          .put(_dio.options.baseUrl + UPDATE_NEED + '${need.id}', data: data);
      // print(response.data);
      showTheFormAlertSuccessDialog(context, 'Updated', 'Successfully Updated');
    } on DioError catch (_) {
      print('Landed on the Update Need catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
  }

  Future<void> deleteNeed(int id) async {
    try {
      Response response =
          await _dio.patch(_dio.options.baseUrl + DELETE_NEED + '$id');
      // print(response.data);

    } on DioError catch (_) {
      print('Landed on the Delete Need catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
  }

//-------------------------------- Get the Donation List Data + CRUD ----------------------------------//
  Future<void> raiseDonation(Donation donation, BuildContext context) async {
    _context = context;

    try {
      // var formData =
      //     FormData.fromMap({'email': user.email, 'password': user.password});
      Map<String, dynamic> data = {
        "userID": donation.userID,
        "subCategoryID": donation.subID,
        "description": donation.description,
        "longitude": donation.longitude,
        "latitude": donation.latitude,
        "deliveryType": donation.deliveryType,
        "initialQuantity": donation.initialQuantity,
        "currentQuantity": donation.currentQuantity,
        "title": donation.title
      };
      print(data);
      Response response =
          await _dio.post(_dio.options.baseUrl + CREATE_DONATION, data: data);
      showTheFormAlertSuccessDialog(
          context, 'Raised', 'Donation raised successfully');
      Timer(Duration(seconds: 4), () {
        // Navigator.pushReplacement(context, newRoute)
        Navigator.pop(context);
      });
    } on DioError catch (_) {
      print('Landed on the donation create catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
      // status = false;
    }
  }

  Future<List<Donation>> getDonationsList() async {
    List<Donation> donations = [];
    try {
      Response response = await _dio.get(_dio.options.baseUrl +
          (_token == '' ? GET_DONATIONS_GUEST : GET_DONATIONS_USER));

      Iterable L = response.data['Data']['data'];
      print(L.toList());
      donations =
          List<Donation>.from(L.map((model) => Donation.fromJson(model)));
    } on DioError catch (_) {
      print('Landed on the Get User catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return donations;
  }

  Future<List<Donation>> getDonationsListByUserID(int id) async {
    List<Donation> donations = [];
    try {
      Response response = await _dio
          .get(_dio.options.baseUrl + GET_DONATIONS_BY_USER_ID + '$id');

      Iterable L = response.data['Data']['data'];
      print(L.toList());
      donations =
          List<Donation>.from(L.map((model) => Donation.fromJson(model)));
    } on DioError catch (_) {
      print('Landed on the Get User catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return donations;
  }

  Future<void> updateDonation(Donation donation, BuildContext context) async {
    try {
      Map<String, dynamic> data = {
        "userID": donation.userID,
        "subCategoryID": donation.subID,
        "donationID": null,
        "description": donation.description,
        "longitude": donation.longitude,
        "latitude": donation.latitude,
        "deliveryType": donation.deliveryType,
        "initialQuantity": donation.initialQuantity,
        "currentQuantity": donation.currentQuantity,
        "title": donation.title
      };
      Response response = await _dio.put(
          _dio.options.baseUrl + UPDATE_DONATION + '${donation.id}',
          data: data);
      // print(response.data);
      showTheFormAlertSuccessDialog(context, 'Updated', 'Successfully Updated');
    } on DioError catch (_) {
      print('Landed on the Update Donation catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
  }

  Future<void> deleteDonation(int id) async {
    try {
      Response response =
          await _dio.patch(_dio.options.baseUrl + DELETE_DONATION + '$id');
      // print(response.data);

    } on DioError catch (_) {
      print('Landed on the Delete Donation catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
  }

  //-------------------------------- Get the SubCategories List Data ----------------------------------//
  Future<List<SubCategory>> getTheSubCategoriesList() async {
    List<SubCategory> subCategories = [
      // SubCategory(
      //     subID: 1, categoryID: 1, name: 'Lunch', unit: 'Persons', maxLimit: 5),
      // SubCategory(
      //     subID: 2,
      //     categoryID: 1,
      //     name: 'Dinner',
      //     unit: 'Persons',
      //     maxLimit: 5),
      // SubCategory(
      //     subID: 3,
      //     categoryID: 2,
      //     name: 'Shirts',
      //     unit: 'Persons',
      //     maxLimit: 5),
      // SubCategory(
      //     subID: 4, categoryID: 2, name: 'Pants', unit: 'Persons', maxLimit: 5),
      // SubCategory(
      //     subID: 5,
      //     categoryID: 3,
      //     name: 'School Fee',
      //     unit: 'Rupees',
      //     maxLimit: 5),
    ];
    try {
      Response response =
          await _dio.get(_dio.options.baseUrl + GET_SUB_CATEGORIES);
      // print(response.data);
      Iterable l = response.data['Data']['data'];
      subCategories =
          List<SubCategory>.from(l.map((model) => SubCategory.fromJson(model)));
      print('SUB NAME : ' + subCategories[0].name!);
      // print(l.toList());
    } on DioError catch (_) {
      print('Landed on the Get User catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return subCategories;
  }

  //--------------------------------------- Help against the Need ---------------------------------------
  Future<void> helpTheNeed(int userID, int itemID, double quantity) async {
    try {
      Map<String, dynamic> data = {
        "userID": userID,
        "needID": itemID,
        "quantity": quantity,
      };
      // Response response =
      //     await _dio.get(_dio.options.baseUrl + GET_SUB_CATEGORIES);
      // print(response.data);

    } on DioError catch (_) {
      print('Landed on the Get User catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
  }
}
