import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(
      {super.key,
      required this.label,
      required this.amount,
      required this.percentOfTotal});
  final String label;
  final double amount;
  final double percentOfTotal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(constraints.maxHeight * 0.05),
          child: Column(
            children: [
              SizedBox(
                  height: constraints.maxHeight * 0.10,
                  child:
                      FittedBox(child: Text('\$${amount.toStringAsFixed(0)}'))),
              SizedBox(
                height: constraints.maxHeight * 0.05,
              ),
              SizedBox(
                height: constraints.maxHeight * 0.6,
                width: 10,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(220, 220, 220, 1)),
                    ),
                    FractionallySizedBox(
                      heightFactor: percentOfTotal,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.05,
              ),
              SizedBox(
                  height: constraints.maxHeight * 0.10,
                  child: FittedBox(child: Text(label))),
            ],
          ),
        );
      },
    );
  }
}
