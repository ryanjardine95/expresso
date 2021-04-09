class OrderModel{
  final String itemOrdered;
  final int numberOrdered;

  OrderModel(this.itemOrdered, this.numberOrdered);

  OrderModel.fromJson(Map<String, dynamic> parsedJson):
      itemOrdered = parsedJson["itemOrdered"],
  numberOrdered = parsedJson["numberOrdered"];
}