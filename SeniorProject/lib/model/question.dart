import 'package:cyber/view/useful/k_values.dart';

class Question {
  final int number;
  final TypeOfQuestion typeOfQuestion;
  final String longFeedback;


 const Question(
      {required int this.number,
        required TypeOfQuestion this.typeOfQuestion,
        required String this.longFeedback,});

}
