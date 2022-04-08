import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class AuthenticationService {
  final _userController = ReplaySubject<User?>(maxSize: 1);

  AuthenticationService() {
    Future.delayed(Duration(seconds: 10)).then((value) => _userController.add(null)); //Simulate loading
  }

  void login(User? connectedUser) {
    _userController.sink.add(connectedUser);
  }

  void logout() {
    _userController.sink.add(null);
  }

  Stream<User?> user() {
    return _userController.asBroadcastStream();
  }

  dispose() {
    _userController.sink.close();
  }
}
class AuthenticationProvider extends InheritedWidget {
  final service = AuthenticationService();
  AuthenticationProvider({Key? key, child}) : super(key: key, child: child);

  static AuthenticationService? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationProvider>())?.service;
  }

  @override
  bool updateShouldNotify( AuthenticationProvider oldWidget) {
    return true;
  }
}