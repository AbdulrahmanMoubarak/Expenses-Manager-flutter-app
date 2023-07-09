import 'package:expenses_manager_app/models/Transaction.dart';
import 'package:expenses_manager_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart({super.key, required this.recentTransactions});

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, item) => sum + double.parse(item['amount'].toString()));
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions.elementAt(i).date.day == weekDay.day &&
            recentTransactions.elementAt(i).date.month == weekDay.month &&
            recentTransactions.elementAt(i).date.year == weekDay.year) {
          totalSum += recentTransactions.elementAt(i).amount;
        }
      }
      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupedTransactionValues.map((val) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
                label: val['day'].toString(),
                amount: val['amount'] as double,
                percentOfTotal: totalSpending == 0.0
                    ? 0.0
                    : (val['amount'] as double) / totalSpending),
          );
        }).toList(),
      ),
    );
  }
}
