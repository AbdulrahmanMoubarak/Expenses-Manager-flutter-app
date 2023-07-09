import 'dart:io';

import 'package:expenses_manager_app/widgets/chart.dart';
import 'package:expenses_manager_app/widgets/new_transaction.dart';
import 'package:expenses_manager_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'models/Transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: 't1',
        title: 'Shoes',
        amount: 250.99,
        date: DateTime.now().subtract(const Duration(days: 1))),
    Transaction(
        id: 't2',
        title: 'Shirt',
        amount: 200.01,
        date: DateTime.now().subtract(const Duration(days: 2))),
    Transaction(
        id: 't3',
        title: 'Books',
        amount: 100.54,
        date: DateTime.now().subtract(const Duration(days: 2))),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions
        .where((tx) =>
            tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String title, String price, DateTime selectedDate) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: double.parse(price),
        date: selectedDate);
    setState(() {
      _transactions.add(tx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(addTransaction: _addNewTransaction);
        });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: const Text('Expenses Manager App'),
      actions: [
        IconButton(
            onPressed: () => _openBottomSheet(context),
            icon: const Icon(Icons.add))
      ],
    );
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final transactionList = SizedBox(
      height: (mediaQuery.size.height * 0.65) -
          appBar.preferredSize.height -
          mediaQuery.padding.top,
      child: TransactionList(
        transactions: _transactions,
        removeTransactionById: _deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show chart'),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    }),
              ],
            ),
          if (!isLandscape)
            SizedBox(
                height: (mediaQuery.size.height * 0.35) -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top,
                child: Chart(recentTransactions: _recentTransactions)),
          _showChart && isLandscape
              ? SizedBox(
                  height: (mediaQuery.size.height * 0.65) -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top,
                  child: Chart(recentTransactions: _recentTransactions))
              : transactionList,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _openBottomSheet(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}
