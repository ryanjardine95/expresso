const  GOOGLE_API_KEY = "AIzaSyCfZdXcpNA3BiuHWN5-e_afQSRASB8znzo";


class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude, $longitude&=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude, $longitude&key=$GOOGLE_API_KEY';
  }
}
