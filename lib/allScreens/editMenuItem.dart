import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditMenuItem extends StatefulWidget {
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemPrice;

  const EditMenuItem({Key key, this.menuItemName, this.menuItemDescription, this.menuItemPrice}) : super(key: key);
  @override
  _EditMenuItemState createState() => _EditMenuItemState(menuItemName, menuItemDescription, menuItemPrice);
}

class _EditMenuItemState extends State<EditMenuItem> {
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemPrice;
  _EditMenuItemState(this.menuItemName, this.menuItemDescription, this.menuItemPrice);

  bool _isLoading = false;
  String user = FirebaseAuth.instance.currentUser.uid;
  TextEditingController productName = new TextEditingController();
  TextEditingController productDescription = new TextEditingController();
  TextEditingController productPrice = new TextEditingController();

  @override
  void initState() {
    productName.text = menuItemName;
    productDescription.text = menuItemDescription;
    productPrice.text = menuItemPrice;
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Menu Item"),
        centerTitle: true,
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()):
      Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: productName,
                  decoration: InputDecoration(
                    hintText:menuItemName,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: productDescription,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:menuItemDescription,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: productPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText:menuItemPrice,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  editMenuItem();
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future editMenuItem() async {
    setState(() {
      _isLoading = true;
    });
    print(productName.text);
    print(productDescription.text);
    print(productPrice.text);
    try{
      await FirebaseFirestore.instance.collection('users').doc(user).collection('menu').doc(menuItemName).set({
        "name" : productName.text,
        "description" : productDescription.text,
        "price" : productPrice.text,
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, 'StoreMenu');
    }catch(e){
      setState(() {
        _isLoading = false;
      });
      throw(e);

    }
    setState(() {
      _isLoading = false;
    });
  }
}