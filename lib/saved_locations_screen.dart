import 'package:flutter/material.dart';

class SavedLocationsScreen extends StatelessWidget {
  final List<String> savedLocations;

  const SavedLocationsScreen({super.key, required this.savedLocations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Locations",
            style: TextStyle(color: Colors.white)),
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
        child: savedLocations.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border,
                        size: 64, color: Colors.white.withOpacity(0.7)),
                    SizedBox(height: 16),
                    Text(
                      "No saved locations yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedLocations.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Color(0xFF3498DB),
                      ),
                      title: Text(
                        savedLocations[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
