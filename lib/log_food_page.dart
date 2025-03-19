import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LogFoodPage extends StatefulWidget {
  final int userId;

  LogFoodPage({required this.userId});

  @override
  _LogFoodPageState createState() => _LogFoodPageState();

  static Route<dynamic> route({required Map<String, dynamic> arguments}) {
    return MaterialPageRoute(
      builder: (context) => LogFoodPage(userId: arguments['userId']),
    );
  }
}

class _LogFoodPageState extends State<LogFoodPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _predictedFood;
  String? _selectedFood;
  final TextEditingController _servingController = TextEditingController();
  String _badge = 'Bronze';
  String _level = 'Beginner';
  bool _confirmFood = false;
  double _totalCo2 = 0.0; // Initialize to 0.0
  List<Map<String, dynamic>> _foodLog = [];

 
    // Food items for the dropdown
  final List<String> foodItems = [
    'Apple Pie', 'Baby Back Ribs', 'Baklava', 'Beef Carpaccio', 'Beef Tartare',
    'Beet Salad', 'Beignets', 'Bibimbap', 'Bread Pudding', 'Breakfast Burrito',
    'Bruschetta', 'Caesar Salad', 'Cannoli', 'Caprese Salad', 'Carrot Cake',
    'Ceviche', 'Cheesecake', 'Cheese Plate', 'Chicken Curry', 'Chicken Quesadilla',
    'Chicken Wings', 'Chocolate Cake', 'Chocolate Mousse', 'Churros', 'Clam Chowder',
    'Club Sandwich', 'Crab Cakes', 'Creme Brulee', 'Croque Madame', 'Cup Cakes',
    'Deviled Eggs', 'Donuts', 'Dumplings', 'Edamame', 'Eggs Benedict', 'Escargots',
    'Falafel', 'Filet Mignon', 'Fish and Chips', 'Foie Gras', 'French Fries',
    'French Onion Soup', 'French Toast', 'Fried Calamari', 'Fried Rice', 'Frozen Yogurt',
    'Garlic Bread', 'Gnocchi', 'Greek Salad', 'Grilled Cheese Sandwich', 'Grilled Salmon',
    'Guacamole', 'Gyoza', 'Hamburger', 'Hot and Sour Soup', 'Hot Dog', 'Huevos Rancheros',
    'Hummus', 'Ice Cream', 'Lasagna', 'Lobster Bisque', 'Lobster Roll Sandwich',
    'Macaroni and Cheese', 'Macarons', 'Miso Soup', 'Mussels', 'Nachos', 'Omelette',
    'Onion Rings', 'Oysters', 'Pad Thai', 'Paella', 'Pancakes', 'Panna Cotta', 'Peking Duck',
    'Pho', 'Pizza', 'Pork Chop', 'Poutine', 'Prime Rib', 'Pulled Pork Sandwich', 'Ramen',
    'Ravioli', 'Red Velvet Cake', 'Risotto', 'Samosa', 'Sashimi', 'Scallops', 'Seaweed Salad',
    'Shrimp and Grits', 'Spaghetti Bolognese', 'Spaghetti Carbonara', 'Spring Rolls', 'Steak',
    'Strawberry Shortcake', 'Sushi', 'Tacos', 'Takoyaki', 'Tiramisu', 'Tuna Tartare', 'Waffles'
  ];

  @override
  void initState() {
    super.initState();
    _fetchFoodLogs();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showHelpDialog();
    });
  }

  Future<void> _fetchFoodLogs() async {
    final response = await http.get(
      //Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/food_logs'),
      Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/food_logs'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> foodLogs = responseData['food_logs'];
      setState(() {
        _foodLog = foodLogs.map((log) => {
          'food': log['food_name'],
          'serving': log['serving_size'],
          'co2': log['carbon_footprint'],
        }).toList();
        _totalCo2 = responseData['total_co2'].toDouble();
        _level = responseData['level']; // Update the level
        _badge = responseData['badge']; // Update the badge
      });
    } else {
      print('Failed to fetch food logs: ${response.statusCode}');
    }
}

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile;
    });
    if (_image != null) {
      _uploadImage(); // Automatically upload image after picking
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    print('Uploading image...');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.105:5001/predict'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print('Image upload successful. Response: $jsonResponse');

      final double confidenceScore = jsonResponse['confidence_score'];
      setState(() {
        if (confidenceScore >= 0.5) {
          _predictedFood = jsonResponse['predicted_class_name'];
          _selectedFood = _predictedFood;
        } else {
          _predictedFood = 'Food Item not found';
          _selectedFood = null; // or any other appropriate handling
        }
      });
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }

Future<void> _submitFoodLog() async {
  final serving = int.tryParse(_servingController.text);
  if (serving == null || _selectedFood == null) {
    print('Invalid serving size or food not selected');
    return;
  }

  print('Submitting food log...');
  print('User ID: ${widget.userId}');
  print('Food: $_selectedFood');
  print('Serving: $serving');

  final response = await http.post(
    Uri.parse('http://192.168.0.105:5001/log_food'), // Ensure this matches your backend route
    //Uri.parse('http://118.101.211.116:5001/log_food'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': widget.userId,
      'food': _selectedFood,
      'serving': serving,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print('Food log submitted successfully. Response: $responseData');

    setState(() {
      _badge = responseData['badge'] ?? _badge;
      _level = responseData['level'] ?? _level;

      // Check if 'total_co2' exists in the response
      if (responseData.containsKey('total_co2')) {
        double newCo2 = (responseData['total_co2'] ?? 0.0).toDouble();
        _totalCo2 = newCo2;
        _foodLog.add({
          'food': _selectedFood,
          'serving': serving,
          'co2': newCo2,
        });
      } else {
        // Handle case where 'total_co2' is not present in the response
        print('total_co2 not found in response');
      }
    });

    Navigator.pop(context);
  } else {
    print('Failed to submit food log: ${response.statusCode}');
  }
}

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Log Food'),
          content: Text(
            'To log your food intake, please take a picture of your meal, '
            'confirm or enter the correct food name, and provide the serving size in grams. '
            'This will help track your carbon footprint.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFoodLogTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Meal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Serving',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'CO2',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        ..._foodLog.map((food) {
          return TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(food['food']),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(food['serving'].toString()),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(food['co2'].toStringAsFixed(2)),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Food'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
                
                Row(
                  children: [
                    Image.asset(
                      'assets/images/$_badge.png', // Replace with the correct path to your badge images
                      width: 130,
                      height: 130,
                    ),
                    SizedBox(width: 20),
                    Transform.translate(
                      offset: Offset(0, -20), // Adjust this value to move the texts higher
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_level',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text('Overall Footprint: ${_totalCo2.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _image == null
                    ? Container()
                    : Column(
                      children: [
                        Image.file(File(_image!.path)),
                        SizedBox(height: 20),
                        Text('Predicted Food: $_predictedFood'),
                        Row(
                          children: [
                            Checkbox(
                              value: _confirmFood,
                              onChanged: (bool? value) {
                                setState(() {
                                  _confirmFood = value ?? false;
                                  if (_confirmFood) {
                                    _selectedFood = _predictedFood;
                                  }
                                });
                              },
                            ),
                            Text('Confirm Food'),
                          ],
                        ),
                        if (!_confirmFood)
                          Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return foodItems.where((String option) {
                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              setState(() {
                                _selectedFood = selection;
                              });
                            },
                            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Enter Correct Food',
                                  border: OutlineInputBorder(),
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _servingController,
                          decoration: InputDecoration(labelText: 'Enter Serving Size (grams)'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitFoodLog,
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                SizedBox(height: 50), // Add more space to move the table lower
                _buildFoodLogTable(),
              ],
            ),
            Positioned(
              top: 80, // Adjust this value to move the button vertically
              right: 50, // Adjust this value to move the button horizontally
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Text(
                  'PICK IMAGE',
                  style: TextStyle(fontFamily: 'Lexend', color: Colors.white), // Set font family to Lexend
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF264E36),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}