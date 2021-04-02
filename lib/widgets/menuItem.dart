import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final double price;
  final String title;
  const MenuItem({this.price, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: GridTile(
        child: Text('place holder for image'),
        header: Text(title),
        footer: Text(price.toString()),
      ),
    );
  }
}
