import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Challenge {
  final String name;
  final String description;
  final List<String> keywords;

  Challenge({required this.name, required this.description, required this.keywords});
}

class ChallengeListPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  ChallengeListPage({required this.userId, required this.userName, required this.carbonFootprint});

  @override
  _ChallengeListPageState createState() => _ChallengeListPageState();
}

class _ChallengeListPageState extends State<ChallengeListPage> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<Challenge> challenges = [
    Challenge(
      name: 'Recycling Plastic Bottles',
      description: 'Recycle plastic bottles properly.',
      keywords: ['recycling', 'plastic bottles', 'bins', 'eco-friendly', 'waste management', 'green', 'sustainability', 'environment', 'clean', 'reuse','waste containment']
    ),
    Challenge(
      name: 'Planting a Tree',
      description: 'Plant a tree in your community.',
      keywords: ['planting', 'plant', 'nature', 'tree', 'sapling', 'garden', 'soil', 'environment', 'growth']
    ),
    Challenge(
      name: 'Beach Cleanup',
      description: 'Participate in a beach cleanup event.',
      keywords: ['beach cleanup', 'trash bags', 'coastline', 'volunteers', 'plastic waste', 'litter', 'ocean', 'environment', 'sand', 'eco-friendly']
    ),
    Challenge(
      name: 'Bike to Work',
      description: 'Bike to work to reduce carbon emissions.',
      keywords: ['biking', 'commute', 'bicycle', 'road', 'eco-friendly', 'transportation', 'sustainability', 'green', 'environment', 'health']
    ),
    Challenge(
      name: 'Using a Refillable Water Bottle',
      description: 'Use a refillable water bottle.',
      keywords: ['refillable water bottle', 'eco-friendly', 'sustainability', 'environment', 'reduce waste', 'zero waste', 'hydration', 'reusable', 'bottle']
    ),
    Challenge(
      name: 'Using Reusable Shopping Bags',
      description: 'Use reusable shopping bags.',
      keywords: ['reusable shopping bags', 'eco-friendly', 'sustainability', 'environment', 'reduce waste', 'zero waste', 'groceries', 'bag', 'reusable']
    ),
    Challenge(
      name: 'Planting a Flower',
      description: 'Plant a flower in your garden.',
      keywords: ['planting flower', 'garden', 'eco-friendly', 'sustainability', 'environment', 'nature', 'soil', 'plant', 'growth']
    ),
    Challenge(
      name: 'Making DIY Natural Birdhouse',
      description: 'Make a DIY natural birdhouse.',
      keywords: ['birdhouse', 'DIY', 'eco-friendly', 'sustainability', 'environment', 'nature', 'bird', 'garden', 'homemade']
    ),
    Challenge(
      name: 'Using Reusable Cloth Towel',
      description: 'Use a reusable cloth towel.',
      keywords: ['reusable cloth towel', 'eco-friendly', 'sustainability', 'environment', 'reduce waste', 'zero waste', 'kitchen', 'reusable', 'towel']
    ),
    Challenge(
      name: 'Creating a DIY Plant Terrarium',
      description: 'Create a DIY plant terrarium.',
      keywords: ['plant terrarium', 'DIY', 'eco-friendly', 'sustainability', 'environment', 'gardening', 'plants', 'homemade', 'terrarium', 'nature']
    ),
    Challenge(
      name: 'Use Metal Cutlery',
      description: 'Use metal cutlery instead of disposable ones.',
      keywords: ['metal', 'fork', 'spoon']
    ),
  ];

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _verifyImage(File image, String challengeName, List<String> keywords) async {
    setState(() {
      _isLoading = true;
    });
    final uri = Uri.parse('http://192.168.0.105:5001/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['challenge'] = challengeName
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print('Response data: $responseData'); // Debugging line
      final labels = jsonDecode(responseData) as List<dynamic>;

      final detectedLabels = labels.map((label) => label.toString().toLowerCase()).toList();
      print('Detected labels: $detectedLabels'); // Debugging line

      // Check if any keyword matches any label
      String matchedKeyword = '';
      final isValid = keywords.map((k) => k.toLowerCase()).any((keyword) {
        final match = detectedLabels.any((label) => label.contains(keyword));
        if (match) {
          matchedKeyword = keyword;
          print('Matched keyword: $matchedKeyword'); // Debugging line
        }
        return match;
      });

      print('Keywords: ${keywords.map((k) => k.toLowerCase()).toList()}'); // Debugging line
      print('isValid: $isValid'); // Debugging line

      if (isValid) {
        print('Image verified successfully');
        await _incrementChallengeChamp(); // Increment Challenge Champ badge
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image verified successfully for $challengeName')),
        );
      } else {
        print('Image verification failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image verification failed for $challengeName')),
        );
      }
    } else {
      print('Image verification failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image verification failed: ${response.reasonPhrase}')),
      );
    }
  }
  
  Future<void> _incrementChallengeChamp() async {
  //final uri = Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity');
  final uri = Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'activity_type': 'Challenge Champ'}),
  );

  if (response.statusCode == 200) {
    print('Challenge Champ badge incremented');
  } else {
    print('Failed to increment Challenge Champ badge');
  }
}

  void _showUploadDialog(Challenge challenge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Image for ${challenge.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedImage != null) Image.file(_selectedImage!),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text('Take Picture'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text('Select from Gallery'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedImage != null) {
                  _verifyImage(_selectedImage!, challenge.name, challenge.keywords);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = (index);
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(
          context,
          '/main',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
            'carbonFootprint': widget.carbonFootprint,
          },
        );
        break;
      case 2:
        Navigator.pushNamed(
          context,
          '/log_activity',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
            'carbonFootprint': widget.carbonFootprint,
          },
        );
        break;
      case 1:
        Navigator.pushNamed(
          context,
          '/badges',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
            'carbonFootprint': widget.carbonFootprint,
          },
        );
        break;
      case 3:
        Navigator.pushNamed(context, '/community');
        break;
      case 4:
        Navigator.pushNamed(
          context,
          '/profile',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
          },
        );
        break;
      case 5: // Add this case for challenges page
        Navigator.pushNamed(
          context,
          '/challenges',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
            'carbonFootprint': widget.carbonFootprint,
          },
        );
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge Champ'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(challenges[index].name),
            subtitle: Text(challenges[index].description),
            trailing: IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.green),
              onPressed: () {
                _showUploadDialog(challenges[index]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures the items are evenly spaced
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              height: 24, // Adjust the size of the icons
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/badges.png',
              height: 24, // Adjust the size of the icons
            ),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/log_activity.png',
              height: 24, // Adjust the size of the icons
            ),
            label: 'Log Activity',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/community.png',
              height: 24, // Adjust the size of the icons
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/profile.png',
              height: 24, // Adjust the size of the icons
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, // Customize selected item color
        unselectedItemColor: Colors.grey, // Customize unselected item color
        backgroundColor: Color(0xFF2E481E), // Customize background color
      ),
    );
  }
}