import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  List<Map<String, String>> feedbackList = [];

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  // ✅ Fixed JSON decoding to Map<String, String>
  Future<void> loadFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('feedbackList');

    if (data != null) {
      final decodedData = jsonDecode(data);

      setState(() {
        feedbackList = List<Map<String, String>>.from(
          (decodedData as List).map((item) => {
                'name': item['name'].toString(),
                'feedback': item['feedback'].toString(),
              }),
        );
      });
    }
  }

  // ✅ Optional: Clear all feedbacks
  Future<void> clearAllFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('feedbackList');
    setState(() {
      feedbackList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitted Feedbacks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear All Feedbacks',
            onPressed: () => clearAllFeedbacks(),
          ),
        ],
      ),
      body: feedbackList.isEmpty
          ? const Center(child: Text('No feedbacks yet!'))
          : ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final item = feedbackList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['name'] ?? ''),
                    subtitle: Text(item['feedback'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}


