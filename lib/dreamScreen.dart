import 'package:flutter/material.dart';
import 'dreamInterpretation.dart';

class EnterDreamScreen extends StatefulWidget {
  @override
  _EnterDreamScreenState createState() => _EnterDreamScreenState();
}

class _EnterDreamScreenState extends State<EnterDreamScreen> {
  TextEditingController _dreamController = TextEditingController();
  String _selectedReligion = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your dream',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _dreamController,
                  decoration: InputDecoration(
                    hintText: 'Type your dream here...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 16),
                RadioListTile<String>(
                  title: Text('Christian'),
                  value: 'Christian',
                  groupValue: _selectedReligion,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedReligion = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Muslim'),
                  value: 'Muslim',
                  groupValue: _selectedReligion,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedReligion = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DreamInterpretScreen(
                        textEditingController: _dreamController,
                        religion: _selectedReligion)),
              );
            },
            child: Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
