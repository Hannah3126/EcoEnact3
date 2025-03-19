import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'challenges_page.dart';

class BadgesPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  BadgesPage({required this.userId, required this.userName, required this.carbonFootprint});

  @override
  _BadgesPageState createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  int _selectedIndex = 1;
  List<Badge> badges = [
    Badge(
      name: 'Daily Habit',
      imagePath: 'assets/images/daily_habit.png',
      bronzeSteps: 10,
      silverSteps: 20,
      goldSteps: 30,
      currentSteps: 0,
      level: 'Bronze',
      description: 'This badge is awarded for incorporating eco-friendly habits into your daily routine.',
      howToAttain: 'Log activities like turning off lights when not in use, using a reusable water bottle, and conserving water daily.',
    ),
    Badge(
      name: 'Green Commuter',
      imagePath: 'assets/images/green_commuter.png',
      bronzeSteps: 10,
      silverSteps: 20,
      goldSteps: 30,
      currentSteps: 0,
      level: 'Bronze',
      description: 'This badge is given to those who choose green transportation methods.',
      howToAttain: 'Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.',
    ),
    Badge(
      name: 'Challenge Champ',
      imagePath: 'assets/images/challenge_champ.png',
      bronzeSteps: 10,
      silverSteps: 20,
      goldSteps: 30,
      currentSteps: 0,
      level: 'Bronze',
      description: 'This badge is awarded for completing sustainability challenges.',
      howToAttain: 'Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.',
    ),
    Badge(
      name: 'Green Friend',
      imagePath: 'assets/images/green_friend.png',
      bronzeSteps: 10,
      silverSteps: 20,
      goldSteps: 30,
      currentSteps: 0,
      level: 'Bronze',
      description: 'This badge is for those who spread awareness about sustainability.',
      howToAttain: 'Log activities like educating others about eco-friendly practices, organizing community clean-ups, and participating in environmental campaigns.',
    ),
    Badge(
      name: 'Recycler',
      imagePath: 'assets/images/recycler.png',
      bronzeSteps: 10,
      silverSteps: 20,
      goldSteps: 30,
      currentSteps: 0,
      level: 'Bronze',
      description: 'This badge is given for dedication to recycling efforts.',
      howToAttain: 'Log activities like recycling paper, plastic, glass, and electronics, and reducing waste by repurposing items.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchBadgeData();
  }

  Future<void> fetchBadgeData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/gamification'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<Badge> fetchedBadges = (responseData['badges'] as List)
            .map((badge) => Badge.fromJson(badge as Map<String, dynamic>))
            .toList();

        setState(() {
          badges = badges.map((preBadge) {
            Badge? fetchedBadge = fetchedBadges.firstWhere(
              (fb) => fb.name == preBadge.name,
              orElse: () => preBadge.copyWith(currentSteps: 0, level: 'None'),
            );
            return fetchedBadge;
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch badge data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushNamed(
      context,
      _getRouteForIndex(index),
      arguments: {
        'userId': widget.userId,
        'userName': widget.userName,
        'carbonFootprint': widget.carbonFootprint,
      },
    );
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0: return '/main';
      case 1: return '/badges';
      case 2: return '/log_activity';
      case 3: return '/community';
      case 4: return '/profile';
      case 5: return '/challenges';
      default: return '/main';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Badges'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return BadgeItem(
            badge: badge,
            userId: widget.userId,
            userName: widget.userName,
            carbonFootprint: widget.carbonFootprint,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          _buildBottomNavigationBarItem('assets/icons/home.png', 'Home'),
          _buildBottomNavigationBarItem('assets/icons/badges.png', 'Badges'),
          _buildBottomNavigationBarItem('assets/icons/log_activity.png', 'Log Activity'),
          _buildBottomNavigationBarItem('assets/icons/community.png', 'Community'),
          _buildBottomNavigationBarItem('assets/icons/profile.png', 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF2E481E),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        height: 24,
      ),
      label: label,
    );
  }
}

class BadgeItem extends StatelessWidget {
  final Badge badge;
  final int userId;
  final String userName;
  final double carbonFootprint;

  BadgeItem({required this.badge, required this.userId, required this.userName, required this.carbonFootprint});

  @override
  Widget build(BuildContext context) {
    int bronzeSteps = badge.bronzeSteps;
    int silverSteps = badge.silverSteps;
    int goldSteps = badge.goldSteps;
    int currentSteps = badge.currentSteps;

    return GestureDetector(
      onTap: () {
        if (badge.name == 'Challenge Champ') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeListPage(
                userId: userId,
                userName: userName,
                carbonFootprint: carbonFootprint,
              ),
            ),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    badge.imagePath,
                    width: 110,
                    height: 110,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        badge.name,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          progressCircle('Bronze', currentSteps, bronzeSteps, silverSteps, goldSteps, Colors.brown),
                          progressCircle('Silver', currentSteps, bronzeSteps, silverSteps, goldSteps, Colors.grey),
                          progressCircle('Gold', currentSteps, bronzeSteps, silverSteps, goldSteps, Colors.amber),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: currentSteps / (bronzeSteps + silverSteps + goldSteps),
                backgroundColor: Colors.grey[300],
                color: Colors.green[700],
              ),
              SizedBox(height: 10),
              Text(
                'Progress: $currentSteps/${bronzeSteps + silverSteps + goldSteps} steps',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget progressCircle(String level, int currentSteps, int bronzeSteps, int silverSteps, int goldSteps, Color color) {
  int stepsForLevel = 0;
  int requiredSteps = 0;
  bool isLocked = false;

  switch (level) {
    case 'Bronze':
      stepsForLevel = currentSteps.clamp(0, bronzeSteps);
      requiredSteps = bronzeSteps;
      break;
    case 'Silver':
      stepsForLevel = (currentSteps - bronzeSteps).clamp(0, silverSteps);
      requiredSteps = silverSteps;
      isLocked = currentSteps < bronzeSteps;
      break;
    case 'Gold':
      stepsForLevel = (currentSteps - bronzeSteps - silverSteps).clamp(0, goldSteps);
      requiredSteps = goldSteps;
      isLocked = currentSteps < bronzeSteps + silverSteps;
      break;
  }

  double progress = stepsForLevel / requiredSteps;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: isLocked ? 0.0 : progress,
                backgroundColor: Colors.grey[300],
                color: color,
                strokeWidth: 6,
              ),
            ),
            isLocked
                ? Icon(Icons.lock, color: color)
                : Text(
                    '$stepsForLevel/$requiredSteps',
                    style: TextStyle(fontSize: 12),
                  ),
          ],
        ),
        SizedBox(height: 8),
        Text(level, style: TextStyle(fontSize: 14)),
      ],
    ),
  );
}

class Badge {
  final String name;
  final String imagePath;
  final int bronzeSteps;
  final int silverSteps;
  final int goldSteps;
  int currentSteps;
  String level;
  String description;
  String howToAttain;

  Badge({
    required this.name,
    required this.imagePath,
    required this.bronzeSteps,
    required this.silverSteps,
    required this.goldSteps,
    this.currentSteps = 0,
    this.level = 'Bronze',
    this.description = 'No description available',
    this.howToAttain = 'No information available',
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      name: json['name'] ?? 'Unknown',
      imagePath: 'assets/images/${json['name'].toLowerCase().replaceAll(' ', '_')}.png',
      bronzeSteps: json['bronze_steps'],
      silverSteps: json['silver_steps'],
      goldSteps: json['gold_steps'],
      currentSteps: json['current_steps'],
      level: json['level'],
      description: json['description'] ?? 'No description available',
      howToAttain: json['how_to_attain'] ?? 'No information available',
    );
  }

  Badge copyWith({
    String? name,
    String? imagePath,
    int? bronzeSteps,
    int? silverSteps,
    int? goldSteps,
    int? currentSteps,
    String? level,
    String? description,
    String? howToAttain,
  }) {
    return Badge(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      bronzeSteps: bronzeSteps ?? this.bronzeSteps,
      silverSteps: silverSteps ?? this.silverSteps,
      goldSteps: goldSteps ?? this.goldSteps,
      currentSteps: currentSteps ?? this.currentSteps,
      level: level ?? this.level,
      description: description ?? this.description,
      howToAttain: howToAttain ?? this.howToAttain,
    );
  }
}