import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/helpers/MenuItem.dart';
import 'package:expresso_mobile_app/widgets/new_menuItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuAddAScreen extends StatefulWidget {
  @override
  _MenuAddAScreenState createState() => _MenuAddAScreenState();
}

class _MenuAddAScreenState extends State<MenuAddAScreen> {
  List<Menuitem> _storeMenuItems = [];
  final saveData = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('menuItems');

  String url = '';
  // ignore: unused_field
  File _imageChosen;

  void _addNewMenuItem(String title, double price, File image) async {
    final newItem = Menuitem(
      price: price,
      title: title,
      id: DateTime.now().toString(),
      image: image,
    );

    setState(() {
      _storeMenuItems.add(newItem);
      saveData.add(
        {
          'title': newItem.title,
          'price': newItem.price,
          'id': newItem.id,
          'Image': url
        },
      );
    });
  }

  void _startAddNewMenuItem(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (btx) {
          return NewMenuItem(
            _addNewMenuItem,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('menuItems')
        .snapshots();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: Column(
              children: [
                StreamBuilder(
                    stream: collection,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      var data = snapshot.data.docs;

                      if (data.isNotEmpty) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisSpacing: 10),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (ctx, i) => GridTile(
                            child: Image.network(data[i].data()['Image']),
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                    child: Text(
                                  data[i].data()['title'],
                                  style: TextStyle(fontSize: 15),
                                )),
                                Text(
                                  'R${data[i].data()['price'].toString()}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            footer: ElevatedButton.icon(
                              onPressed: () =>
                                  saveData.doc(data[i].id).delete(),
                              icon: Icon(Icons.delete),
                              label: Text('delete'),
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text('No Menu Items Added'),
                        );
                      }
                    }),
              ],
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewMenuItem(context),
      ),
    );
  }
}
