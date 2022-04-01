import 'package:cyber/model/question.dart';
import 'package:cyber/view/util/k_values.dart';

class FillInTheBlanksQuestion extends Question {
  final String text;
  final Map<int, String> solution;
  final List<String> options;

  FillInTheBlanksQuestion({
    required int number,
    required TypeOfQuestion typeOfQuestion,
    required String longFeedback,
    required String this.text,
    required Map<int, String> this.solution,
    required List<String> this.options,
  }) : super(
            number: number,
            typeOfQuestion: typeOfQuestion,
            longFeedback: longFeedback);

  static getFillInTheBlanksQuestion() {
    return FillInTheBlanksQuestion(
        number: 2,
        typeOfQuestion: TypeOfQuestion.fillInTheBlanks,
        longFeedback: '',
        text:
            'This is an example text with one blank coming now X and another one coming rigth after X',
        solution: {1: 'hola', 2: 'adios'},
        options: ['hola', 'adios', 'que tal']);
  }

  String getSolutionAsString() {
    String s = '';
    for (int i = 1; i <= solution.length; i++) {
      s = s + 'Blank $i: ${solution[i]} ';
    }
    return s;
  }

  factory FillInTheBlanksQuestion.fromJson(Map<String, dynamic> json) {
    return FillInTheBlanksQuestion(
        number: json['number'],
        text: json['text'],
        typeOfQuestion: typeOfQuestionFromString[json['typeOfQuestion']]!,
        longFeedback: json['longFeedback'],
        options: List.castFrom(json['options']),
        solution: Map.from(
          json['solution'].map((key, value) {
            return MapEntry(int.parse(key), value);
          }),
        ));
  }

  Map<String, Object?> toJson() {
    return {
      'longFeedback': longFeedback,
      'number': number,
      'options': options,
      'solution': Map.from(this.solution.map((key, value) {
        return MapEntry(key.toString(), value);
      })),
      'typeOfQuestion': stringFromTypeOfQuestion[typeOfQuestion],
      'text': text,
    };
  }
}
