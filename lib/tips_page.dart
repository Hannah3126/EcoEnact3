import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  TipsPage({required this.userId, required this.userName, required this.carbonFootprint});

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> tips = [
    {
      "title": "Use Public Transport",
      "description": "Hop on the bus or train and save the planet while you travel!",
      //"icon": "assets/icons/public_transport.png" // Add the appropriate icon path
    },
    {
      "title": "Plant a Tree",
      "description": "Planting trees is a great way to offset carbon emissions.",
      //"icon": "assets/icons/tree.png" // Add the appropriate icon path
    },
    {
      "title": "Reduce, Reuse, Recycle",
      "description": "Embrace the 3 R's and minimize waste in your daily life.",
      //"icon": "assets/icons/recycle.png" // Add the appropriate icon path
    },
    {
      "title": "Switch to LEDs",
      "description": "LEDs use less energy and last longer than traditional bulbs.",
      //"icon": "assets/icons/led.png" // Add the appropriate icon path
    },
    {
      "title": "Eat Less Meat",
      "description": "Try going meatless for a day or two each week!",
      //"icon": "assets/icons/vegetarian.png" // Add the appropriate icon path
    },
    {
      "title": "Carpool",
      "description": "Share a ride with friends and reduce your carbon footprint.",
      //"icon": "assets/icons/carpool.png" // Add the appropriate icon path
    },
    {
      "title": "Save Water",
      "description": "Turn off the tap while brushing your teeth and save water.",
      //"icon": "assets/icons/water.png" // Add the appropriate icon path
    },
    {
      "title": "Use Reusable Bags",
      "description": "Ditch the plastic bags and bring your own reusable ones.",
      //"icon": "assets/icons/reusable_bag.png" // Add the appropriate icon path
    }
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      case 1:
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
      case 2:
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reduce Your Footprint'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              // leading: Image.asset(tips[index]['icon']!, width: 50, height: 50), // Commented out for now
              title: Text(
                tips[index]['title']!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              subtitle: Text(
                tips[index]['description']!,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
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
              'assets/icons/log_activity.png',
              height: 24, // Adjust the size of the icons
            ),
            label: 'Log Activity',
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