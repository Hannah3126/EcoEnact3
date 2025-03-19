import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class CommunityPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  CommunityPage({
    required this.userId,
    required this.userName,
    required this.carbonFootprint,
  });

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = 3;
  List<dynamic> posts = [];
  dynamic mostPopularArticle;
  int userPoints = 0;
  String userLevel = 'Beginner';

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchUserPoints();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          posts = responseData['posts'];
          mostPopularArticle = responseData['most_popular_article'];
        });
      } else {
        _showSnackBar('Failed to fetch posts');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> fetchUserPoints() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/points'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          userPoints = responseData['points'];
          userLevel = _determineLevel(userPoints);
        });
      } else {
        _showSnackBar('Failed to fetch user points');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  String _determineLevel(int points) {
    if (points >= 90) return 'Eco Master';
    if (points >= 60) return 'Eco Enthusiast';
    if (points >= 30) return 'Eco Warrior';
    return 'Beginner';
  }

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  String _getTimeAgo(String timestamp) {
    DateTime postTime = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else {
      return '${difference.inHours} h ago';
    }
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

  void _navigateToCreatePost() async {
    final result = await Navigator.pushNamed(
      context,
      '/create_post',
      arguments: {
        'userId': widget.userId,
        'userName': widget.userName,
      },
    );

    if (result == true) {
      fetchPosts(); // Refresh posts after creating a new one
      logPostActivity(); // Log the activity
    }
  }

  Future<void> logPostActivity() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'activity_type': 'Green Friend',
        }),
      );

      if (response.statusCode != 200) {
        _showSnackBar('Failed to log activity');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _navigateToLeaderboard() {
    Navigator.pushNamed(context,'/leaderboard', arguments: {
      'userId': widget.userId,
      'userName': widget.userName,
      'carbonFootprint': widget.carbonFootprint,
    });
  }

  void _showLevelInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Level Information',
            style: TextStyle(color: Color(0xFF2E481E), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Levels indicate your progress and engagement in eco-friendly activities from badges. Here are the levels:',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '• Beginner: Less than 30 points',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Eco Warrior: 30 - 59 points',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Eco Enthusiast: 60 - 89 points',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Eco Master: 90+ points',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Each badge level is 10 points! Keep participating in activities to improve your level!',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Color(0xFF2E481E)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToCreatePost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _navigateToCreatePost,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Make a Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF264E36),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _navigateToLeaderboard,
                  icon: Icon(Icons.leaderboard, color: Colors.white),
                  label: Text('Leaderboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF264E36),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Most Popular Article',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
            SizedBox(height: 20),
            _buildMostPopularArticle(),
            SizedBox(height: 20),
            Text(
              'Community Discussions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
            SizedBox(height: 20),
            // Display posts from database
            for (var post in posts)
              _buildPost(post['user_name'], post['content'], _getTimeAgo(post['timestamp'])),
          ],
        ),
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

  Widget _buildUserProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/leaf_background.png'), // Add your profile image here
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Carbon Footprint: ${widget.carbonFootprint.toStringAsFixed(2)} CO2 e/kg',
              style: TextStyle(fontSize: 13, color: Colors.green[700],fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _showLevelInfo,
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'Level: $userLevel',
                  style: TextStyle(fontSize: 13, color: Colors.green[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPost(String author, String content, String timestamp) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              timestamp,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostPopularArticle() {
    if (mostPopularArticle == null) {
      return SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mostPopularArticle['title'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              mostPopularArticle['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                launch(mostPopularArticle['url']);
              },
              child: Text('Read More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF264E36),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}