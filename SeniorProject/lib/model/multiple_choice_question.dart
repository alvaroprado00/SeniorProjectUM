import 'package:cyber/model/question.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';

class MultipleChoiceQuestion extends Question {
  String description;
  final List<String> options;
  int rightOption;

  MultipleChoiceQuestion(
      {required int number,
      required String this.description,
      required TypeOfQuestion typeOfQuestion,
      required String longFeedback,
      required List<String> this.options,
      required int this.rightOption})
      : super(
            number: number,
            typeOfQuestion: typeOfQuestion,
            longFeedback: longFeedback);

  static getMultipleChoiceQuestion() {
    return MultipleChoiceQuestion(
        number: 1,
        description:
            'In these days you are in the need of creating many different accounts and profiles. When required to enter a new password, should you have the same password for every account:',
        typeOfQuestion: TypeOfQuestion.multipleChoice,
        longFeedback:
            'Even if difficult, you should try to never repeat your passwords. There are tools that can help you to achieve this aim without having to memorize many passwords. They are called password managers. We are sure that you use the one provided by Google almost everyday!',
        options: [
          'It does not matter that much as long as my usual password is secure',
          'You should try to not repeat a password',
          'Using always the same password is a good way to remember it',
          'All of them are right'
        ],
        rightOption: 2);
  }

  String getSolutionAsString() {
    return '${numberToOptionLetter[rightOption]}  ${options[rightOption]}';
  }

  Text getSolutionAsStringNew() {
    return Text.rich(TextSpan(text: '${numberToOptionLetter[rightOption]}'));
  }

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
      number: json['number'],
      description: json['description'],
      typeOfQuestion: typeOfQuestionFromString[json['typeOfQuestion']]!,
      longFeedback: json['longFeedback'],
      options: List.castFrom(json['options']),
      rightOption: json['rightOption'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'longFeedback': longFeedback,
      'number': number,
      'options': options,
      'rightOption': rightOption,
      'description': description,
      'typeOfQuestion': stringFromTypeOfQuestion[typeOfQuestion],
    };
  }
}
