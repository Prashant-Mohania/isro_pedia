import 'package:flutter/material.dart';
import 'package:isro_pedia/screens/McqPage/add_question_screen.dart';
import 'package:isro_pedia/service/database_service.dart';
import 'package:random_string/random_string.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  late String quizTitle, quizDif;

  bool isLoading = false;
  String quizId = "";

  createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizTitle": quizTitle,
        "quizDif": quizDif
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddQuestionScreen(quizId: quizId)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Quiz Details"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black26,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "Required" : null,
                        decoration: const InputDecoration(
                          hintText: "Quiz Name",
                        ),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "Required" : null,
                        decoration: const InputDecoration(
                          hintText: "Dificulty",
                        ),
                        onChanged: (val) {
                          quizDif = val;
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            createQuiz();
                          },
                          child: const Text("Submit"))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
