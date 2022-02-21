import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';

class NewQuestionPage extends StatefulWidget {
  const NewQuestionPage({Key? key}) : super(key: key);
  static final String routeName = '/newQuestion';

  @override
  State<NewQuestionPage> createState() => _NewQuestionPageState();
}

class _NewQuestionPageState extends State<NewQuestionPage>
    with SingleTickerProviderStateMixin {
  static  List<Tab> myTabs = <Tab>[
    Tab(child: Text('Multiple Choice', style: getNormalTextStyleWhite(),) ),
    Tab(child: Text('Fill In the blanks', style: getNormalTextStyleWhite(),)),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: getBackButton(context:context),

        bottom: TabBar(
          indicatorColor: secondaryColor,
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {

          return Center(
            child: Text(
              'This is the whatever tab',
              style: const TextStyle(fontSize: 36),
            ),
          );
        }).toList(),
      ),
    );
  }
}
