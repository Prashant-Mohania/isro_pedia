import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isro_pedia/models/question_model.dart';
import 'package:isro_pedia/screens/McqPage/results.dart';
import 'package:isro_pedia/service/database_service.dart';

import 'play_quiz_widgets.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;

  const QuizPlay({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;

class _QuizPlayState extends State<QuizPlay> {
  late QuerySnapshot questionSnaphot;
  DatabaseService databaseService = DatabaseService();

  bool isLoading = true;

  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnaphot.docs.length;
      setState(() {});
    });

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();

    questionModel.question = questionSnapshot["question"];

    // shuffling the options
    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false;

    return questionModel;
  }

  // @override
  // void dispose() {
  //   infoStream = null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizId),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Results(
                      total: total,
                      correct: _correct,
                      incorrect: _incorrect,
                      notattempted: _notAttempted)));
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // InfoHeader(
                  //   length: questionSnaphot.docs.length,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  questionSnaphot.docs.isEmpty
                      ? const Center(
                          child: Text("No Data"),
                        )
                      : ListView.builder(
                          itemCount: questionSnaphot.docs.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return QuizPlayTile(
                              questionModel: getQuestionModelFromDatasnapshot(
                                  questionSnaphot.docs[index]),
                              index: index,
                            );
                          })
                ],
              ),
            ),
    );
  }
}

// class InfoHeader extends StatefulWidget {
//   final int length;

//   const InfoHeader({Key? key, required this.length}) : super(key: key);

//   @override
//   _InfoHeaderState createState() => _InfoHeaderState();
// }

// class _InfoHeaderState extends State<InfoHeader> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: infoStream,
//         builder: (context, snapshot) {
//           return snapshot.hasData
//               ? Container(
//                   height: 40,
//                   margin: const EdgeInsets.only(left: 14),
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     children: <Widget>[
//                       NoOfQuestionTile(
//                         text: "Total",
//                         number: widget.length,
//                       ),
//                       NoOfQuestionTile(
//                         text: "Correct",
//                         number: _correct,
//                       ),
//                       NoOfQuestionTile(
//                         text: "Incorrect",
//                         number: _incorrect,
//                       ),
//                       NoOfQuestionTile(
//                         text: "NotAttempted",
//                         number: _notAttempted,
//                       ),
//                     ],
//                   ),
//                 )
//               : Container();
//         });
//   }
// }

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  const QuizPlayTile(
      {Key? key, required this.questionModel, required this.index})
      : super(key: key);

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              "Q${widget.index + 1} ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 22, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
