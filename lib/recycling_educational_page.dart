import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RecyclerEducationalPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  RecyclerEducationalPage({
    required this.userId,
    required this.userName,
    required this.carbonFootprint,
  });

  @override
  _RecyclerEducationalPageState createState() => _RecyclerEducationalPageState();
}

class _RecyclerEducationalPageState extends State<RecyclerEducationalPage> {
  int currentSteps = 0;
  String currentBadgeLevel = 'None';
  int bronzeSteps = 10;
  int silverSteps = 20;
  int goldSteps = 30;
  int userPoints = 0;
  bool rewardShown = false; // To track if reward dialog has been shown

  List<dynamic> diyProjects = [];
  List<dynamic> recyclingBenefits = [];
  List<dynamic> reuseProjects = [];
  List<dynamic> upcyclingIdeas = [];
  List<dynamic> environmentalImpact = [];

  @override
  void initState() {
    super.initState();
    fetchBadgeData();
    fetchRecommendationsOrEducationalContent();
    fetchUserPoints();
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
      });
      checkForRewards();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user points: ${response.body}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

void checkForRewards() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool voucherClaimed = prefs.getBool('voucherClaimed') ?? false;

  if (userPoints >= 300 && !voucherClaimed) {
    _showRewardDialog('You\'ve reached 300 points! Here\'s a Gold Grab Food voucher for 35% off!');
  } else if (userPoints >= 200 && !voucherClaimed) {
    _showRewardDialog('You\'ve reached 200 points! Here\'s a Silver Grab Food voucher for 28% off!');
  } else if (userPoints >= 100 && !voucherClaimed) {
    _showRewardDialog('You\'ve reached 100 points! Here\'s a Bronze Grab Food voucher for 15% off!');
  }
}

void _showRewardDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Congratulations!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Claim Voucher'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('voucherClaimed', true);
              Navigator.of(context).pop();
              // Optionally navigate to a voucher claiming page or perform another action
            },
          ),
        ],
      );
    },
  );
}

  Future<void> claimVoucher(int voucherId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/claim_voucher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'voucher_id': voucherId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Voucher claimed successfully!')),
        );
        // You can also update the UI or state here if needed
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to claim voucher: ${responseData["message"]}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Example usage: Call this function when a user wants to claim a voucher
  void onClaimVoucher(int voucherId) {
    claimVoucher(voucherId);
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
        setState(() {
          final badge = (responseData['badges'] as List)
              .firstWhere((b) => b['name'] == 'Recycler', orElse: () => null);
          if (badge != null) {
            currentSteps = badge['current_steps'];
            currentBadgeLevel = badge['level'];
          }
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

  Future<void> fetchRecommendationsOrEducationalContent() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/recommendations_or_educational/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          diyProjects = responseData['diyProjects'] ?? [];
          recyclingBenefits = responseData['recyclingBenefits'] ?? [];
          reuseProjects = responseData['reuseProjects'] ?? [];
          upcyclingIdeas = responseData['upcyclingIdeas'] ?? [];
          environmentalImpact = responseData['environmentalImpact'] ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch recommendations or educational content: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> logInteraction(int articleId, String category) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:5001/log_interaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': widget.userId,
          'article_id': articleId,
          'category': category,
        }),
      );

      if (response.statusCode == 200) {
        print('Interaction Logged: $articleId, $category');
        updateProgress(category); // Update progress when interaction is logged
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log interaction: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> launchURL(int articleId, String url, String category) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:5001/recommendations_or_educational/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'recommendation_id': articleId,
        }),
      );

      if (response.statusCode == 200) {
        print('Popularity score updated successfully for recommendation_id: $articleId');
        if (await canLaunch(url)) {
          await launch(url);
          logInteraction(articleId, category);  // Log the interaction when the user opens a URL
        } else {
          throw 'Could not launch $url';
        }
      } else {
        print('Failed to update popularity score: ${response.body}');
        throw 'Failed to update popularity score';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void updateProgress(String activity) {
    setState(() {
      currentSteps++;
      if (currentSteps >= goldSteps) {
        currentBadgeLevel = 'Gold';
      } else if (currentSteps >= silverSteps) {
        currentBadgeLevel = 'Silver';
      } else if (currentSteps >= bronzeSteps) {
        currentBadgeLevel = 'Bronze';
      }
    });

    logActivity(activity);
  }

  Future<void> logActivity(String activity) async {
    try {
      final response = await http.post(
        //Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity'),
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/log_activity'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'activity_type': 'Recycler',
          'activity': activity,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Activity Logged: $activity')),
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
  }
Future<void> checkRecyclability() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // Upload the image and get the result from your backend
    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.0.105:5001/predict_recycle'));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body);
      // Handle the result as needed, e.g., show a dialog with the result
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          title: Row(
            children: [
              Icon(
                result['is_recyclable'] ? Icons.check_circle : Icons.cancel,
                color: result['is_recyclable'] ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                result['is_recyclable'] ? 'Recyclable' : 'Not Recyclable',
                style: TextStyle(
                  color: result['is_recyclable'] ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result['is_recyclable']) ...[
                Text(
                  'Item: ${result['predicted_class_name']
                    .split('_')
                    .map((word) => word[0].toUpperCase() + word.substring(1))
                    .join(' ')}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Confidence: ${(result['confidence_score'] * 100).toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      launch(result['url']);
                    },
                    icon: Icon(Icons.info),
                    label: Text(
                      'See How?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF264E36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF264E36),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check recyclability')),
      );
    }
  }
}
  Widget buildSection(String title, List<dynamic> items, {int defaultItemCount = 2}) {
    // If the items list has fewer than the default number of items,
    // fill the remaining slots with placeholders or fetch more items.
    while (items.length < defaultItemCount) {
      items.add({'id': null, 'title': 'More to come...', 'url': '', 'topic': title});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[700]),
        ),
        SizedBox(height: 10),
        ...items.map((item) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(item['title']),
              onTap: item['id'] != null ? () => launchURL(item['id'], item['url'], item['topic']) : null, // Handle article tap to open URL and log the interaction
            ),
          );
        }).take(items.length), // Ensure all items are shown
        SizedBox(height: 20),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushNamed(
          context,
          '/main',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
            'carbonFootprint': widget.carbonFootprint,
          },
        );
      } else if (index == 2) {
        Navigator.pushNamed(context, '/log_activity', arguments: {
          'userId': widget.userId,
          'userName': widget.userName,
          'carbonFootprint': widget.carbonFootprint,
        });
      } else if (index == 1) {
        Navigator.pushNamed(
          context,
          '/badges',
          arguments: {
            'userId': widget.userId,
            'userName': widget.userName,
            'carbonFootprint': widget.carbonFootprint,
          },
        );
      } else if (index == 3) {
        Navigator.pushNamed(context, '/community');
      } else if (index == 4) {
        Navigator.pushNamed(context, '/profile');
      }
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Recycler Educational Hub'),
      backgroundColor: Color(0xFF2E481E),
      foregroundColor: Colors.white,
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learn and Level Up Your Recycler Badge',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[700]),
          ),
          SizedBox(height: 20),
          Text(
            'Upload an image to see if the item is recyclable. Our model will analyze the image and determine if the item belongs to one of the 30 recyclable classes.',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: checkRecyclability,
            child: Text('Check Recyclability'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white
            ),
          ),
          SizedBox(height: 20),
          buildSection('DIY Recycling Projects', diyProjects, defaultItemCount: 2),
          buildSection('Benefits of Recycling', recyclingBenefits, defaultItemCount: 2),
          buildSection('Creative Reuse Ideas', reuseProjects, defaultItemCount: 2),
          buildSection('Upcycling Ideas', upcyclingIdeas, defaultItemCount: 2),
          buildSection('Environmental Impact', environmentalImpact, defaultItemCount: 2),
          SizedBox(height: 20),
          _buildSectionTitle('Progress Tracking'),
          Text('Current Badge Level: $currentBadgeLevel'),
          Text('Steps Completed: $currentSteps'),
          _buildProgressBar(),
        ],
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/home.png', height: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/badges.png', height: 24),
          label: 'Badges',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/log_activity.png', height: 24),
          label: 'Log Activity',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/community.png', height: 24),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/profile.png', height: 24),
          label: 'Profile',
        ),
      ],
      currentIndex: 1,
      onTap: _onItemTapped,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      backgroundColor: Color(0xFF2E481E),
    ),
  );
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
  );
}

Widget _buildContentItem(String title, String activityType) {
  return ListTile(
    title: Text(title),
    trailing: ElevatedButton(
      onPressed: () {
        updateProgress(activityType);
      },
      child: Text('Complete'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
      ),
    ),
  );
}

Widget _buildProgressBar() {
  double progress = currentSteps / goldSteps;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[300],
      color: Colors.green[700],
      minHeight: 10,
    ),
  );
}
}