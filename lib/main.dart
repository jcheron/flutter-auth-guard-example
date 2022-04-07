import 'package:auth_guard/auth_guard.dart';
import 'package:auth_guard/authentication.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationProvider(
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => _authGuard(context, HomeScreen()),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
  _authGuard(BuildContext context,Widget page){
    return AuthGuard(
      loadingScreen: LoadingScreen(),
      unauthenticatedHandler: (BuildContext context) => Navigator.of(context).pushReplacementNamed('/login'),
      authenticationStream: AuthenticationProvider.of(context)?.user()
          .map((user) => user == null ? AuthGuardStatus.notAuthenticated : AuthGuardStatus.authenticated),
      child: page,

    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Home screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () => AuthenticationProvider.of(context)?.logout(),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () {
              AuthenticationProvider.of(context)?.login();
              Navigator.of(context).pushReplacementNamed('/');
            },
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      );
  }
}

