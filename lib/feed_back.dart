// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // Get user id to store rating for user
  final _userId = FirebaseAuth.instance.currentUser?.uid;
  // Cloud Firestore database
  final _firesStoreDB = FirebaseFirestore.instance;
  // firebase realtime database reference
  final _databaseReference = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://kandi-project-default-rtdb.europe-west1.firebasedatabase.app"
  ).ref();
  // initialize _feedback as empty
  String _feedback = '';
// Save _feedback to Firebase Realtime Database
    void saveFeedback() {
      if (_feedback != ''){
    _databaseReference.child('_feedback').push().set({
      'feedback': _feedback,
    });}
  }
  double _initialRecommendationsRating = 0;

  Future<void> _getInitialRating() async {
    final userDoc = await _firesStoreDB.collection('users').doc(_userId).get();
    setState(() {
      _initialRecommendationsRating = userDoc.data().toString().contains('recommendationsRating') ? _initialRecommendationsRating = userDoc['recommendationsRating'] : _initialRecommendationsRating = 0.0;    
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialRating();
  }
// Build the _feedback page
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
              _recommendationsText(),
              const SizedBox(height: 5),
              _starRatingForRecommendations(),
              const SizedBox(height: 20),
              _feedbackText(),
              const SizedBox(height: 20),
              _feedbackTextField(),
              const SizedBox(height: 20),
              _submitFeedbackButton(),
            ],
          ),
        ),
      ),
    );
  }

    Text _recommendationsText() {
    return const Text(
      'How would you rate your recommendations:',
      style: TextStyle(fontSize: 18.0),
    );
  }

  ElevatedButton _submitFeedbackButton() {
    return ElevatedButton(
      onPressed: saveFeedback,
      child: const Text('Submit'),
    );
  }

  TextFormField _feedbackTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _feedback = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Feedback',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
    );
  }

  Text _feedbackText() {
    return const Text(
      'Please leave your feedback below:',
      style: TextStyle(fontSize: 18.0),
    );
  }


  RatingBar _starRatingForRecommendations() {
    return RatingBar.builder(
      initialRating: _initialRecommendationsRating,
      allowHalfRating: true,
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber, ),
      onRatingUpdate: (rating){
        
        _firesStoreDB.collection('users').doc(_userId).set({
          'recommendationsRating' : rating
          }, SetOptions(merge: true));
      }
    );
  }
}