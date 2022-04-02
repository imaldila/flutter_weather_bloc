enum LocationType {
  city,
  region,
  state,
  province,
  country,
  continent,
}

class Location {
  final String title;
  final LocationType locationType;
  final LatLng latLng;
  final int woeid;

  const Location({
    required this.title,
    required this.locationType,
    required this.latLng,
    required this.woeid,
  });
}

class LatLng {
  final double latitude, longitude;

  const LatLng({required this.latitude, required this.longitude});
}
