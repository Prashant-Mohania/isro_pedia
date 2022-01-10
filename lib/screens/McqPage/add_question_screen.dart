import 'package:flutter/material.dart';
import 'package:isro_pedia/service/database_service.dart';

class AddQuestionScreen extends StatefulWidget {
  final String quizId;
  const AddQuestionScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController question = TextEditingController();
  TextEditingController option1 = TextEditingController();
  TextEditingController option2 = TextEditingController();
  TextEditingController option3 = TextEditingController();
  TextEditingController option4 = TextEditingController();

  uploadQuizData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question.text,
        "option1": option1.text,
        "option2": option2.text,
        "option3": option3.text,
        "option4": option4.text
      };

      // print(widget.quizId);
      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question.text = "";
        option1.text = "";
        option2.text = "";
        option3.text = "";
        option4.text = "";
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        // print(e);
      });
    } else {
      // print("error is happening ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Questions"),
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
                        controller: question,
                        validator: (val) =>
                            val!.isEmpty ? "Enter Question" : null,
                        decoration: const InputDecoration(hintText: "Question"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: option1,
                        validator: (val) => val!.isEmpty ? "Option1 " : null,
                        decoration: const InputDecoration(
                            hintText: "Option1 (Correct Answer)"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: option2,
                        validator: (val) => val!.isEmpty ? "Option2 " : null,
                        decoration: const InputDecoration(hintText: "Option2"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: option3,
                        validator: (val) => val!.isEmpty ? "Option3 " : null,
                        decoration: const InputDecoration(hintText: "Option3"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: option4,
                        validator: (val) => val!.isEmpty ? "Option4 " : null,
                        decoration: const InputDecoration(hintText: "Option4"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                uploadQuizData();
                              },
                              child: const Text("Add More Questions")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Submit")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
