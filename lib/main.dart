import 'package:flutter/material.dart';
import 'feedback_form.dart';
import 'feedback_list.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Collector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true, // modern look (optional)
      ),

      // 👇 Home screen
      home: const FeedbackFormScreen(),

      // 👇 Optional: define named routes
      routes: {
        '/feedbackList': (context) => const FeedbackListScreen(),
      },
    );
  }
}
