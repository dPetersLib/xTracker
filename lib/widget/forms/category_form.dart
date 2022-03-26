import 'package:flutter/material.dart';

class CategoryFormWidget extends StatelessWidget {
  
/*
  final List<String> tType = ['Income', 'Expense'];
  final List<Icon> tIcons = [
    Icon(Icons.settings),
    Icon(Icons.mail),
    Icon(Icons.face),
    Icon(Icons.folder),
    Icon(Icons.offline_bolt),
    Icon(Icons.u_turn_left),
  ];

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
*/
  final String? name;
  final String? type;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedType;

  const CategoryFormWidget({
    Key? key,
    this.name = '',
    this.type = '',
    required this.onChangedName,
    required this.onChangedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            buildName(),
            SizedBox(height: 8),
            buildType(),
            SizedBox(height: 10),
          ],
        ),
      );

  Widget buildName() => TextFormField(
        maxLines: 1,
        initialValue: name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter Category Name',
        ),
        validator: (name) => name != null && name.isEmpty
            ? 'Enter a name for the category'
            : null,
        onChanged: onChangedName,
      );

  Widget buildType() => TextFormField(
        maxLines: 1,
        initialValue: name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter Category Type',
        ),
        validator: (name) => name != null && name.isEmpty
            ? 'Enter a type for the cat'
            : null,
        onChanged: onChangedType,
      );
}


