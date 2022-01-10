import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isro_pedia/screens/McqPage/create_quiz_screen.dart';
import 'package:isro_pedia/service/database_service.dart';

import 'quiz_play.dart';

class MCQPage extends StatefulWidget {
  const MCQPage({Key? key}) : super(key: key);

  @override
  State<MCQPage> createState() => _MCQPageState();
}

class _MCQPageState extends State<MCQPage> {
  DatabaseService databaseService = DatabaseService();
  Stream quizStream = FirebaseFirestore.instance.collection("Quiz").snapshots();

  Widget quizList() {
    return Column(
      children: [
        StreamBuilder(
          stream: quizStream,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    // itemCount: snapshot.data.documents.length,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      // return Text(snapshot.data.docs[index].data().toString());
                      return QuizTile(
                        noOfQuestions: snapshot.data.docs.length,
                        title: snapshot.data.docs[index].data()['quizTitle'],
                        dif: snapshot.data.docs[index].data()['quizDif'],
                        id: snapshot.data.docs[index].id,
                      );
                    });
          },
        )
      ],
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ISRO Quiz"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black26,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateQuizScreen()));
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: quizList(),
        ),
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title, id, dif;
  final int noOfQuestions;

  const QuizTile(
      {Key? key,
      required this.title,
      required this.id,
      required this.dif,
      required this.noOfQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => QuizPlay(quizId: id)
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black26,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Title :- ",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Difficulty :- ",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  FilterChip(
                      label: Text(dif.toUpperCase()), onSelected: (val) {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
