import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/allScreens/editMenuItem.dart';
import 'package:expresso_mobile_app/models/menuItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StoreMenu extends StatefulWidget {
  @override
  _StoreMenuState createState() => _StoreMenuState();
}

class _StoreMenuState extends State<StoreMenu> {
  String user = FirebaseAuth.instance.currentUser.uid;
  List<MenuItem> menuList = [];
  bool _isLoading = false;

  @override
  void initState() {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc('$user')
          .collection('menu')
          .get()
          .then((docCollection) {
        docCollection.docs.forEach((element) {
          print(element.data());
          setState(() {
            menuList.add(MenuItem(
              name: element.data()['name'],
              description: element.data()['description'],
              price: element.data()['price'],
            ));
            print(menuList);
          });
        });
      });
    } catch (e) {
      throw (e);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(user);

    return Scaffold(
      appBar: AppBar(
        title: Text("Store Menu"),
        centerTitle: true,
        actions: [
          //IconButton(onPressed: (){ getMenuItems();}, icon: Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),):
      ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, i) {
          return Card(

            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('${menuList[i].name}'),
                            subtitle: Text('${menuList[i].description}'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: Text("Price: ${menuList[i].price}")
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: ElevatedButton(
                                child: Text("Edit"),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditMenuItem(
                                    menuItemName: menuList[i].name,
                                    menuItemDescription: menuList[i].description,
                                    menuItemPrice: menuList[i].price,
                                  )));
                                },
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                        Icons.delete,
                                      color: Colors.red,
                                    ),
                                    Text("Remove")
                                  ],
                                ),
                                onLongPress: (){
                                  deleteMenuItem(menuList[i].name);
                                },
                              )
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'AddMenuItem');
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Future deleteMenuItem(String menuItem) async {
    setState(() {
      _isLoading = true;
    });
    try{
      await FirebaseFirestore.instance.collection('users').doc(user).collection('menu').doc(menuItem).delete();
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, "StoreMenu");
    }catch(e){
      setState(() {
        _isLoading = false;
      });
      throw(e);
    }
  }
}
