import 'package:auth_guard/TestPage.dart';
import 'package:auth_guard/auth_guard.dart';
import 'package:auth_guard/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const config = FirebaseOptions(
      apiKey: "AIzaSyDdKeyBpLjNC3kcuWBA0q71pb5_6H_-kVA",
      appId: "1:61739335634:web:97eca1c57e6b3dd3abd20b",
      messagingSenderId: "61739335634",
      projectId: "my-test-df16f"
  );
  await Firebase.initializeApp(options: config);

//  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static connect(String email,String password,BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      //User is ok, so log in
      AuthenticationProvider.of(context)?.login(credential.user);
      Navigator.of(context).pushReplacementNamed('/');

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationProvider(
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => _authGuard(context, HomeScreen()),
          '/login': (context) => LoginScreen(),
          '/test': (context) => _authGuard(context, TestPage(title: 'Route de test')),
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
          child: Text('Logout ${FirebaseAuth.instance.currentUser?.email}'),
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
            MyApp.connect('no@email.com','azerty1234',context);
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

