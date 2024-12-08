import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'saved_locations_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String latitude = "30.1420767";
  final String longitude = "31.3252117";
  List<Placemark> nearbyPlaces = [];
  List<String> savedLocations = [];

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> _getNearbyPlaces() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(latitude), double.parse(longitude));
      setState(() {
        nearbyPlaces = placemarks;
      });
    } catch (e) {
      print("Error getting nearby places: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _getSavedLocations();
    _getNearbyPlaces();
  }

  Future<void> _saveLocation(Placemark place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = "${place.street}, ${place.locality}, ${place.country}";
    setState(() {
      savedLocations.add(location);
    });
    await prefs.setStringList('savedLocations', savedLocations);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location saved!")),
    );
  }

  Future<void> _getSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedLocations = prefs.getStringList('savedLocations') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Nearby Places", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2C3E50),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
          ),
        ),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 8,
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: Text("Your Location",
                    style: TextStyle(
                      color: Color(0xFF2C3E50),
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text(
                  "Lat: $latitude, Long: $longitude",
                  style: TextStyle(color: Color(0xFF7F8C8D)),
                ),
                leading: Icon(Icons.location_on, color: Color(0xFF3498DB)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = nearbyPlaces[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        "${place.street ?? ''}, ${place.locality ?? ''}",
                        style: TextStyle(
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        place.country ?? '',
                        style: TextStyle(color: Color(0xFF7F8C8D)),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.bookmark_border,
                            color: Color(0xFF3498DB)),
                        onPressed: () => _saveLocation(place),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SavedLocationsScreen(savedLocations: savedLocations),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "View Saved Locations",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
