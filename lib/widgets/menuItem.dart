import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final double price;
  final String title;
  const MenuItem({this.price, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        subtitle: Text(
          price.toString(),
        ),
        title: Text(title),

      ),
    );
  }
}
