import 'dart:io';

import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../controller/active_group_controller.dart';
import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_values.dart';

class EditGroup extends StatefulWidget {
  const EditGroup({Key? key, required this.groupCode}) : super(key: key);

  static final routeName = '/EditGroup';
  final String groupCode;

  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  late TextEditingController nameController;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  XFile? cameraImage;
  File? groupImage;
  bool changingImage = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      size: 32,
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
      groupImage = (await _cropper.cropImage(
        sourcePath: cameraImage!.path,
        maxHeight: (heightOfScreen * 0.25).toInt(),
        maxWidth: getWidthOfLargeButton().toInt(),
        compressFormat: ImageCompressFormat.png,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        iosUiSettings: IOSUiSettings(
          title: "Crop Image",
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          hidesNavigationBar: false,
          showCancelConfirmationDialog: true,
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
      ))!;
    }
    if (groupImage != null) {
      setState(() {
        groupImage = groupImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ActiveGroupController activeGroupController =
        Get.find<ActiveGroupController>(tag: widget.groupCode);

    return LoadingOverlay(
      isLoading: changingImage,
      child: Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          title: Text(
            "Edit Group",
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 0.03 * widthOfScreen,
                    right: 0.03 * widthOfScreen,
                    top: 16),
                child: SubtitleDivider(
                  subtitle: 'Edit Name',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 16.0, right: 16.0),
                child: TextFormField(
                  controller: nameController,
                  validator: validatorForEmptyTextField,
                  decoration: getInputDecoration(
                    hintText:
                        '${activeGroupController.groupName.value.toString()}',
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
                    left: 0.03 * widthOfScreen,
                    right: 0.03 * widthOfScreen,
                    top: 16),
                child: SubtitleDivider(
                  subtitle: 'Edit Image',
                ),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text("Change",
                                                style: getSmallTextStyleBlue()),
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
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text("Crop",
                                                style: getSmallTextStyleBlue()),
                                          ),
                                        ],
                                      ),
                                      style: yellowButtonStyle,
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
                      child: Column(
                        children: [
                          Container(
                            height: heightOfScreen * 0.28,
                            width: getWidthOfLargeButton(),
                            child: Image.network(
                                activeGroupController.groupImageURL.value
                                    .toString(),
                                fit: BoxFit.fitWidth),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.photo,
                                      color: primaryColor,
                                      size: widthOfScreen * 0.1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text("Change",
                                          style: getSmallTextStyleBlue()),
                                    ),
                                  ],
                                ),
                                style: greyButtonStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              cameraImage != null
                  ? SizedBox(
                      height: heightOfScreen * 0.03,
                    )
                  : SizedBox(height: heightOfScreen * 0.07),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                child: SizedBox(
                  height: getHeightOfLargeButton(),
                  width: getWidthOfLargeButton(),
                  child: ElevatedButton(
                    onPressed: () {
                      changingImage = true;
                      if (nameController.value.text != null &&
                          nameController.value.text.isNotEmpty) {
                        activeGroupController.updateGroupName(
                            inGroupName: nameController.text);
                        if (groupImage != null && groupImage!.path.isNotEmpty) {
                          activeGroupController.updateGroupImage(
                              groupImage: groupImage!);
                          setState(() {
                            changingImage = false;
                            Navigator.of(context).pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Group Info Updated!',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: secondaryColor,
                            ));
                          });
                        } else {
                          Navigator.of(context).pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Group Name Updated!',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: secondaryColor,
                          ));
                        }
                      } else if (groupImage != null) {
                        activeGroupController.updateGroupImage(
                            groupImage: groupImage!);
                        setState(() {
                          changingImage = true;
                          Navigator.of(context).pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Group Image Updated!',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: secondaryColor,
                          ));
                        });
                      }
                    },
                    child: Text(
                      'Submit Changes',
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
