import 'package:cyber/view/groups/group_created_page.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';

import '../useful/components.dart';
import '../useful/functions.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  late TextEditingController _controllerJoin;

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

  Column getSectionTitle(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: getHeadingStyleBlue(),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: getBackButton(context: context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Group',
                          style: getHeadingStyleBlue(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            getSectionTitle('Group Name'),
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
            getSectionTitle('Group Image'),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: 150.0,
                width: 384.0,
                child: ElevatedButton(
                  onPressed: () {
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
                        )
                    )),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0, top: 200.0),
              child: Text(
                'Once your group is created you will be able to invite friends via Group Code.',
                maxLines: 2,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 10.0),
              child: SizedBox(
                height: 50.0,
                width: 384.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (validatorForEmptyTextField != null){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupCreated()));
                    }
                  },
                  child: Text(
                    'Create Group',
                    style: getNormalTextStyleBlue(),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
