import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final LatLng location;
  final Map<String, String> property; // Add property field

  const MapSample({super.key, required this.location, required this.property});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: widget.location,
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: <Marker>{
                  Marker(
                    markerId: MarkerId('property_location'),
                    position: widget.location,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(
                      title: 'Property Location',
                      snippet: 'Tap to see details',
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildBottomSheet(context),
                      );
                    },
                  ),
                },
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenMap(location: widget.location, property: widget.property),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.property['imgPreview'] != null
                ? (widget.property['imgPreview']!.startsWith('//')
                ? 'https:${widget.property['imgPreview']}'
                : widget.property['imgPreview']!)
                : 'https://via.placeholder.com/150', // Placeholder image
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.error, color: Colors.red, size: 50),
              );
            },
          ),
          SizedBox(height: 8.0),
          Text(
            widget.property['city_name'] ?? 'Unknown Address',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.property['propertytype'] ?? 'Price not available',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.property['Bedrooms'] != null ? '${widget.property['Bedrooms']} Bed' : 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                ' | ',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                widget.property['bathroom'] != null ? '${widget.property['Full_Baths']} Bath' : 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                ' | ',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                widget.property['Type'] ?? 'Type not available',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FullScreenMap extends StatefulWidget {
  final LatLng location;
  final Map<String, String> property; // Add property field

  const FullScreenMap({super.key, required this.location, required this.property});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: widget.location,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: <Marker>{
                Marker(
                  markerId: MarkerId('property_location'),
                  position: widget.location,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: 'Property Location',
                    snippet: 'Tap to see details',
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => _buildBottomSheet(context),
                    );
                  },
                ),
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.fullscreen_exit,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.property['search_resultsquery'] != null
                ? (widget.property['search_resultsquery']!.startsWith('//')
                ? 'https:${widget.property['search_resultsquery']}'
                : widget.property['search_resultsquery']!)
                : 'https://via.placeholder.com/150', // Placeholder image
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.error, color: Colors.red, size: 50),
              );
            },
          ),
          SizedBox(height: 8.0),
          Text(
            widget.property['city_name'] ?? 'Unknown Address',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                widget.property['Bedrooms'] != null
                    ? '${widget.property['Bedrooms']} Bed'
                    : 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(width: 8),
              Text(
                ' | ',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(width: 8),
              Text(
                widget.property['propertytype'] ?? 'Type not available',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
