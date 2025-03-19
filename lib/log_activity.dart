import 'package:flutter/material.dart';
import 'package:fyp/challenges_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_code_scanner_page.dart';
import 'recycling_educational_page.dart';

class LogActivityPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  LogActivityPage({
    required this.userId,
    required this.userName,
    required this.carbonFootprint,
  });

  @override
  _LogActivityPageState createState() => _LogActivityPageState();
}

class _LogActivityPageState extends State<LogActivityPage> {
  String? selectedActivity;
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController carKmController = TextEditingController();
  int _selectedIndex = 2;
  bool _droveToday = false;

  double carEmissionFactor = 0.12; // Example emission factor for cars

  // Activities divided into two categories
  List<String> autoIncrementActivities = ['Daily Habit', 'Green Friend'];
  List<String> userActionActivities = ['Green Commuter', 'Challenge Champ', 'Recycler'];

  List<Badge> badgeData = [
    Badge(
      name: 'Daily Habit',
      description: 'This badge is awarded for incorporating eco-friendly habits into your daily routine.',
      howToAttain: 'Log activities like turning off lights when not in use, using a reusable water bottle, and conserving water daily.',
      bronzeSteps: 0,
      silverSteps: 0,
      goldSteps: 0,
      currentSteps: 0,
      level: 'None'
    ),
    Badge(
      name: 'Green Commuter',
      description: 'This badge is given to those who choose green transportation methods.',
      howToAttain: 'Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.',
      bronzeSteps: 0,
      silverSteps: 0,
      goldSteps: 0,
      currentSteps: 0,
      level: 'None'
    ),
    Badge(
      name: 'Challenge Champ',
      description: 'This badge is awarded for completing sustainability challenges.',
      howToAttain: 'Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.',
      bronzeSteps: 0,
      silverSteps: 0,
      goldSteps: 0,
      currentSteps: 0,
      level: 'None'
    ),
    Badge(
      name: 'Green Friend',
      description: 'This badge is for those who spread awareness about sustainability.',
      howToAttain: 'Log activities like educating others about eco-friendly practices, organizing community clean-ups, and participating in environmental campaigns.',
      bronzeSteps: 0,
      silverSteps: 0,
      goldSteps: 0,
      currentSteps: 0,
      level: 'None'
    ),
    Badge(
      name: 'Recycler',
      description: 'This badge is given for dedication to recycling efforts.',
      howToAttain: 'Log activities like recycling paper, plastic, glass, and electronics, and reducing waste by repurposing items.',
      bronzeSteps: 0,
      silverSteps: 0,
      goldSteps: 0,
      currentSteps: 0,
      level: 'None'
    ),
  ];

  Future<void> logActivity() async {
    if (selectedActivity != null) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'activity_type': selectedActivity!,
            if (selectedActivity == 'Green Commuter') 'origin': originController.text,
            if (selectedActivity == 'Green Commuter') 'destination': destinationController.text,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? lastIncrementDate = prefs.getString('lastIncrementDate');
          String todayDate = DateTime.now().toIso8601String().split('T').first;

          if (lastIncrementDate != todayDate) {
            // Increment the Daily Habit badge
            await incrementDailyHabitBadge();

            // Update the last increment date
            prefs.setString('lastIncrementDate', todayDate);
          }

          // Fetch updated badge data after logging activity
          await fetchBadgeData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Activity Logged: $selectedActivity')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to log activity: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an activity')),
      );
    }
  }

  Future<void> incrementDailyHabitBadge() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/increment_daily_habit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to increment Daily Habit badge')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> fetchBadgeData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/gamification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData); // Debugging line to see the response data

        // Create a map of badge descriptions and how to attain from badgeData
        final Map<String, Badge> badgeDetailsMap = {
          for (var badge in badgeData) badge.name: badge
        };

        // Merge the badge data from the backend with the badge details map
        setState(() {
          badgeData = (responseData['badges'] as List)
              .map((badge) {
                final badgeName = badge['name'];
                if (badgeDetailsMap.containsKey(badgeName)) {
                  return Badge(
                    name: badgeName,
                    bronzeSteps: badge['bronze_steps'],
                    silverSteps: badge['silver_steps'],
                    goldSteps: badge['gold_steps'],
                    currentSteps: badge['current_steps'],
                    level: badge['level'],
                    description: badgeDetailsMap[badgeName]?.description ?? 'No description available',
                    howToAttain: badgeDetailsMap[badgeName]?.howToAttain ?? 'No information available',
                  );
                } else {
                  return Badge.fromJson(badge);
                }
              })
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch badge data: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> logCarUsage(double kilometersDriven) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_car_usage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'kilometers_driven': kilometersDriven,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car usage logged successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log car usage: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeScannerPage(
          userId: widget.userId,
          userName: widget.userName,
          carbonFootprint: widget.carbonFootprint,
        ),
      ),
    );

    if (result != null) {
      // Handle the result from the QR code scanner
      // You can parse the result and pre-fill the origin and destination fields if necessary
      print('QR Code Result: $result');
    }
  }
  void showBadgeDialog(Badge badge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/${badge.name.toLowerCase().replaceAll(" ", "_")}.png', // Ensure you have the corresponding images
                  height: 150,
                  width: 150,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  badge.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  badge.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'How to Attain:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              Text(
                badge.howToAttain,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchBadgeData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Activity'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Did you drive today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: _droveToday,
                  onChanged: (value) {
                    setState(() {
                      _droveToday = value as bool;
                    });
                  },
                ),
                Text('Yes'),
                Radio(
                  value: false,
                  groupValue: _droveToday,
                  onChanged: (value) {
                    setState(() {
                      _droveToday = value as bool;
                    });
                  },
                ),
                Text('No'),
              ],
            ),
            if (_droveToday) ...[
              SizedBox(height: 10),
              TextField(
                controller: carKmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Kilometers driven today',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String kmString = carKmController.text;
                  if (kmString.isNotEmpty) {
                    double kilometersDriven = double.parse(kmString);
                    await logCarUsage(kilometersDriven);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter the kilometers driven')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF264E36), // Background color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 16, fontFamily: 'Lexend', color: Colors.white),
                ),
                child: Text('Log Car Usage', style: TextStyle(color: Colors.white)),
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Green Routines',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 10),
            ...autoIncrementActivities.map((activity) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.green[700]),
                    onPressed: () {
                      final badge = badgeData.firstWhere(
                        (b) => b.name == activity,
                        orElse: () => Badge(
                          name: activity,
                          bronzeSteps: 0,
                          silverSteps: 0,
                          goldSteps: 0,
                          currentSteps: 0,
                          level: 'None',
                          description: 'No description available',
                          howToAttain: 'No information available'
                        ),
                      );
                      showBadgeDialog(badge);
                    },
                  ),
                  title: Text(activity),
                  onTap: () {
                    setState(() {
                      selectedActivity = activity;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Green Missions',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 10),
            ...userActionActivities.map((activity) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.green[700]),
                    onPressed: () {
                      final badge = badgeData.firstWhere(
                        (b) => b.name == activity,
                        orElse: () => Badge(
                          name: activity,
                          bronzeSteps: 0,
                          silverSteps: 0,
                          goldSteps: 0,
                          currentSteps: 0,
                          level: 'None',
                          description: 'No description available',
                          howToAttain: 'No information available'
                        ),
                      );
                      showBadgeDialog(badge);
                    },
                  ),
                  title: Text(activity),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green[700]),
                  onTap: () {
                    setState(() {
                      selectedActivity = activity;
                    });

                    if (activity == 'Green Commuter') {
                      _scanQRCode();
                    } else if (activity == 'Recycler') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecyclerEducationalPage(
                            userId: widget.userId,
                            userName: widget.userName,
                            carbonFootprint: widget.carbonFootprint,
                          ),
                        ),
                      );
                    } else if (activity == 'Challenge Champ') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengeListPage(
                            userId: widget.userId,
                            userName: widget.userName,
                            carbonFootprint: widget.carbonFootprint,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
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
        selectedFontSize: 12,
      ),
    );
  }
}

class Badge {
  final String name;
  final int bronzeSteps;
  final int silverSteps;
  final int goldSteps;
  final int currentSteps;
  final String level;
  final String description;
  final String howToAttain;

  Badge({
    required this.name,
    required this.bronzeSteps,
    required this.silverSteps,
    required this.goldSteps,
    required this.currentSteps,
    required this.level,
    this.description = 'No description available',
    this.howToAttain = 'No information available',
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      name: json['name'] ?? 'Unknown Badge',
      bronzeSteps: json['bronze_steps'] ?? 0,
      silverSteps: json['silver_steps'] ?? 0,
      goldSteps: json['gold_steps'] ?? 0,
      currentSteps: json['current_steps'] ?? 0,
      level: json['level'] ?? 'None',
      description: json['description'] ?? 'No description available',
      howToAttain: json['how_to_attain'] ?? 'No information available',
    );
  }
}