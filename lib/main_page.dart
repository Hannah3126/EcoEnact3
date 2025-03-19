import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class MainPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;

  MainPage({
    required this.userId,
    required this.userName,
    required this.carbonFootprint,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  double _circleTopPadding = 100; // Moved lower for half-circle meter
  double _imageTopPadding = 270; // Moved lower for image
  double? updatedCarbonFootprint;
  double? dailyCarbonFootprint;

  String selectedPeriod = 'daily'; // Default selected period

  final List<String> didYouKnowFacts = [
    "Recycling one aluminum can saves enough energy to power a TV for three hours!",
    "A single tree can absorb up to 48 pounds of carbon dioxide per year.",
    "Switching to energy-efficient LED bulbs can reduce your carbon footprint by up to 80%.",
    "Taking shorter showers can save up to 150 gallons of water per month.",
    "If every American recycled just one-tenth of their newspapers, we could save about 25 million trees each year.",
    "Carpooling with friends can cut your carbon emissions in half.",
    "Turning off lights when you leave a room can save up to 400 pounds of carbon dioxide emissions a year.",
    "Producing one ton of paper from recycled paper saves up to 17 trees and 7,000 gallons of water.",
    "Using public transportation instead of driving alone can save an average of 4,800 pounds of carbon dioxide per year.",
    "The average person generates over 4 pounds of trash every day and about 1.5 tons of solid waste per year.",
    "Composting organic waste can reduce the amount of trash you send to the landfill by up to 30%.",
    "An average family uses 182 gallons of water per week just by flushing the toilet.",
    "Recycling plastic saves twice as much energy as burning it in an incinerator.",
    "Air drying your clothes instead of using a dryer can save up to 2,400 pounds of CO2 emissions a year.",
    "Replacing a single beef meal with a plant-based meal can save the carbon equivalent of driving 30 miles.",
    "By 2050, there could be more plastic in the ocean than fish if current trends continue.",
    "Each year, the U.S. alone throws away enough plastic bottles to circle the Earth four times.",
    "Planting a garden can help reduce greenhouse gases by absorbing CO2 and releasing oxygen.",
    "One reusable bag can save up to 700 plastic bags from ending up in the ocean.",
    "The average American uses 7 trees worth of paper, wood, and other products made from trees each year."
  ];

  late String didYouKnowFact;

  @override
  void initState() {
    super.initState();
    final random = Random();
    didYouKnowFact = didYouKnowFacts[random.nextInt(didYouKnowFacts.length)];
    updatedCarbonFootprint = widget.carbonFootprint;
    _fetchUpdatedCarbonFootprint();
    _fetchDailyCarbonFootprint();
  }

    Future<void> _fetchUpdatedCarbonFootprint() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/carbon_footprint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          updatedCarbonFootprint = jsonDecode(response.body)['carbon_footprint'];
        });
      } else {
        print('Failed to fetch updated carbon footprint: ${response.body}');
      }
    } catch (e) {
      print('Error fetching updated carbon footprint: $e');
    }
  }

    Future<void> _fetchDailyCarbonFootprint() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/carbon_footprint_period?period=$selectedPeriod'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          dailyCarbonFootprint = jsonDecode(response.body)['carbon_footprint'];
        });
      } else {
        print('Failed to fetch daily carbon footprint: ${response.body}');
      }
    } catch (e) {
      print('Error fetching daily carbon footprint: $e');
    }
  }


  void _onPeriodChanged(String? newPeriod) {
    if (newPeriod != null && newPeriod != selectedPeriod) {
      setState(() {
        selectedPeriod = newPeriod;
      });
      _fetchDailyCarbonFootprint();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUpdatedCarbonFootprint();
    _fetchDailyCarbonFootprint();
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.carbonFootprint != oldWidget.carbonFootprint) {
      _fetchUpdatedCarbonFootprint();
      _fetchDailyCarbonFootprint();
    }
  }

    void _onItemTapped(int index) async {
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

  String getCarbonFootprintMessage(double carbonFootprint) {
    if (carbonFootprint < 6000) {
      return "You emit less CO2 than what is absorbed by three mature trees in a year.";
    } else if (carbonFootprint < 16000) {
      return "lower than the average annual emissions of a typical household.";
    } else if (carbonFootprint < 22000) {
      return "equivalent to the average emissions of a person in a developed country.";
    } else {
      return "higher than the average emissions of a person in a developed country. Please take action.";
    }
  }

  Color getStatusColor2(double carbonFootprint) {
    if (carbonFootprint < 6000) {
      return Colors.blue;
    } else if (carbonFootprint < 16000) {
      return Colors.green;
    } else if (carbonFootprint < 22000) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }
  @override
  Widget build(BuildContext context) {
    Color carbonFootprintColor = getStatusColor2(updatedCarbonFootprint ?? widget.carbonFootprint);
    double displayCarbonFootprint = updatedCarbonFootprint ?? widget.carbonFootprint;
    double displayDailyCarbonFootprint = dailyCarbonFootprint ?? 0.0;


    return Scaffold(
      appBar: AppBar(
        title: Text('EcoEnact Home'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Welcome, ${widget.userName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: 'Lexend'),
                      children: [
                        TextSpan(text: 'Your carbon footprint is '),
                        TextSpan(
                          text: '${displayCarbonFootprint.toStringAsFixed(2)} CO2 e/kg',
                          style: TextStyle(color: carbonFootprintColor, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' which is ${getCarbonFootprintMessage(displayCarbonFootprint)}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                CustomPaint(
                  size: Size(300, 150),
                  painter: HalfCirclePainter(displayCarbonFootprint),
                ),
              ],
            ),
          ),
          Positioned(
            top: _imageTopPadding,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/trees.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/log_food',
                          arguments: {
                            'userId': widget.userId,
                          },
                        );
                      },
                      child: Text(
                        'Log Food',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF264E36),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 16, fontFamily: 'Lexend', color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/tips',
                          arguments: {
                            'userId': widget.userId,
                            'userName': widget.userName,
                            'carbonFootprint': displayCarbonFootprint,
                          },
                        );
                      },
                      child: Text(
                        'View Tips',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF264E36),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 16, fontFamily: 'Lexend', color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: 'daily',
                          groupValue: selectedPeriod,
                          onChanged: _onPeriodChanged,
                        ),
                        Text('Daily'),
                        Radio<String>(
                          value: 'weekly',
                          groupValue: selectedPeriod,
                          onChanged: _onPeriodChanged,
                        ),
                        Text('Weekly'),
                        Radio<String>(
                          value: 'monthly',
                          groupValue: selectedPeriod,
                          onChanged: _onPeriodChanged,
                        ),
                        Text('Monthly'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your Carbon Footprint ($selectedPeriod):',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      '${displayDailyCarbonFootprint.toStringAsFixed(2)} CO2 e/kg',
                      style: TextStyle(fontSize: 18, color: carbonFootprintColor),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      color: Color(0xFFCFDA97),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Did you know?',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              didYouKnowFact,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: _circleTopPadding + 60,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(300, 150),
              painter: ArrowPainter(displayCarbonFootprint),
            ),
          ),
        ],
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

  String getStatus(double carbonFootprint) {
    if (carbonFootprint < 6000) {
      return 'Very Low';
    } else if (carbonFootprint < 16000) {
      return 'Low';
    } else if (carbonFootprint < 22000) {
      return 'Average';
    } else {
      return 'High';
    }
  }

  Color getStatusColor(String status) {
    if (status == 'Very Low') {
      return Colors.blue;
    } else if (status == 'Low') {
      return Colors.green;
    } else if (status == 'Average') {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

class HalfCirclePainter extends CustomPainter {
  final double carbonFootprint;

  HalfCirclePainter(this.carbonFootprint);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background arc
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40.0;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height),
        width: size.width,
        height: size.height * 2,
      ),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Determine the gradient colors based on the carbon footprint
    List<Color> colors;
    double maxFootprint = carbonFootprint > 22000 ? carbonFootprint : 22000;

    if (maxFootprint <= 22000) {
      // Normal range gradient
      colors = [
        Colors.green,
        Colors.green[300]!,
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ];
    } else {
      // Exceptionally high range gradient
      colors = [
        Colors.red,
        Colors.red[600]!,
        Colors.red[700]!,
        Colors.red[800]!,
        Colors.red[900]!,
      ];
    }

    Paint gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40.0;

    double wedgeAngle = pi / 5;
    for (int i = 0; i < 5; i++) {
      gradientPaint.shader = LinearGradient(
        colors: [
          colors[i],
          colors[i], // Each segment has a solid color
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCenter(
        center: Offset(size.width / 2, size.height),
        width: size.width,
        height: size.height * 2,
      ));

      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height),
          width: size.width,
          height: size.height * 2,
        ),
        pi + wedgeAngle * i,
        wedgeAngle,
        false,
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ArrowPainter extends CustomPainter {
  final double carbonFootprint;

  ArrowPainter(this.carbonFootprint);

  @override
  void paint(Canvas canvas, Size size) {
    double maxFootprint = 22000;
    double adjustedFootprint = carbonFootprint;

    if (carbonFootprint > maxFootprint) {
      // Dynamic scaling for values above 22000
      double additionalScaleFactor = 10000; // Adjust as needed for your scale
      adjustedFootprint = 22000 + ((carbonFootprint - 22000) / additionalScaleFactor);
    }

    double sweepAngle = (adjustedFootprint / maxFootprint) * pi;
    double arrowAngle = pi + sweepAngle;
    double arrowLength = size.width / 2 - 40;
    double baseX = size.width / 2 + arrowLength * cos(arrowAngle);
    double baseY = size.height + arrowLength * sin(arrowAngle);
    double tipX = size.width / 2;
    double tipY = size.height;

    Paint arrowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Path arrowPath = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(tipX + 10 * sin(arrowAngle), tipY - 10 * cos(arrowAngle))
      ..lineTo(baseX, baseY)
      ..lineTo(tipX - 10 * sin(arrowAngle), tipY + 10 * cos(arrowAngle))
      ..close();

    canvas.drawPath(arrowPath, arrowPaint);
    // Draw the circle at the wide end of the arrow
    Paint circlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(tipX, tipY), 10, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
    String getStatus(double carbonFootprint) {
    if (carbonFootprint < 6000) {
      return 'Very Low';
    } else if (carbonFootprint < 16000) {
      return 'Low';
    } else if (carbonFootprint < 22000) {
      return 'Average';
    } else {
      return 'High';
    }
  }

  Color getStatusColor(String status) {
    if (status == 'Very Low') {
      return Colors.blue;
    } else if (status == 'Low') {
      return Colors.green;
    } else if (status == 'Average') {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }