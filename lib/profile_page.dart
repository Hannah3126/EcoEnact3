import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  ProfilePage({required this.userId, required this.userName, required this.carbonFootprint});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[800]),
                ),
                SizedBox(width: 20),
                Text(
                  userName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 40),
            ListTile(
              title: Text('View Badges'),
              onTap: () {
                Navigator.pushNamed(context, '/badges', arguments: {
                  'userId': userId,
                  'userName': userName,
                  'carbonFootprint': carbonFootprint,
                });
              },
            ),
            Divider(),
            ListTile(
              title: Text('Check Vouchers'),
              onTap: () {
                Navigator.pushNamed(context, '/vouchers', arguments: {
                  'userId': userId,
                });
              },
            ),
            Divider(),
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                // Navigate to edit profile page
              },
            ),
            Divider(),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            Divider(),
            ListTile(
              title: Text('Help and Support'),
              onTap: () {
                // Navigate to help and support page
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () => _logout(context),
            ),
            Divider(),
          ],
        ),
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
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/main', arguments: {
                'userId': userId,
                'userName': userName,
                'carbonFootprint': carbonFootprint,
              });
              break;
            case 2:
              Navigator.pushNamed(context, '/log_activity', arguments: {
                'userId': userId,
                'userName': userName,
                'carbonFootprint': carbonFootprint,
              });
              break;
            case 1:
              Navigator.pushNamed(context, '/badges', arguments: {
                'userId': userId,
                'userName': userName,
                'carbonFootprint': carbonFootprint,
              });
              break;
            case 3:
              Navigator.pushNamed(context, '/community', arguments: {
                'userId': userId,
                'userName': userName,
                'carbonFootprint': carbonFootprint,
              });
              break;
            case 4:
              Navigator.pushNamed(context, '/profile', arguments: {
                'userId': userId,
                'userName': userName,
                'carbonFootprint': carbonFootprint,
              });
              break;
          }
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF2E481E),
      ),
    );
  }
}