
class StoreModel {
  String storeId;
  double latitude;
  double longitude;

  StoreModel({this.storeId, this.latitude, this.longitude});

  StoreModel.fromJson(Map<String, dynamic> parsedJSON)
      : storeId = parsedJSON['userid'],
        latitude = parsedJSON['latitude'],
        longitude = parsedJSON['longitude'];
}