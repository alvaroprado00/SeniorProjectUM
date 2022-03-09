/**
 * Constant values in the app that are not related to colors or config files
 */

late double widthOfScreen;
late double heightOfScreen;


const Map<int, String> encouragingMessages={
  1: 'Do it now!',
  2: 'Do you think you can?',
  3: 'What are you waiting for?',
  4: 'It seems like a nice course...'
};

Map<int, String> numberToOptionLetter = {
  0: 'A',
  1: 'B',
  2: 'C',
  3: 'D',
};

enum TypeOfQuestion{
  multipleChoice,
  fillInTheBlanks,
}

enum Category{
  socialMedia,
  web,
  devices,
  info,
}

Map <Category, String> categoryToString={
  Category.socialMedia: 'Social Media',
  Category.devices: 'Devices',
  Category.info:'Info',
  Category.web:'Web',
};

Map <String, Category> categoryFromString={
  'Social Media': Category.socialMedia,
  'Devices': Category.devices,
  'Info': Category.info,
  'Web': Category.web,
};

Map <TypeOfQuestion, String> stringFromTypeOfQuestion={
  TypeOfQuestion.multipleChoice: 'Multiple Choice',
  TypeOfQuestion.fillInTheBlanks: 'Fill in the Blanks',
};

Map <String, TypeOfQuestion> typeOfQuestionFromString={
  'Multiple Choice':TypeOfQuestion.multipleChoice,
  'Fill in the Blanks': TypeOfQuestion.fillInTheBlanks,
};

