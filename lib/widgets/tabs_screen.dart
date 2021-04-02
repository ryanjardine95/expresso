import 'package:expresso_mobile_app/allScreens/addMenuScreen.dart';
import 'package:expresso_mobile_app/allScreens/storeHomeScreen.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  void _pageSelector(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {'pages': StoreHomeScreen(), 'title': 'Home'},
      {'pages': MenuAddAScreen(), 'title': 'Menu'},
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: _pages[_selectedPageIndex]['pages'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _pageSelector,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
        ],
      ),
    );
  }
}
