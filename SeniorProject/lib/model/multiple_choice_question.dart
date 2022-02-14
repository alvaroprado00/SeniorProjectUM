import 'package:cyber/view/useful/k_values.dart';

class MultipleChoiceQuestion {
  final int number;
  final String description;
  final TypeOfQuestion typeOfQuestion;
  final String shortFeedback;
  final String longFeedback;
  final List<String> options;
  final int rightOption;

  MultipleChoiceQuestion(
      {required int this.number,
      required String this.description,
      required TypeOfQuestion this.typeOfQuestion,
      required String this.shortFeedback,
      required String this.longFeedback,
      required List<String> this.options,
      required int this.rightOption});

  static getMultipleChoiceQuestion() {
    return MultipleChoiceQuestion(
        number: 1,
        description:
            'In these days you are in the need of creating many different accounts and profiles. When required to enter a new password, should you have the same password for every account:',
        typeOfQuestion: TypeOfQuestion.multipleChoice,
        shortFeedback: 'You should try to not repeat your passwords!',
        longFeedback:
            'Even if difficult, you should try to never repeat your passwords. There are tools that can help you to achieve this aim without having to memorize many passwords. They are called password managers. We are sure that you use the one provided by Google almost everyday!',
        options: ['It does not matter that much as long as my usual password is secure', 'You should try to not repeat a password', 'Using always the same password is a good way to remember it', 'All of them are right'],
        rightOption: 2);
  }
}
