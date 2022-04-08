import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/TestPage";

  final String title;

  @override
  _TestPageState createState() => _TestPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   TestPage.routeName: (BuildContext context) => TestPage(title: "TestPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, TestPage.routeName);
///

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed() {
  }
}