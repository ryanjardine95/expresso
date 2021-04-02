class MenuItem {
 String name;
 String description;
 String price;
 int numberOrdered;

  MenuItem({this.name, this.description, this.price, this.numberOrdered});

  MenuItem.fromJson(Map<String, dynamic> parsedJSON):
      name = parsedJSON['name'], description = parsedJSON['name'], price = parsedJSON['name'], numberOrdered = parsedJSON['numberOrdered'];

}