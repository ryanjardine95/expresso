class MenuItem {
 String name;
 String description;
 String price;

  MenuItem({this.name, this.description, this.price});

  MenuItem.fromJson(Map<String, dynamic> parsedJSON):
      name = parsedJSON['name'], description = parsedJSON['name'], price = parsedJSON['name'];

}