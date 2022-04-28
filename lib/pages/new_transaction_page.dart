// import 'package:flutter/material.dart';

// class AddTransactionPage extends StatelessWidget {
//   const AddTransactionPage({
//     Key? key,
//     this.type,
//   }) : super(key: key);
//   final type;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Add ' + type),
//         ),
//         body: Center(
//           child: Container(child: Text(this.type + 'Page')),
//         ));
//   }
// }


// New transaction manages the adding item part

import 'package:flutter/material.dart';
import '../theme/colors.dart';

import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  /* late String titleInput;
  late String amountInput; */
  // late means assigning value to that var later

  final Function addTx;
  // to accept the execution function from user_transactions

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  // TextEditingController takes and saves every letter user Types

  DateTime _selectedDate = DateTime(2018);

  void _onSubmit() {
    final text = _titleController.text;
    final amount = double.parse(_amountController.text);
    // double.parse() because that function takes amount in double not string, so converted,
    // if not convertable then it thrown an error

    if (text.isEmpty || amount <= 0 || _selectedDate == DateTime(2022)) {
      return;
    }

    widget.addTx(text, amount, _selectedDate, 1, 1, 1);
    // widget. means importing the function addTx from NewTransaction class above to _NewTransactionState class

    Navigator.of(context).pop();
    // this closes the pop up sheet after submitting values automatically
  }

  void _presentDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // then() checks for user input, code doesnt stop also if user input nothing
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // so you can scroll the modal sheet when keyboard is popped up
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          // this gives extra 10pixels of space after taking the space for the keyboard to fit on the modal sheet
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                // for IOS use CupertinoTextField
                decoration: InputDecoration(labelText: 'Title'),
                cursorColor: Colors.green,
                enableInteractiveSelection: true,
                // this is for enabling copy paste and select text options on phone

                /* onChanged: (val) => titleInput = val, */
                // onchanged records every keystroke, and im saving it into a string

                // or,
                controller: _titleController,
                // automatically saves input , title controller defined above takes TextEditingController

                onSubmitted: (_) => _onSubmit(),
                // (_) => cause onSubmitted takes an argument function but we dont need arg so using _, means arg is there
                // but I dont need it.
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                // for only number keyboard
                //in case of IOS use => TextInputType.numberWithOptions(decimal:true)

                /* onChanged: (val) => amountInput = val, */

                controller: _amountController,

                onSubmitted: (_) => _onSubmit(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == DateTime(2022)
                            ? DateTime.now().toString()
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                            // : _selectedDate.toString(),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    MaterialButton(
                      // for ios you can implement Cupertino Button using if else
                      onPressed: _presentDate,
                      child: Text(
                        'Choose date',
                        style: TextStyle(
                          color: primary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              MaterialButton(
                // for ios you can implement Cupertino Button using if else
                color: primary,
                child: const Text(
                  'Add Item',
                ),
                textColor: Colors.white,
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
