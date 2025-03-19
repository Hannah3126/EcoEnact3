import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'main_page.dart';
import 'badges_page.dart';
import 'log_activity.dart';
import 'carbon_footprint_survey.dart';
import 'profile_page.dart';
import 'log_food_page.dart';
import 'tips_page.dart';
import 'challenges_page.dart';
import 'recycling_educational_page.dart';
import 'community_page.dart';
import 'create_post.dart';
import 'leaderboard_page.dart';
import 'user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'voucher_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: EcoEnactApp(),
    ),
  );
}

class EcoEnactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lexend',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;
        if (settings.name == '/main') {
          return MaterialPageRoute(
            builder: (context) {
              return MainPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/log_activity') {
          return MaterialPageRoute(
            builder: (context) {
              return LogActivityPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/badges') {
          return MaterialPageRoute(
            builder: (context) {
              return BadgesPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/survey') {
          return MaterialPageRoute(
            builder: (context) {
              return SurveyPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
                maxValue: args['maxValue'],
                scaledFootprint: args['scaledFootprint'],
              );
            },
          );
        } else if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) {
              return ProfilePage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/log_food') {
          return MaterialPageRoute(
            builder: (context) {
              return LogFoodPage(userId: args['userId']);
            },
          );
        } else if (settings.name == '/tips') {
          return MaterialPageRoute(
            builder: (context) {
              return TipsPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/challenges') {
          return MaterialPageRoute(
            builder: (context) {
              return ChallengeListPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/recycler_educational') {
          return MaterialPageRoute(
            builder: (context) {
              return RecyclerEducationalPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/community') {
          return MaterialPageRoute(
            builder: (context) {
              return CommunityPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/create_post') {
          return MaterialPageRoute(
            builder: (context) {
              return CreatePostPage(
                userId: args['userId'],
                userName: args['userName'],
              );
            },
          );
        } else if (settings.name == '/leaderboard') {
          return MaterialPageRoute(
            builder: (context) {
              return LeaderboardPage(
                userId: args['userId'],
                userName: args['userName'],
                carbonFootprint: args['carbonFootprint'],
              );
            },
          );
        } else if (settings.name == '/vouchers') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return UserVouchersPage(
                userId: args['userId'], // Ensure 'userId' is provided here
              );
            },
          );
        }
        return null;
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/leaf_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/green_blob.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EcoEnact',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Reduce. Reuse. Enact',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF91A37F),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _checkIfNewUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF264E36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    child: Text(
                      'ENACT NOW',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkIfNewUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isNewUser = prefs.getBool('isNewUser') ?? true;

    if (isNewUser) {
      _showCarbonFootprintDialog(context);
      await prefs.setBool('isNewUser', false);
    } else {
      Navigator.pushNamed(context, '/signup');
    }
  }

  void _showCarbonFootprintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What is Carbon Footprint?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A carbon footprint is the total amount of greenhouse gases, including carbon dioxide and methane, that are generated by our actions.'),
                SizedBox(height: 10),
                Text('It includes activities such as driving a car, using electricity, and the lifecycle of products we use. Reducing your carbon footprint helps to reduce global warming and climate change.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}