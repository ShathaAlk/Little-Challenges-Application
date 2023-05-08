import 'shared/app_bar.dart';
import 'shared/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/dbhelper.dart';
import 'intro.dart';
import 'shared/alert_dialog.dart';
import 'shared/shared_functions.dart';
import 'shared/text_field_style.dart';

class NewTaskWidget extends StatefulWidget {
  const NewTaskWidget({super.key});

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, dynamic>> taskInfo = [];
  @override
  void initState() {
    super.initState();
    addTask();
  }

  @override
  void dispose() {
    context.mounted;
    super.dispose();
  }

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _achievedController = TextEditingController();
  final _validationKey = GlobalKey<FormState>();

  // Insert a new user to the database
  Future<void> addUser() async {
    //await DatabaseHelper.insertUser(User(points: 0));
    final userId = await DatabaseHelper.insertUser(0);
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('_userId', userId);
    SaveUserInfo().setUserId(int.parse(prefs.getInt('_userId').toString()));
    //هو ماراح يسوي انسرت بعدين فيضل يوزره عنده
    SaveUserInfo().setUserId(userId);
  }

  // Insert a new task to the database
  Future<void> addTask() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getInt('_userId') == null) {
      await addUser();
    }

    if (_taskController.text.isEmpty ||
        _targetController.text.isEmpty) {
    } else
      {
        //Calculate the task's percentage
        int target = int.parse(_targetController.text);
        int achieved = int.parse(_achievedController.text);
        double percentage =
        double.parse(((achieved / target) * 100).toStringAsFixed(1));
        int taskPoints = 0;

        final insertedTaskID = await DatabaseHelper.insertTask(
            _taskController.text,
            int.parse(_targetController.text),
            int.parse(_achievedController.text),
            percentage,
            taskPoints,
            int.parse(prefs.getInt('_userId').toString()));
        isTaskCompleted(
            percentage, insertedTaskID, taskPoints, prefs, context);

      }






    //if (context.mounted) {

    //}

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
              //width: 385,
              //height: 844,
              decoration: BoxDecoration(
                color: Color.fromRGBO(252, 213, 206, 1),
              ),
              child: SingleChildScrollView(
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
                      key: _validationKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  child: TextFieldStyle(
                                    labelText: 'Add your task',
                                    controller: _taskController,
                                    errorText: 'Task',
                                    textInputFormatter:
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'(^[]*$)')),
                                    maxLength: 26,
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
                        ],
                      ),
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
                                  labelText: '0',
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
                                  text: '0%',
                                  fontSize: 56,
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
                                } else if (int.parse(_achievedController.text) >
                                    int.parse(_targetController.text)) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          //icon: Icons.delete_forever_rounded,
                                          title: Row(children: const [
                                            Icon(
                                              Icons.warning_amber_rounded,
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
                                  addTask();
                                  Navigator.pop(context, true);
                                }
                              }
                            },
                            child: Image.asset('assets/images/edit-tool.png',
                                height: 135, width: 200, fit: BoxFit.fitWidth),
                          ),
                          PinkTextStyle(
                            text: 'Save',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
