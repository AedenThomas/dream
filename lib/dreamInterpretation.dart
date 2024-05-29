// Assuming you have the TextEditingController from the previous screen
// and the OpenAI API key is already set up

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';
import 'dart:convert';

Future<Uint8List> getDreamImage(String dreamText) async {
  String apiUrl =
      "https://api-inference.huggingface.co/models/prompthero/openjourney";
  String apiKey = ""; // Replace with your actual API key

  Map<String, String> headers = {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json",
  };

  Map<String, dynamic> body = {
    "inputs": dreamText,
  };

  http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception("Failed to get dream image");
  }
}

Future<String> interpretDream(String dream, String religion) async {
  String ingredients = dream;
  OpenAI.apiKey = "";
  String interpretation;
  String system = "";
  if (religion == 'Christian') {
    system =
        "You are a dream interpreter and you are using the Bible to interpret dreams. You have the combined knowledge of all the prophets and apostles as well as the leading psychologists";
  } else if (religion == 'Muslim') {
    system =
        "You are a dream interpreter and you are using the Quran to interpret dreams. You have the combined knowledge of all the prophets and apostles as well as the leading psychologists";
  }

  OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
    model: "gpt-3.5-turbo",
    messages: [
      OpenAIChatCompletionChoiceMessageModel(
        content: system,
        role: "system",
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: "This is the dream: $dream",
        role: "user",
      ),
    ],
  );

  OpenAIChatCompletionChoiceMessageModel response =
      chatCompletion.choices.first.message;

  interpretation = response.content;

  print(interpretation);

  // Remove the para that says "AI" or "model" or "language" or "GPT-3" or "OpenAI" or "API"
  interpretation = interpretation.replaceAll(
      RegExp(r'AI|model|language|GPT-3|OpenAI|API', caseSensitive: false), '');

  return interpretation;
}

// DreamInterpretScreen class
class DreamInterpretScreen extends StatefulWidget {
  final TextEditingController textEditingController;
  final String religion;

  DreamInterpretScreen(
      {required this.textEditingController, required this.religion});

  @override
  _DreamInterpretScreenState createState() => _DreamInterpretScreenState();
}

class _DreamInterpretScreenState extends State<DreamInterpretScreen> {
  late Future<String> interpretations;
  late Future<Uint8List> dreamImage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    interpretations =
        interpretDream(widget.textEditingController.text, widget.religion);
    dreamImage = getDreamImage(widget.textEditingController.text);
    await Future.wait([interpretations, dreamImage]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([interpretations, dreamImage]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data![0]), // Interpretation
                      SizedBox(
                          height:
                              20), // Add some spacing between the text and image
                      Image.memory(snapshot.data![1]), // Dream image
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
