import 'package:figma_check/shared/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/dbhelper.dart';
import 'home.dart';
import 'intro.dart';
import 'models/tasks.dart';
import 'shared/alert_dialog.dart';
import 'shared/app_bar.dart';
import 'shared/shared_functions.dart';
import 'shared/text_field_style.dart';

class SelectedTaskWidget extends StatefulWidget {
  const SelectedTaskWidget({super.key, required this.taskId});
  final int taskId;

  @override
  State<SelectedTaskWidget> createState() => _SelectedTaskWidgetState();
}

class _SelectedTaskWidgetState extends State<SelectedTaskWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, dynamic>> taskInfo = [];
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _achievedController = TextEditingController();
  final _validationKey = GlobalKey<FormState>();

  // Update task information
  Future<void> updateTask() async {
    final SharedPreferences prefs = await _prefs;
    int target = int.parse(_targetController.text);
    int achieved = int.parse(_achievedController.text);
    double percentage =
        double.parse(((achieved / target) * 100).toStringAsFixed(1));
    int taskPoints = 0;
    await DatabaseHelper.updateTask(
        widget.taskId,
        _taskController.text,
        int.parse(_targetController.text),
        int.parse(_achievedController.text),
        percentage,
        taskPoints);

    await isTaskCompleted(
        percentage, widget.taskId, taskPoints, prefs, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomNavBar(
        navItemIndex: 1,
      ),
      body: SafeArea(
          child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(252, 213, 206, 1),
              ),
              child: FutureBuilder(
                  future: DatabaseHelper.retrieveTaskTaskIds(widget.taskId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Tasks>> snapshot) {
                    if (snapshot.hasData) {
                      _taskController.text = snapshot.data![0].task;
                      _targetController.text =
                          snapshot.data![0].target.toString();
                      _achievedController.text =
                          snapshot.data![0].achieved.toString();
                      double percentage = snapshot.data![0].percentage;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: TextButton(
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/back-arrow.png'),
                                              fit: BoxFit.fitWidth),
                                        )),
                                    onPressed: () => Navigator.of(context).pop(true),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 265),
                                  child: SizedBox(
                                    height: 30,
                                    child: Icon(
                                      Icons.star_border_rounded,
                                      size: 40,
                                      color: Color.fromRGBO(255, 170, 97, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                              child: Center(
                                heightFactor: 1,
                                child: LargeOrangeTextStyle(
                                  text: 'The Task',
                                  fontSize: 60,
                                ),
                              ),
                            ),
                            //SizedBox(height: 78,),
                            Form(
                              child: Column(
                                key: _validationKey,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 0),
                                            child: TextFieldStyle(
                                              labelText: 'The task',
                                              controller: _taskController,
                                              errorText: 'Task',
                                              textInputFormatter:
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'(^[a-zA-Z0-9 ,.-]*$)')),
                                              maxLength: 26,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 16),
                                      child: SizedBox(
                                        width: 115,
                                        child: TextFieldStyle(
                                          labelText: 'Qty',
                                          controller: _targetController,
                                          errorText: 'Quantity',
                                          textInputFormatter:
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^-?[0-9]+$')),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
                                      child: SizedBox(
                                        width: 115,
                                        //child:TextFieldStyle(labelText: 'Unit',),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: PinkTextStyle(
                                    text: 'How much have you done?',
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 16),
                                      child: SizedBox(
                                        width: 85,
                                        child: TextFieldStyle(
                                          labelText: '',
                                          controller: _achievedController,
                                          textInputFormatter:
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^-?[0-9]+$')),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 115,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
                                      child: SizedBox(
                                        width: 145,
                                        child: LargeOrangeTextStyle(
                                          text:
                                              '${percentage.toString().replaceAll(regex, '')}%',
                                          fontSize: 52,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //add
                            Center(
                              heightFactor: 0.6,
                              child: Column(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      if (_taskController.text.isEmpty ||
                                          _targetController.text.isEmpty) {
                                        _validationKey.currentState?.validate();
                                      } else {
                                        if (_achievedController.text.isEmpty) {
                                          int achieved = 0;
                                          _achievedController.text =
                                              achieved.toString();
                                        } else if (int.parse(
                                                _achievedController.text) >
                                            int.parse(_targetController.text)) {
                                          //print("ero");
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  actionsAlignment:
                                                      MainAxisAlignment.center,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  title: Row(children: const [
                                                    Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      color: Color.fromRGBO(
                                                          255, 160, 142, 1),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text('Warning')
                                                  ]),
                                                  content: Text(
                                                      'The achieved number is greater than the selected target.'),
                                                  actions: const <Widget>[
                                                    OkButton(),
                                                  ],
                                                );
                                              });
                                        } else {
                                          updateTask();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeWidget(),
                                              ));
                                        }
                                      }
                                    },
                                    child: Image.asset(
                                        'assets/images/edit-tool.png',
                                        height: 135,
                                        width: 200,
                                        fit: BoxFit.fitWidth),
                                  ),
                                  PinkTextStyle(
                                    text: 'Save',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }))),
    );
  }
}
