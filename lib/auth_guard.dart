import 'dart:async';
import 'package:flutter/material.dart';

enum AuthGuardStatus {
  authenticated,
  notAuthenticated,
}

typedef void AuthGuardUnauthenticatedHandler (BuildContext context);

class AuthGuard extends StatefulWidget {
  final Widget child;
  final Widget loadingScreen;
  final AuthGuardUnauthenticatedHandler unauthenticatedHandler;
  final Stream<AuthGuardStatus>? authenticationStream;

  AuthGuard({
      required this.child,
      required this.loadingScreen,
      required this.unauthenticatedHandler,
      required this.authenticationStream,
    }) {
  }

  @override
  _AuthGuardState createState() {
    return new _AuthGuardState();
  }
}

class _AuthGuardState extends State<AuthGuard> {
  late StreamSubscription<AuthGuardStatus>? _subscription;
  late Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = widget.loadingScreen;
    _subscription = widget.authenticationStream?.listen(_onAuthenticationChange);
  }

  @override
  void dispose() {
    super.dispose();
    print('Dispose');
     _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthGuardStatus>(
      stream: widget.authenticationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          currentWidget = widget.loadingScreen;
          return currentWidget;
        } else if (snapshot.data == AuthGuardStatus.authenticated) {
          currentWidget = widget.child;
        }
        return currentWidget;
      },
    );
  }

  _onAuthenticationChange(AuthGuardStatus status) {
    if (status == AuthGuardStatus.notAuthenticated) {
      widget.unauthenticatedHandler(context);
    }
  }
}
