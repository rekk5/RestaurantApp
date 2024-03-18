// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String feedback = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please leave your feedback below:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    feedback = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement submission logic
                  submitFeedback();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitFeedback() {
    // You can implement your submission logic here
    // For this example, let's just print the feedback
    print('Feedback: $feedback');
    //Clear the text field
    setState(() {
      feedback = '';
    });
    // You can also perform actions like sending the feedback to a server, etc.
  }
}