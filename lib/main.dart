import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final List<bool> feedbackStatuses = [false, false, true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: feedbackStatuses.length,
          itemBuilder: (context, index) {
            return FeedbackTile(
              complaintNumber: index + 1,
              isFeedbackGiven: feedbackStatuses[index],
              onFeedbackSubmit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackDetailsPage(
                      complaintNumber: index + 1,
                      onSubmit: () {
                        setState(() {
                          feedbackStatuses[index] = true;
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final int complaintNumber;
  final bool isFeedbackGiven;
  final VoidCallback onFeedbackSubmit;

  const FeedbackTile({
    Key? key,
    required this.complaintNumber,
    required this.isFeedbackGiven,
    required this.onFeedbackSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.primaries[complaintNumber % Colors.primaries.length]
          .withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isFeedbackGiven ? Colors.green : Colors.red,
              child: isFeedbackGiven
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.close, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Complaint #$complaintNumber',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (isFeedbackGiven)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You already submitted feedback.'),
                    ),
                  );
                },
              ),
            if (!isFeedbackGiven)
              ElevatedButton(
                onPressed: onFeedbackSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Give Feedback'),
              ),
          ],
        ),
      ),
    );
  }
}

class FeedbackDetailsPage extends StatefulWidget {
  final int complaintNumber;
  final VoidCallback onSubmit;

  const FeedbackDetailsPage({
    Key? key,
    required this.complaintNumber,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _FeedbackDetailsPageState createState() => _FeedbackDetailsPageState();
}

class _FeedbackDetailsPageState extends State<FeedbackDetailsPage> {
  String? selectedDepartment;
  String? resolutionTime;
  File? imageFile;
  double officerRating = 0.0;
  final TextEditingController feedbackController = TextEditingController();

  final List<String> departments = [
    'Electricity Board',
    'Public Works Department',
    'Municipality',
    'Health and Sanitation',
    'Roads and Highways',
    'Water Supply',
  ];

  final List<String> resolutionTimes = [
    'Within a Week',
    'Within a Month',
    '2 Months',
    '3+ Months',
    'Not Yet Resolved',
  ];

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback for Complaint #${widget.complaintNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Department:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: departments.map((dept) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedDepartment == dept ? Colors.green : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDepartment = dept;
                    });
                  },
                  child: Text(dept),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resolution Time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: resolutionTimes.map((time) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        resolutionTime == time ? Colors.green : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      resolutionTime = time;
                    });
                  },
                  child: Text(time),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload your problem resolved Image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Choose Image'),
              onPressed: pickImage,
            ),
            if (imageFile != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.file(imageFile!, height: 150, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),
            const Text(
              'Rate the Officer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: RatingBar.builder(
                initialRating: officerRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    officerRating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here...',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (selectedDepartment != null &&
                        resolutionTime != null &&
                        officerRating > 0 ||
                    imageFile != null && feedbackController.text.isNotEmpty) {
                  widget.onSubmit();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please complete all fields: select a department, resolution time, rate the officer, upload an image, and provide feedback.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
