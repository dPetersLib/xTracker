import '../json/transaction_type_json.dart';
import '../models/transaction.dart';
import '../models/txtype.dart';
import '../pages/budget_page.dart';
import '../pages/create_budge_page.dart';
import '../pages/daily_page.dart';
import '../pages/new_transaction_page.dart';
import '../pages/profile_page.dart';
import '../pages/settings_page.dart';
import '../pages/stats_page.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  // WidgetsBindingObserver is used for checking app State
  // final List<Transaction> _utransactions = [];
  late List<TxType> txtypes;
  bool isLoading = false;

  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    BudgetPage(),
    ProfilePage(),
  ];

  Future refreshTxType() async {
    setState(() => isLoading = true);

    txtypes = await TxType.readAllTypes();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTxType();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // selectedTab(4);
              _newTransactionType(context);
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
            backgroundColor: primary
            //params
            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_stats,
      Ionicons.md_wallet,
      Ionicons.ios_person,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }

  Future _addTransaction(String txtitle, int amount, DateTime selectedDate,
      int typeId, int catId, int accId, int currId) async {
    final newTrans = Transaction(
        description: txtitle,
        amount: amount,
        // id: DateTime.now().toString(),
        date: selectedDate,
        typeId: typeId,
        categoryId: catId,
        accountId: accId,
        currencyId: currId);

    await Transaction.create(newTrans);
    refreshTxType();

    // setState(() {
    //   _utransactions.add(newTrans);
    // });
  }

  void _newTransactionType(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'New Transaction',
            textAlign: TextAlign.center,
          ),
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(txtypes.length, (index) {
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        // color: Color(txtypes[index].color),
                        color: Color(0xFFFF9000),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(txtypes[index].type,
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              txtypes[index].type,
                              textAlign: TextAlign.center,
                            ),
                            content: NewTransaction(
                                _addTransaction, txtypes[index].id),
                          );
                        });
                    // showModalBottomSheet(
                    //     context: context,
                    //     builder: (_) {
                    //       return NewTransaction(_addTransaction);
                    //     });

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: ((context) => AddTransactionPage(type: transactions[index]['type']))));
                  },
                );
              })),
          actions: [
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
