import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logintunisia/interface/product.dart';
import 'package:uuid/uuid.dart';

class MarketplaceProductCreate extends StatefulWidget {
  @override
  _MarketplaceProductCreateState createState() =>
      _MarketplaceProductCreateState();
}

class _MarketplaceProductCreateState extends State<MarketplaceProductCreate> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addController = TextEditingController();
  TextEditingController _field3Controller = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getLocation() async {
    final hasPermission = await _handleLocationPermission();
    try {
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addController.dispose();
    _field3Controller.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Details'),
      ),
      body: Column(
        children: [
          _buildTextField("Product Name", _nameController, "TEXT_INPUT"),
          _buildTextField("Address", _addController, "TEXT_INPUT"),
          _buildTextField("Field 2", _field3Controller, "TEXT_INPUT"),
          _buildTextField("Price", _priceController, "NUMBER_INPUT"),
          ElevatedButton(
            onPressed: () {
              // Do something with the form fields' values here
              createProduct(
                  _nameController.text,
                  _addController.text,
                  double.parse(_priceController.text),
                  _currentPosition?.latitude ?? 0,
                  _currentPosition?.longitude ?? 0);
              // For example, print them to the console:
              print("Field 1: ${_addController.text}");
              print("Field 2: ${_field3Controller.text}");
              print("Field 3: ${_priceController.text}");
              Navigator.pop(context); // Go back to the previous screen
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future createProduct(
      String name, String add, double price, double lat, double long) async {
    Uuid uuid = Uuid();
    final docUser =
        FirebaseFirestore.instance.collection('marketplace').doc(uuid.v1());
    GeoPoint point = new GeoPoint(lat, long);
    final json = Product(name: name, add: add, price: price, loc: point);

    await docUser.set(json.toJson());
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, String type) {
    if (type == "NUMBER_INPUT") {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      );
    } else {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      );
    }
  }
}
