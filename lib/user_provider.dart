import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _points = 0;

  int get points => _points;

  void addPoints(int points, BuildContext context) {
    _points += points;
    notifyListeners();
    _checkVoucherEligibility(context);
  }

  void _checkVoucherEligibility(BuildContext context) {
    if (_points >= 100) {
      _showVoucherDialog(context);
    }
  }

  void _showVoucherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have reached a new milestone in your journey to sustainability!'),
                SizedBox(height: 10),
                Text('As a reward, you have earned a Grab Food voucher. Enjoy your meal and keep up the great work!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Claim Voucher'),
              onPressed: () {
                Navigator.of(context).pop();
                // Additional logic for claiming the voucher can be added here
              },
            ),
          ],
          backgroundColor: Color(0xFF2E481E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }
}