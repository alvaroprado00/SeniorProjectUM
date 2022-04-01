import 'package:cyber/view/util/k_values.dart';

class Question {
  final int number;
  final TypeOfQuestion typeOfQuestion;
  String longFeedback;

  Question({
    required int this.number,
    required TypeOfQuestion this.typeOfQuestion,
    required String this.longFeedback,
  });
}
