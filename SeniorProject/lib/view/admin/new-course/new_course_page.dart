import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:cyber/view/util/k_values.dart' as k_values;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/course.dart';
import '../../util/components.dart';
import 'new_course_page_outcomes.dart';

class NewCoursePage extends StatelessWidget {
  const NewCoursePage({Key? key}) : super(key: key);
  static final String routeName = '/newCourse';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            leading: getBackButton(context: context),
            title: Text(
              'New Course',
              style: getSubheadingStyleWhite(),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
              //This widget solves the problem of the overflow caused by the keyboard
              child: NewCourseForm())),
    );
  }
}

class NewCourseForm extends StatefulWidget {
  const NewCourseForm({Key? key}) : super(key: key);

  @override
  State<NewCourseForm> createState() => _NewCourseFormState();
}

class _NewCourseFormState extends State<NewCourseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerTitle;
  late TextEditingController _controllerXP;
  late bool activeButton;

  // The following list is used for the dropdown button
  static final List<k_values.Category> items = [
    k_values.Category.socialMedia,
    k_values.Category.info,
    k_values.Category.devices,
    k_values.Category.web,
  ];

  //Default option in the dropdown button
  k_values.Category value = items.first;

  //Initialization of text form field controllers
  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController();
    _controllerXP = TextEditingController();
    activeButton = true;
  }

  //Free memory
  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerXP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //I define the function to be used when submitting the form
    void Function() updateCourseFields = () async {
      bool imageIsValid = await checkImageSF();

      if (!imageIsValid) {
        var snackBar = SnackBar(
          backgroundColor: secondaryColor,
          content: Text(
            'Valid image not found',
            style: getNormalTextStyleWhite(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      //Returns true if the form is valid
      if (_formKey.currentState!.validate() && activeButton && imageIsValid) {
        //I create a new-course with dummy values
        activeButton = false;

        Course newCourse = Course(
            imageURL: '',
            title: '',
            category: k_values.Category.info,
            positionInCategory: 1,
            numberOfQuestions: 1,
            experiencePoints: 1,
            description: '',
            badgeIcon: '',
            outcomes: [],
            questions: []);

        //I update the fields
        newCourse.title = _controllerTitle.text.trim();
        newCourse.experiencePoints = int.parse(_controllerXP.text.trim());
        newCourse.category = value;
        newCourse.imageURL = await getImageUrlSF();

        Navigator.pushNamed(context, NewCourseOutcomesPage.routeName,
            arguments: newCourse);
      }
    };

    return Form(
      key: _formKey,
      /* child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.05 * k_values.heightOfScreen),
          Text(
            'Title',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.025 * k_values.heightOfScreen,
                left: 0.03 * k_values.widthOfScreen,
                right: 0.03 * k_values.widthOfScreen),
            child: TextFormField(
              validator: validatorForEmptyTextField,
              controller: _controllerTitle,
              decoration: getInputDecoration(
                  hintText: 'Title',
                  icon: Icon(
                    Icons.label_important,
                    color: secondaryColor,
                  )),
            ),
          ),
          SizedBox(height: 0.05 * k_values.heightOfScreen),
          Text(
            'Category',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: EdgeInsets.only(
            top: 0.025 * k_values.heightOfScreen,
          )),
          buildDropdown(),
          SizedBox(height: 0.05 * k_values.heightOfScreen),
          Text(
            'Image',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.025 * k_values.heightOfScreen,
                left: 0.03 * k_values.widthOfScreen,
                right: 0.03 * k_values.widthOfScreen),
            child: TextFormField(
              validator: validatorForURL,
              controller: _controllerImage,
              decoration: getInputDecoration(
                  hintText: 'Enter valid URL',
                  icon: Icon(
                    Icons.photo,
                    color: secondaryColor,
                  )),
            ),
          ),
          SizedBox(height: 0.05 * k_values.heightOfScreen),
          Text(
            'XP',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.025 * k_values.heightOfScreen,
                left: 0.32 * k_values.widthOfScreen,
                right: 0.35 * k_values.widthOfScreen),
            child: TextFormField(
              textAlign: TextAlign.center,
              validator: validatorForExp,
              keyboardType: TextInputType.number,
              controller: _controllerXP,
              decoration: InputDecoration(
                  hintText: 'XP',
                  filled: true,
                  fillColor: tertiaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: tertiaryColor, width: 1.0),
                  ),
                  prefixIcon: Icon(
                    Icons.star,
                    color: secondaryColor,
                  ),
                  hintStyle: getTexFieldTextStyle(),
                  contentPadding: EdgeInsets.only(
                      top: 0.08 * widthOfScreen, left: 0.08 * widthOfScreen)),
            ),
          ),
          SizedBox(height: 0.05 * k_values.heightOfScreen),
          getNextButton(todo: updateCourseFields, large: true),
          SizedBox(height: 0.04 * k_values.heightOfScreen),
          getCirclesProgressBar(position: 1, numberOfCircles: 3),
          SizedBox(height: 0.01 * heightOfScreen),
        ],*/
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 0.05 * widthOfScreen, right: 0.05 * widthOfScreen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.05 * k_values.heightOfScreen),
              Text(
                'Title',
                style: getNormalTextStyleWhite(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.025 * k_values.heightOfScreen),
              TextFormField(
                validator: validatorForEmptyTextField,
                controller: _controllerTitle,
                decoration: getInputDecoration(
                    hintText: 'Title',
                    icon: Icon(
                      Icons.label_important,
                      color: secondaryColor,
                    )),
              ),
              SizedBox(height: 0.05 * k_values.heightOfScreen),
              Text(
                'Category',
                style: getNormalTextStyleWhite(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.025 * k_values.heightOfScreen),
              buildDropdown(),
              SizedBox(height: 0.05 * k_values.heightOfScreen),
              Text(
                'XP',
                style: getNormalTextStyleWhite(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.025 * k_values.heightOfScreen),
              TextFormField(
                validator: validatorForExp,
                keyboardType: TextInputType.number,
                controller: _controllerXP,
                decoration: getInputDecoration(
                    hintText: 'XP',
                    icon: Icon(
                      Icons.star,
                      color: secondaryColor,
                    )),
              ),
              SizedBox(height: 0.05 * k_values.heightOfScreen),
              Text(
                'Image',
                style: getNormalTextStyleWhite(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.025 * k_values.heightOfScreen),
              SizedBox(
                width: getWidthOfSmallButton(),
                height: getHeightOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return ImageDialog();
                        });
                  },
                  style: yellowButtonStyle,
                  child: Text(
                    'Choose',
                    style: getNormalTextStyleWhite(),
                  ),
                ),
              ),
              SizedBox(height: 0.1 * k_values.heightOfScreen),
              getNextButton(todo: updateCourseFields, large: true),
              SizedBox(height: 0.04 * k_values.heightOfScreen),
              getCirclesProgressBar(position: 1, numberOfCircles: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown() => Container(
        width: 0.97 * k_values.widthOfScreen,
        padding: EdgeInsets.symmetric(
            horizontal: 0.03 * k_values.widthOfScreen,
            vertical: 0.005 * k_values.heightOfScreen),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: DropdownButton(
          alignment: Alignment.center,
          isExpanded: true,
          underline: SizedBox(),
          icon: Icon(
            CupertinoIcons.chevron_down_circle_fill,
            color: secondaryColor,
          ),
          borderRadius: BorderRadius.circular(15),
          value: value, // currently selected item
          items: items
              .map((item) => DropdownMenuItem<k_values.Category>(
                    child: Text(
                      k_values.categoryToString[item] ?? 'No category',
                      style: getNormalTextStyleBlue(),
                    ),
                    value: item,
                  ))
              .toList(),
          onChanged: (value) => setState(() {
            this.value = value as k_values.Category;
          }),
        ),
      );
}

class ImageDialog extends StatefulWidget {
  const ImageDialog({Key? key}) : super(key: key);

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  late bool _imageSelected;
  late final _formKeyDialog;
  late final _controllerImage;
  late String _imageURL;

  @override
  void initState() {
    super.initState();
    _formKeyDialog = GlobalKey<FormState>();
    _imageSelected = false;
    _controllerImage = TextEditingController();
    _imageURL = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        _imageSelected ? 'Picture' : 'Enter URL',
        style: getSubheadingStyleBlue(),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKeyDialog,
            child: TextFormField(
              validator: validatorForURL,
              controller: _controllerImage,
              decoration: getInputDecoration(
                  hintText: 'URL',
                  icon: Icon(
                    Icons.photo,
                    color: secondaryColor,
                  )),
            ),
          ),
          _imageSelected
              ? Column(children: [
                  SizedBox(
                    height: 0.02 * heightOfScreen,
                  ),
                  ImageContent(imageURL: _imageURL)
                ])
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
      actionsPadding: EdgeInsets.only(bottom: 12.0),
      contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 24.0),
      insetPadding: EdgeInsets.all(10),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        _imageSelected
            ? SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Save', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                ),
              )
            : SizedBox(
                height: 0,
                width: 0,
              ),
        SizedBox(
            height: getHeightOfSmallButton(),
            width: getWidthOfSmallButton(),
            child: ElevatedButton(
              onPressed: () {
                if (_formKeyDialog.currentState!.validate()) {
                  setState(() {
                    _imageSelected = !_imageSelected;
                    if (_imageSelected) {
                      _imageURL = _controllerImage.text;
                      setImageSelectedToSF(imageURL: _imageURL);
                    }
                  });
                }
              },
              child: Text(_imageSelected ? 'Cancel' : 'Submit',
                  style: getNormalTextStyleBlue()),
              style: greyButtonStyle,
            )),
      ],
    );
  }
}

class ImageContent extends StatelessWidget {
  const ImageContent({Key? key, required String this.imageURL})
      : super(key: key);

  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageURL,
      width: 0.5 * widthOfScreen,
      height: 0.2 * heightOfScreen,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        //We change the state of the pic in shared preferences
        setImageAsUnavailableSF();
        return const Text('Wrong URL, try again');
      },
    );
  }
}

setImageSelectedToSF({required String imageURL}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('imageURL', imageURL);
  prefs.setBool('valid', true);
}

setImageAsUnavailableSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('valid', false);
}

checkImageSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey('imageURL') && prefs.containsKey('valid')) {
    return prefs.get('valid');
  } else {
    return false;
  }
}

getImageUrlSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('imageURL')!.trim();
}
