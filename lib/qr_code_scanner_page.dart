import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRCodeScannerPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  QRCodeScannerPage({
    required this.userId,
    required this.userName,
    required this.carbonFootprint,
  });

  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  double carEmissionFactor = 0.12;
  double trainEmissionFactor = 0.04;
  double electricCarEmissionFactor = 0.048;
  bool _isDialogOpen = false;

  @override
  void reassemble() {
    super.reassemble();
    controller!.pauseCamera();
    controller!.resumeCamera();
  }

  Future<List<String>> fetchStationSuggestions() async {
    try {
      final response = await http.get(
        //Uri.parse('http://192.168.0.105:5001/stations'),
        Uri.parse('http://192.168.0.105:5001/stations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return List<String>.from(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch station suggestions: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Barcode Type: ${result!.format}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      // Check if the scanned data matches the expected identifier
      if (scanData.code == 'open_popup' && !_isDialogOpen) {
        _showOriginDestinationDialog();
      }
    });
  }

void _showOriginDestinationDialog() async {
  _isDialogOpen = true;
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  List<String> stationSuggestions = await fetchStationSuggestions();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Enter Origin and Destination'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return stationSuggestions.where((String option) {
                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              _originController.text = selection;
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Origin',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return stationSuggestions.where((String option) {
                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              _destinationController.text = selection;
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            String origin = _originController.text;
            String destination = _destinationController.text;

            if (origin.isNotEmpty && destination.isNotEmpty) {
              final distance = await calculateDistance(widget.userId, origin, destination); // Use widget.userId
              if (distance != null) {
                print('Distance: $distance km');
                final carbonFootprintSaved = calculateCarbonFootprintSaved(distance);
                final percentageReduction = calculatePercentageReduction(widget.carbonFootprint, carbonFootprintSaved);
                Navigator.pop(context); // Close the current dialog
                _isDialogOpen = false;
                _showCarbonFootprintDialog(distance, carbonFootprintSaved, percentageReduction);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to calculate distance')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter both origin and destination.')),
              );
            }
          },
          child: Text('Submit'),
        ),
      ],
    ),
  );
  _isDialogOpen = false;
}

  Future<double?> calculateDistance(int userId, String origin, String destination) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/distance?origin=$origin&destination=$destination&user_id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Debugging line
        if (responseData['distance_km'] != null) {
          final distanceValue = responseData['distance_km'];
          return distanceValue;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to parse distance data')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch distance data: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    return null;
  }

  double calculateCarbonFootprintSaved(double distance) {
    final carEmissions = calculateEmissions(distance, carEmissionFactor);
    final trainEmissions = calculateEmissions(distance, trainEmissionFactor);
    print('Car Emissions: $carEmissions kg CO2'); // Debugging line
    print('Train Emissions: $trainEmissions kg CO2'); // Debugging line

    final carbonFootprintSaved = carEmissions - trainEmissions;
    return carbonFootprintSaved;
  }

  double calculateEmissions(double distance, double emissionFactor) {
    return distance * emissionFactor;
  }

  double calculatePercentageReduction(double totalCarbonFootprint, double carbonFootprintSaved) {
    return (carbonFootprintSaved / totalCarbonFootprint) * 100;
  }

void _showCarbonFootprintDialog(double distance, double carbonFootprintSaved, double percentageReduction) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        title: Row(
          children: [
            Icon(Icons.thumb_up, color: Color(0xFF264E36)),
            SizedBox(width: 10),
            Text(
              'Great Job!',
              style: TextStyle(
                color: Color(0xFF264E36),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: 10),
              _buildInfoRow('Distance:', '$distance km'),
              _buildInfoRow('Car Emissions:', '${calculateEmissions(distance, carEmissionFactor).toStringAsFixed(2)} kg CO2'),
              _buildInfoRow('Train Emissions:', '${calculateEmissions(distance, trainEmissionFactor).toStringAsFixed(2)} kg CO2'),
              _buildInfoRow('Electric Car Emissions:', '${calculateEmissions(distance, electricCarEmissionFactor).toStringAsFixed(2)} kg CO2'),
              SizedBox(height: 10),
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: 10),
              _buildInfoRow('Carbon Footprint Saved:', '${carbonFootprintSaved.toStringAsFixed(2)} kg CO2'),
              _buildInfoRow('Percentage Reduction:', '${percentageReduction.toStringAsFixed(2)}%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _incrementGreenCommuter(percentageReduction);
              Navigator.of(context).pop();
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: Color(0xFF264E36),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    ),
  );
}

Future<void> _incrementGreenCommuter(double percentageReduction) async {
  //final uri = Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity');
  final uri = Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity'); 
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'activity_type': 'Green Commuter',
      'percentage_reduction': percentageReduction
    }),
  );

  if (response.statusCode == 200) {
    print('Green Commuter badge incremented and carbon footprint updated');

    // Optional: Fetch updated carbon footprint and display it
    final userDataResponse = await http.get(
      //Uri.parse('http://192.168.0.105:5001/get_user_data'),
      Uri.parse(' http://192.168.0.105:5001/get_user_data'),
      headers: {'Content-Type': 'application/json'},
    );

    if (userDataResponse.statusCode == 200) {
      final userData = jsonDecode(userDataResponse.body);
      print('Updated carbon footprint: ${userData["carbon_footprint"]}');
      double updatedCarbonFootprint = userData["carbon_footprint"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Carbon footprint updated successfully')),
      );
      Navigator.pop(context, updatedCarbonFootprint);

    } else {
      print('Failed to fetch updated carbon footprint');
      Navigator.pop(context, widget.carbonFootprint); // Pass the original value if the update fails
    }

  } else {
    print('Failed to increment Green Commuter badge: ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to increment Green Commuter badge: ${response.body}')),
    );
  }
}

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}