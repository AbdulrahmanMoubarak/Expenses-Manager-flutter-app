import 'package:expenses_manager_app/models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function removeTransactionById;
  const TransactionList(
      {super.key,
      required this.transactions,
      required this.removeTransactionById});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: transactions.isEmpty
            ? const Column(
                children: [
                  Text('No transactions added yet!'),
                  // Image.asset('assets/images/waiting.png ')
                ],
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  final tx = transactions.elementAt(index);
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text(
                              '\$${tx.amount.toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                      ),
                      title: Text(tx.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text(
                        DateFormat.yMMMd().format(tx.date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: MediaQuery.of(context).size.width < 460
                          ? IconButton(
                              onPressed: () {
                                removeTransactionById(tx.id);
                              },
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                            )
                          : TextButton.icon(
                              onPressed: () => removeTransactionById(tx.id),
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.error),
                              label: Text(
                                'Delete',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              )),
                    ),
                  );
                },
                itemCount: transactions.length,
              ));
  }
}
