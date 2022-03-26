import '../pages/root_app.dart';
import 'package:flutter/material.dart';
import '../pages/settings_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    home: Main(),
  ));
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('xTracker'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage())
              );
            },
            icon: const Icon(Icons.settings),
            color: Colors.white,
            )
        ],
      ),
      body: RootApp(),
    );
  }
}