import 'package:flutter/material.dart';
import 'package:xTracker/models/category.dart';
import 'package:xTracker/widget/forms/category_form.dart';

class AddCategory extends StatefulWidget {
  final Category? category;

  const AddCategory({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String type;

  @override
  void initState() {
    super.initState();

    name = widget.category?.name ?? '';
    type = widget.category?.type ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: CategoryFormWidget(
              name: name,
              type: type,
              onChangedName: (name) => setState(() => this.name = name),
              onChangedType: (type) => setState(() => this.type = type)),
        ),
        buildButton()
      ],
    );
  }

  Widget buildButton() {
    final isFormValid = name.isNotEmpty && type.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateCat,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateCat() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.category != null;

      if (isUpdating) {
        await updateCategory();
      } else {
        await addNewCategory();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateCategory() async {
    final category = widget.category!.copy(
      name: name,
      type: type,
    );

    await Category.update(category);
  }

  Future addNewCategory() async {
    final category = Category(
      name: name,
      type: type,
    );
    await Category.create(category);
  }
}
