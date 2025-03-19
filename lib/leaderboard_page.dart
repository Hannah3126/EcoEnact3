import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  LeaderboardPage({required this.userId, required this.userName, required this.carbonFootprint});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _criteria = 'carbon_footprint';
  List<dynamic> _leaderboard = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    print("Fetching leaderboard data for criteria: $_criteria");
    final response = await http.get(
      Uri.parse('http://192.168.0.105:5001/leaderboard/$_criteria'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _leaderboard = jsonDecode(response.body);
        print("Leaderboard data fetched: $_leaderboard");
      });
    } else {
      print("Failed to fetch leaderboard data: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch leaderboard data')),
      );
    }
  }

  void _updateCriteria(String criteria) {
    setState(() {
      _criteria = criteria;
    });
    _fetchLeaderboardData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Map<String, dynamic> arguments = {
      'userId': widget.userId,
      'userName': widget.userName,
      'carbonFootprint': widget.carbonFootprint,
    };

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/main', arguments: arguments);
        break;
      case 1:
        Navigator.pushNamed(context, '/badges', arguments: arguments);
        break;
      case 2:
        Navigator.pushNamed(context, '/log_activity', arguments: arguments);
        break;
      case 3:
        Navigator.pushNamed(context, '/community', arguments: arguments);
        break;
      case 4:
        Navigator.pushNamed(context, '/profile', arguments: arguments);
        break;
    }
  }

  Widget _buildLeaderboardItem(dynamic user, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green[700],
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user['full_name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _criteria == 'carbon_footprint'
                    ? 'CO2 Footprint: ${user['carbon_footprint']}'
                    : 'Points: ${user['points']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF264E36),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                fillColor: Colors.green,
                selectedColor: Colors.white,
                color: Colors.white,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('CO2 Footprint'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Points'),
                  ),
                ],
                onPressed: (int index) {
                  if (index == 0) {
                    _updateCriteria('carbon_footprint');
                  } else {
                    _updateCriteria('points');
                  }
                },
                isSelected: [
                  _criteria == 'carbon_footprint',
                  _criteria == 'points',
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final user = _leaderboard[index];
                return _buildLeaderboardItem(user, index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/badges.png',
              height: 24,
            ),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/log_activity.png',
              height: 24,
            ),
            label: 'Log Activity',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/community.png',
              height: 24,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/profile.png',
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF2E481E),
        selectedFontSize: 12,
      ),
    );
  }
}