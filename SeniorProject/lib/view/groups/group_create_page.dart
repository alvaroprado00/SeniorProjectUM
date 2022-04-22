import 'dart:io';

import 'package:cyber/controller/active_group_controller.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/group_controller.dart';
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/group.dart';
import 'package:cyber/view/groups/group_created_page.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uuid/uuid.dart';

import '../util/components.dart';
import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  static final String routeName = "/CreateGroup";

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  late TextEditingController _controllerJoin;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  var uuid = Uuid();
  final GroupController _groupController = new GroupController();
  final ActiveUserController activeUserController =
      Get.put(ActiveUserController());
  XFile? cameraImage;
  File? groupImage;
  bool gettingImage = false;
  late String groupCode;
  late String imageURLForController;
  late Map<String, dynamic> newGroup;

  final _formKey = GlobalKey<FormState>();

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
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'SELECT OPTION',
          style: TextStyle(
              color: secondaryColor,
              fontFamily: fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                var _newImage = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {
                  cameraImage = _newImage;
                  Navigator.of(context).pop();
                  _cropImage();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Library", style: getNormalTextStyleWhite()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.photo,
                      color: tertiaryColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
              style: blueButtonStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                var _newImage = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                setState(() {
                  cameraImage = _newImage;
                  Navigator.of(context).pop(context);
                  _cropImage();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Camera", style: getNormalTextStyleWhite()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.camera,
                      color: tertiaryColor,
                      size: widthOfScreen * 0.1,
                    ),
                  ),
                ],
              ),
              style: blueButtonStyle,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          child: Text("Close", style: getNormalTextStyleBlue()),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
      ],
    );
  }

  Future<void> _cropImage() async {
    if (cameraImage != null) {
      groupImage = await _cropper.cropImage(
        sourcePath: cameraImage!.path,
        maxHeight: (heightOfScreen * 0.25).toInt(),
        maxWidth: getWidthOfLargeButton().toInt(),
        compressFormat: ImageCompressFormat.png,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        iosUiSettings: IOSUiSettings(
          doneButtonTitle: 'Done',
          title: "Crop Image",
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          hidesNavigationBar: false,
          showCancelConfirmationDialog: false,
          showActivitySheetOnDone: false,
          rotateButtonsHidden: false,
          resetButtonHidden: false,
        ),
        androidUiSettings: AndroidUiSettings(
          backgroundColor: tertiaryColor,
          activeControlsWidgetColor: secondaryColor,
          cropFrameColor: secondaryColor,
          cropGridColor: tertiaryColor,
          cropGridColumnCount: 2,
          cropGridRowCount: 2,
          showCropGrid: true,
          toolbarColor: primaryColor,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: tertiaryColor,
          statusBarColor: primaryColor,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
        ),
      );
      setState(() {
        groupImage = groupImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // void Function() goToCreatePage = () {
    //   if (_formKey.currentState!.validate()) {
    //     GroupController.uploadImage(groupCode, groupImage!).then((value) {
    //       setState(() {
    //         gettingImage = true;
    //         String imageUrl = value;
    //         imageURLForController = value;
    //         newGroup = new Group(
    //           groupCode: groupCode,
    //           groupName: _controllerJoin.text,
    //           groupAdmin: activeUser!.username,
    //           dateCreated: getDateCreatedForGroup().toString(),
    //           groupMembers: [
    //             activeUser!.username,
    //           ],
    //           groupImageURL: imageUrl,
    //         ).toJson();
    //         Get.put(
    //           ActiveGroupController(
    //             inGroupCode: groupCode,
    //             inGroupName: _controllerJoin.text,
    //             inGroupAdmin: activeUser!.username,
    //             inDateCreated: getDateCreatedForGroup().toString(),
    //             inGroupMembers: [
    //               activeUser!.username,
    //             ],
    //             inGroupImageURL: imageURLForController,
    //           ),
    //           tag: groupCode,
    //         );
    //         _groupController.addGroup(newGroup, groupCode).whenComplete(() {
    //           setState(() {
    //             GroupController.initNotifications(groupCode: groupCode);
    //             gettingImage = false;
    //             UserController.addGroupCodeToUser(groupCode: [groupCode]);
    //             activeUserController.updateUserGroups(groupCode: groupCode);
    //             print(activeUserController.userGroups.toString());
    //             Navigator.pushReplacement(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => GroupCreated(
    //                           groupCode: groupCode,
    //                         )));
    //           });
    //         });
    //       });
    //     });
    //   }
    // };

    return LoadingOverlay(
      isLoading: gettingImage,
      child: Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          title: Text(
            "Create Group",
            style: getSubheadingStyleBlue(),
          ),
          centerTitle: true,
          leading: getBackButton(context: context),
          backgroundColor: tertiaryColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
                  child: SubtitleDivider(subtitle: 'Group Name'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    controller: _controllerJoin,
                    validator: validatorForEmptyTextField,
                    decoration: getInputDecoration(
                      hintText: 'Name',
                      icon: const Icon(
                        Icons.group,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: heightOfScreen * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
                  child: SubtitleDivider(subtitle: 'Group Image'),
                ),
                cameraImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: heightOfScreen * 0.28,
                                width: getWidthOfLargeButton(),
                                child: groupImage != null
                                    ? Image.file(
                                        groupImage!,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Image.file(
                                        File(cameraImage!.path),
                                        fit: BoxFit.fitWidth,
                                      ),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 0.1 * heightOfScreen,
                                      width: 0.4 * widthOfScreen,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.photo,
                                              color: primaryColor,
                                              size: widthOfScreen * 0.1,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text("Change",
                                                  style:
                                                      getSmallTextStyleBlue()),
                                            ),
                                          ],
                                        ),
                                        style: greyButtonStyle,
                                      ),
                                    ),
                                    Container(
                                      height: 0.1 * heightOfScreen,
                                      width: 0.4 * widthOfScreen,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _cropImage();
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.crop,
                                              color: primaryColor,
                                              size: widthOfScreen * 0.1,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text("Crop",
                                                  style:
                                                      getSmallTextStyleBlue()),
                                            ),
                                          ],
                                        ),
                                        style: greyButtonStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0, left: 16.0, right: 16.0),
                        child: Container(
                          height: heightOfScreen * 0.15,
                          width: getWidthOfLargeButton(),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            },
                            child: const Icon(
                              Icons.cloud_upload,
                              color: secondaryColor,
                              size: 60.0,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  quinaryColor),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  color: secondaryColor,
                                  width: 1.0,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                cameraImage != null
                    ? SizedBox(
                        height: heightOfScreen * 0.03,
                      )
                    : SizedBox(height: heightOfScreen * 0.03),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 16.0, left: 16.0, right: 16.0, top: 8.0),
                  child: Text(
                    'Once you create a group, it will be assigned a private code. Share the code with the community you want.',
                    maxLines: 3,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 10.0,
                  ),
                  child: SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      child: Text(
                        'Create',
                        style: getNormalTextStyleWhite(),
                      ),
                      style: blueButtonStyle,
                      onPressed: () async {
                        groupCode = uuid.v4().substring(0, 8);
                        if (groupImage != null) {
                          if (_formKey.currentState!.validate()) {
                            GroupController.uploadImage(groupCode, groupImage!)
                                .then((value) {
                              setState(() {
                                gettingImage = true;
                                String imageUrl = value;
                                imageURLForController = value;
                                newGroup = new Group(
                                  groupCode: groupCode,
                                  groupName: _controllerJoin.text,
                                  groupAdmin: activeUser!.username,
                                  dateCreated:
                                      getDateCreatedForGroup().toString(),
                                  groupMembers: [
                                    activeUser!.username,
                                  ],
                                  groupImageURL: imageUrl,
                                ).toJson();

                                Get.put(
                                  ActiveGroupController(
                                    inGroupCode: groupCode,
                                    inGroupName: _controllerJoin.text,
                                    inGroupAdmin: activeUser!.username,
                                    inDateCreated:
                                        getDateCreatedForGroup().toString(),
                                    inGroupMembers: [
                                      activeUser!.username,
                                    ],
                                    inGroupImageURL: imageURLForController,
                                  ),
                                  tag: groupCode,
                                );
                                _groupController
                                    .addGroup(newGroup, groupCode)
                                    .whenComplete(() {
                                  setState(() {
                                    GroupController.initNotifications(
                                        groupCode: groupCode);
                                    gettingImage = false;
                                    UserController.addGroupCodeToUser(
                                        groupCode: [groupCode]);
                                    activeUserController.updateUserGroups(
                                        groupCode: groupCode);
                                    print(activeUserController.userGroups
                                        .toString());
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupCreated(
                                                  groupCode: groupCode,
                                                )));
                                  });
                                });
                              });
                            });
                          }
                          ;
                        } else {
                          File defaultImage;
                          _groupController
                              .getImageFileFromAssets("default_chat_banner.png")
                              .then((value) {
                            setState(() {
                              defaultImage = value;
                              GroupController.uploadImage(
                                      groupCode, defaultImage)
                                  .then((value) {
                                setState(() {
                                  gettingImage = true;
                                  String imageUrl = value;
                                  imageURLForController = value;
                                  newGroup = Group(
                                    groupCode: groupCode,
                                    groupName: _controllerJoin.text,
                                    groupAdmin: activeUser!.username,
                                    dateCreated:
                                        getDateCreatedForGroup().toString(),
                                    groupMembers: [
                                      activeUser!.username,
                                    ],
                                    groupImageURL: imageUrl,
                                  ).toJson();
                                  Get.put(
                                    ActiveGroupController(
                                      inGroupCode: groupCode,
                                      inGroupName: _controllerJoin.text,
                                      inGroupAdmin: activeUser!.username,
                                      inDateCreated:
                                          getDateCreatedForGroup().toString(),
                                      inGroupMembers: [
                                        activeUser!.username,
                                      ],
                                      inGroupImageURL: imageURLForController,
                                    ),
                                    tag: groupCode,
                                  );
                                  _groupController
                                      .addGroup(newGroup, groupCode)
                                      .whenComplete(() {
                                    setState(() {
                                      GroupController.initNotifications(
                                          groupCode: groupCode);
                                      gettingImage = false;
                                      UserController.addGroupCodeToUser(
                                          groupCode: [groupCode]);
                                      activeUserController.updateUserGroups(
                                          groupCode: groupCode);
                                      print(activeUserController.userGroups
                                          .toString());
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupCreated(
                                                    groupCode: groupCode,
                                                  )));
                                    });
                                  });
                                });
                              });
                            });
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
