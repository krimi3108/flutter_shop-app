import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/httpException.dart';

enum AuthMode { signup, login }

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _logoutTimer;

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return _token != null;
  }

  Future<void> _authenticate(
      String email, String password, AuthMode mode) async {
    const APIKey = "[Your-API-Key]";
    final endpoint = mode == AuthMode.signup ? "signUp" : "signInWithPassword";
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$endpoint?key=$APIKey";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        HttpExpcetion(responseData["error"]["message"]);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();

      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });
      pref.setString("userData", userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> logIn(String email, String password) {
    return _authenticate(email, password, AuthMode.login);
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, AuthMode.signup);
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(pref.getString("userData"));
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear(); // to clear all the data from prefrence otherwise do it individually.
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
