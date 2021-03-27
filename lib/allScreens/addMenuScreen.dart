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

  void _addNewMenuItem(String title, double price) {
    final newItem =
        Menuitem(price: price, title: title, id: DateTime.now().toString());

    setState(() {
      _storeMenuItems.add(newItem);
      saveData.add(
        {'title': newItem.title, 'price': newItem.price, 'id': newItem.id},
      );
    });
  }

  void _startAddNewMenuItem(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (btx) {
          return NewMenuItem(_addNewMenuItem);
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
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (ctx, i) => ListTile(
                            subtitle:
                                Text('R${data[i].data()['price'].toString()}'),
                            title: Text(data[i].data()['title']),
                            trailing: ElevatedButton.icon(
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
