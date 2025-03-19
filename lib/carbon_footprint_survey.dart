import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_page.dart';

class SurveyPage extends StatefulWidget {
  final int userId;
  final String userName;
  final double carbonFootprint;
  final double maxValue; // Maximum value for scaling
  final double scaledFootprint; // Scaled footprint percentage

  SurveyPage({
    required this.userId,
    required this.userName,
    required this.carbonFootprint,
    required this.maxValue, // Add maxValue parameter
    required this.scaledFootprint, // Add scaledFootprint parameter
  });

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _electricityBillController = TextEditingController();
  final TextEditingController _carMileageController = TextEditingController();
  final TextEditingController _flightsController = TextEditingController();
  final TextEditingController _meatConsumptionController = TextEditingController();
  bool _isLoading = false;
  bool _usesCar = false;
  double _carbonFootprint = 0.0;
  String _currency = 'USD';
  List<String> _countrySuggestions = [];

  Future<void> _fetchCurrency(String country) async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/name/$country?fullText=true'));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        setState(() {
          _currency = responseData[0]['currencies'].values.first['symbol'] ?? 'USD';
        });
      }
    }
  }

  Future<void> _fetchCountrySuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _countrySuggestions = [];
      });
      return;
    }
    final response = await http.get(Uri.parse('https://api.first.org/data/v1/countries?q=$query'));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final countriesData = responseData['data'] as Map<String, dynamic>;
      setState(() {
        _countrySuggestions = countriesData.entries
            .map((entry) => entry.value['country'] as String)
            .toList();
      });
    }
  }

  Future<void> _submitSurvey() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Fetch price per kWh from the backend
        final priceResponse = await http.get(
          Uri.parse('http://192.168.0.105:5001/get_price_per_kwh?country=${_countryController.text}')
        );

        if (priceResponse.statusCode != 200) {
          throw Exception('Failed to fetch electricity price.');
        }

        final priceData = jsonDecode(priceResponse.body);
        final pricePerKwh = priceData['price_per_kwh_usd'];
        final exchangeRate = priceData['exchange_rate'];

        final electricityBill = double.tryParse(_electricityBillController.text) ?? 0;
        final electricityBillUsd = electricityBill / exchangeRate;
        final electricityUsageKwh = electricityBillUsd / pricePerKwh;

        final response = await http.post(
          Uri.parse('http://192.168.0.105:5001/user/${widget.userId}/submit_survey'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'country': _countryController.text,
            'electricity_bill': electricityBill,
            'electricity_usage_kwh': electricityUsageKwh,
            'car_mileage_km': _usesCar ? (double.tryParse(_carMileageController.text) ?? 0) : 0,
            'flights_per_year': int.tryParse(_flightsController.text) ?? 0,
            'meat_consumption_per_week': int.tryParse(_meatConsumptionController.text) ?? 0,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          setState(() {
            _carbonFootprint = responseData['carbon_footprint'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(
                userId: widget.userId,
                userName: widget.userName,
                carbonFootprint: _carbonFootprint,
              ),
            ),
          );
        } else {
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit survey: ${responseData['message']}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Carbon Footprint Survey'),
      backgroundColor: Color(0xFF2E481E),
      foregroundColor: Colors.white,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) async {
                  await _fetchCurrency(value);
                  await _fetchCountrySuggestions(value);
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              if (_countrySuggestions.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _countrySuggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_countrySuggestions[index]),
                        onTap: () {
                          _countryController.text = _countrySuggestions[index];
                          _countrySuggestions.clear();
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              TextFormField(
                controller: _electricityBillController,
                decoration: InputDecoration(
                  labelText: 'Electricity Bill ($_currency/month)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your electricity bill';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                value: _usesCar,
                items: [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text('Yes'),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text('No'),
                  ),
                ],
                onChanged: (bool? newValue) {
                  setState(() {
                    _usesCar = newValue ?? false;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Do you use a car?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (_usesCar) ...[
                SizedBox(height: 16),
                TextFormField(
                  controller: _carMileageController,
                  decoration: InputDecoration(
                    labelText: 'Car Mileage (km/year)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your car mileage';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 16),
              TextFormField(
                controller: _flightsController,
                decoration: InputDecoration(
                  labelText: 'Number of Flights per Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of flights you take per year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _meatConsumptionController,
                decoration: InputDecoration(
                  labelText: 'Meat Consumption (times per week)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your meat consumption per week';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: ElevatedButton(
                        onPressed: _submitSurvey,
                        child: Text('Submit Survey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E481E),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 16),
              Text(
                'Your estimated carbon footprint: $_carbonFootprint kg CO2/year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}