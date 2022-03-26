import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Container(
          child: Text('Settings Page')
        ),
      )
    );
  }
}

      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       List.generate(settings.length, (index) {
      //         return GestureDetector(
      //           onTap: () {},
      //           child: Container(
      //             child: Text(settings[index]['name']),
      //           ),
      //         );
      //       })
      //     ],
      //   )
      // )
