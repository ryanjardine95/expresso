import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMenuItem extends StatefulWidget {
  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  bool _isLoading = false;
  String user = FirebaseAuth.instance.currentUser.uid;
  TextEditingController productName = new TextEditingController();
  TextEditingController productDescription = new TextEditingController();
  TextEditingController productPrice = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Menu Item"),
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
                    hintText:"Your Product Name",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: productDescription,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:"A brief description",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: productPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText:"The price of your Product",
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    addMenuItem();
                  },
                  child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future addMenuItem() async {
    setState(() {
      _isLoading = true;
    });
    print(productName.text);
    print(productDescription.text);
    print(productPrice.text);
    try{
      await FirebaseFirestore.instance.collection('users').doc(user).collection('menu').doc(productName.text).set({
        "name" : productName.text,
        "description" : productDescription.text,
        "price" : productPrice.text,
        "numberOrdered" : 0,
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