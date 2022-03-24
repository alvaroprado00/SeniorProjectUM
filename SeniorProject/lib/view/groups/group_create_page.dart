import 'dart:io';
import 'package:cyber/globals.dart';
import 'package:cyber/view/groups/group_created_page.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uuid/uuid.dart';
import '../useful/components.dart';
import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import 'package:cyber/model/group.dart';
import 'package:cyber/controller/group_controller.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  late TextEditingController _controllerJoin;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  var uuid = Uuid();
  final GroupController _groupController = new GroupController();
  XFile? cameraImage;
  File? groupImage;
  bool gettingImage = false;
  late String groupCode;
  late Map<String, dynamic> newGroup;

  @override
  void initState() {
    super.initState();
    _controllerJoin = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerJoin.dispose();
    super.dispose();
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, color: primaryColor,),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0.0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Add image from...',
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,),
            child: ElevatedButton(
              onPressed: () async {
                var _newImage = await _picker.pickImage(source: ImageSource.gallery,);
                setState(() {
                  cameraImage = _newImage;
                  Navigator.of(context).pop();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Image Gallery",
                      style: TextStyle(
                        color: tertiaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.add_photo_alternate_outlined, color: tertiaryColor, size: widthOfScreen * 0.1,),
                  ),
                ],
              ),
              style: blueButtonStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,),
            child: ElevatedButton(
              onPressed: () async {
                var _newImage = await _picker.pickImage(source: ImageSource.camera,);
                setState(() {
                  cameraImage = _newImage;
                  Navigator.of(context).pop();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Camera",
                      style: TextStyle(
                        color: tertiaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.camera_alt, color: tertiaryColor, size: widthOfScreen * 0.1,),
                  ),
                ],
              ),
              style: blueButtonStyle,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cropImage() async {
    if(cameraImage != null) {
      groupImage = await _cropper.cropImage(
        sourcePath: cameraImage!.path,
        maxHeight: (heightOfScreen * 0.25).toInt(),
        maxWidth: getWidthOfLargeButton().toInt(),
        androidUiSettings: AndroidUiSettings(
          backgroundColor: tertiaryColor,
          activeControlsWidgetColor: secondaryColor,
          cropFrameColor: secondaryColor,
          cropGridColor: primaryColor,
          cropGridColumnCount: 2,
          cropGridRowCount: 2,
          showCropGrid: true,
          toolbarColor: primaryColor,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: tertiaryColor,
          statusBarColor: primaryColor,
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
        ),
      );
    }
    if(groupImage != null) {
      setState(() {
        groupImage = groupImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlay(
      isLoading: gettingImage,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Group", style: getHeadingStyleBlue(),),
          centerTitle: true,
          leading: getBackButton(context: context),
          backgroundColor: tertiaryColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getTitleAndDivider('Group Name'),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: TextFormField(
                  controller: _controllerJoin,
                  validator: validatorForEmptyTextField,
                  decoration: getInputDecoration(
                    hintText: 'Enter Group Name',
                    icon: const Icon(
                      Icons.group,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: heightOfScreen * 0.03,),
              getTitleAndDivider('Group Image'),
              cameraImage != null ? Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: heightOfScreen * 0.25,
                          width: getWidthOfLargeButton(),
                          child: Image.file(
                            File(cameraImage!.path),
                            fit: BoxFit.fitWidth,
                          ),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPopupDialog(context),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: primaryColor,
                                        size: widthOfScreen * 0.1,
                                      ),
                                      Text("Change Image", style: getNormalTextStyleBlue(),),
                                    ],
                                  ),
                                ),
                                style: yellowButtonStyle,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _cropImage();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.crop,
                                        color: primaryColor,
                                        size: widthOfScreen * 0.1,
                                      ),
                                      Text("Crop Image", style: getNormalTextStyleBlue(),),
                                    ],
                                  ),
                                ),
                                style: yellowButtonStyle,
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ) : Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                child: Container(
                  height: heightOfScreen * 0.25,
                  width: getWidthOfLargeButton(),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context),
                      );
                    },
                    child: const Icon(
                      Icons.cloud_upload,
                      color: secondaryColor,
                      size: 60.0,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: primaryColor,
                            width: 2.0,
                          ),
                      )),
                    ),
                  ),
                ),
              ),
              cameraImage != null ? SizedBox(height: heightOfScreen * 0.06,) : SizedBox(height: heightOfScreen * 0.15),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Once your group is created you will be able to invite friends via Group Code.',
                  maxLines: 2,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 10.0),
                child: SizedBox(
                  height: getHeightOfLargeButton(),
                  width: getWidthOfLargeButton(),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (validatorForEmptyTextField != null){
                        setState(() {
                          gettingImage = true;
                          groupCode = uuid.v4().substring(0,8);
                          newGroup = {
                            "groupCode" : groupCode,
                            "groupName" : _controllerJoin.text,
                            "groupMembers" : [activeUser!.username,],
                          };
                        });
                      }
                      await _groupController.addGroup(newGroup, groupCode)
                          .then((value) {
                            gettingImage = false;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GroupCreated()));
                      });
                    },
                    child: Text(
                      'Create Group',
                      style: getNormalTextStyleBlue(),
                    ),
                    style: yellowButtonStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
