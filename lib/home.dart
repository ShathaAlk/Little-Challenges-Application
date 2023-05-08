import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_new_task.dart';
import 'data/dbhelper.dart';
import 'models/tasks.dart';
import 'selected_task.dart';
import 'shared/app_bar.dart';
import 'shared/bottom_nav_bar.dart';
import 'shared/alert_dialog.dart';
import 'shared/text_field_style.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List taskInfo = [];
  // This function is used to fetch all data from the database
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refreshTaskInfo() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getInt('_userId') != null) {
      int userId = prefs.getInt('_userId')!;
      final taskInfo_ = await DatabaseHelper.retrieveTodayTasksByUserId(userId);
      SaveUserInfo().setUserId(userId);

      final finalTotalPoints =
          await DatabaseHelper.collectFinalTotalPoints(userId);
      await DatabaseHelper.updateUser(
          int.parse(prefs.getInt('_userId').toString()), finalTotalPoints);

      setState(() {
        if (userId != null) {
          taskInfo = taskInfo_;
          userId = prefs.getInt('_userId')!;
        }
      });
    }
  }

  _getRequests() async {
    setState(() {
      _refreshTaskInfo();
    });
  }

  @override
  void initState() {
    super.initState();
    futureBuilder();
    setState(() {});
    SaveUserInfo.userId;
    _refreshTaskInfo(); // Loading the data when the app starts
  }

  // Delete task
  Future deleteTask(int taskId) async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getInt('_userId') == null) {
      //addUser();
    }
    await DatabaseHelper.deleteTask(taskId);
    await DatabaseHelper.deleteUnusedSummaryRecord(
        int.parse(prefs.getInt('_userId').toString()));
    var totalPointsPerDay = await DatabaseHelper.collectTasksPoints(
        int.parse(prefs.getInt('_userId').toString()));
    await DatabaseHelper.insertUserSummary(
        totalPointsPerDay, int.parse(prefs.getInt('_userId').toString()));
    _refreshTaskInfo();
  }

  Future clear() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }

  Widget futureBuilder() {
    if (SaveUserInfo().getUserId() == null) {
      return Center(
        child: Image(
          image: AssetImage(
            'assets/images/lets-go.png',
          ),
          height: 250,
          fit: BoxFit.fitWidth,
        ),
      );
    }
    if (taskInfo.isEmpty) {
      return Center(
        child: Image(
          image: AssetImage(
            'assets/images/lets-go.png',
          ),
          height: 250,
          fit: BoxFit.fitWidth,
        ),
      );
    } else {
      return FutureBuilder(
        future: DatabaseHelper.retrieveTodayTasksByUserId(
            SaveUserInfo().getUserId()),
        builder: (BuildContext context, AsyncSnapshot<List<Tasks>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 30,
              ),
              itemBuilder: (BuildContext context, int index) {
                int taskId = snapshot.data![index].taskId;
                String task = snapshot.data![index].task;
                int target = snapshot.data![index].target;
                int achieved = snapshot.data![index].achieved;
                return row(context, index, taskId, task, target, achieved);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          //}
        },
      );
    }
  }

  Widget refreshBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget row(context, index, taskId, task, target, achieved) {
    return Dismissible(
        key: Key(UniqueKey().toString()), // UniqueKey().toString()
        onDismissed: (direction) {
          //method
          deleteTask(taskId);
        },
        confirmDismiss: (DismissDirection direction) async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Row(children: const [
                  Icon(
                    Icons.delete_sweep_rounded,
                    color: Color.fromRGBO(255, 160, 142, 1),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text('Delete')
                ]),
                content: Text('Do you want to delete this item?'),
                actions: const <Widget>[
                  ConfirmButton(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: SizedBox(
                      width: 6,
                    ),
                  ),
                  CancelButton(),
                ],
              );
            },
          );
          return confirmed;
        },
        background: refreshBg(),
        child: ListTile(
          title: Stack(
            children: [
              SizedBox(
                width: 355,
                height: 72,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedTaskWidget(
                            taskId: taskId,
                          ),
                        ));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(248, 237, 235, 1),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      alignment: Alignment.centerLeft),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Color.fromRGBO(255, 170, 97, 1),
                          fontFamily: 'Itim',
                          fontSize: 28,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                        //textAlign: TextAlign.right,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: BorderedText(
                            strokeWidth: 1.50,
                            child: Text(
                              task,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(child: LayoutBuilder(builder: (context, constraints) {
                if (target == achieved) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 46),
                    child: SizedBox(
                      height: 36,
                      child: Image.asset(
                        'assets/images/check-mark.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return Text("");
                }
              }))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomNavBar(
        navItemIndex: 0,
      ),
      body: SafeArea(
        child: Container(
            height: 844,
            decoration: BoxDecoration(
              color: Color.fromRGBO(252, 213, 206, 1),
            ),
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                color: Color.fromRGBO(252, 213, 206, 1),
                height: 350,
                child: futureBuilder(),
              ),
              //add
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 35),
                child: Column(
                  children: <Widget>[
/*
                    TextButton(
                      onPressed: () {
                        clear();
                      },
                      child: Text("Clear"),
                    ),

 */
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                  builder: (_) => NewTaskWidget()),
                            )
                            .then((val) => val ? _getRequests() : null);
                      },
                      child: Image.asset('assets/images/add.png',
                          height: 135, width: 200, fit: BoxFit.fitWidth),
                    ),
                    PinkTextStyle(
                      text: 'Add yours Now !',
                    ),
                  ],
                ),
              ),
            ])),
        //bottomNavigationBar
      ),
    );
  }
}

class ItemListStyle extends StatelessWidget {
  const ItemListStyle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 52,
      left: 19,
      child: Container(
        width: 355,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(248, 237, 235, 0.75),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DefaultTextStyle(
              style: TextStyle(
                  color: Color.fromRGBO(255, 170, 97, 1),
                  fontFamily: 'Itim',
                  fontSize: 28,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
              child: BorderedText(
                strokeWidth: 1.50,
                child:
                    Text('Drink 8 glasses - water', textAlign: TextAlign.left),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/water.png'),
                        fit: BoxFit.fitWidth),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
