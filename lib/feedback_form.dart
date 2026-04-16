import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'feedback_list.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  // ✅ Fixed version of saveFeedback (handles JSON safely)
  Future<void> saveFeedback(String name, String feedback) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('feedbackList');

    List<Map<String, String>> feedbackList = [];

    if (existingData != null) {
      final decodedData = jsonDecode(existingData);

      // Safely convert each item to Map<String, String>
      feedbackList = List<Map<String, String>>.from(
        (decodedData as List).map((item) => {
              'name': item['name'].toString(),
              'feedback': item['feedback'].toString(),
            }),
      );
    }

    feedbackList.add({'name': name, 'feedback': feedback});

    await prefs.setString('feedbackList', jsonEncode(feedbackList));
  }

  void handleSubmit() async {
    String name = nameController.text.trim();
    String feedback = feedbackController.text.trim();

    if (name.isEmpty || feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    await saveFeedback(name, feedback);

    nameController.clear();
    feedbackController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackListScreen()),
    );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}




