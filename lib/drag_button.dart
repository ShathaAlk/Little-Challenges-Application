import 'package:flutter/material.dart';
import 'dart:math';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'shared/alert_dialog.dart';

class SwipeDeleteDemo extends StatefulWidget {
  const SwipeDeleteDemo({super.key});

  final String title = "Refresh/Swipe Delete Demo";

  @override
  SwipeDeleteDemoState createState() => SwipeDeleteDemoState();
}

class SwipeDeleteDemoState extends State<SwipeDeleteDemo> {
  //
  late List<String> companies;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  late Random r;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    r = Random();
    companies = [];
    addCompanies();
  }

  addCompanies() {
    companies.add("Google");
    companies.add("Apple");
    companies.add("Samsung");
    companies.add("Sony");
    companies.add("LG");
  }

  addRandomCompany() {
    int nextCount = r.nextInt(100);
    setState(() {
      companies.add("Company $nextCount");
    });
  }

  removeCompany(index) {
    setState(() {
      companies.removeAt(index);
    });
  }

  undoDelete(index, company) {
    setState(() {
      companies.insert(index, company);
    });
  }

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 10));
    addRandomCompany();
  }

  showSnackBar(context, company, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$company deleted'),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          undoDelete(index, company);
        },
      ),
    ));
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

  Widget list() {
    return ListView.builder(
      padding: EdgeInsets.all(20.0),
      itemCount: companies.length,
      itemBuilder: (BuildContext context, int index) {
        return row(context, index);
      },
    );
  }

  Widget textButton() {
    return PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: "Delete",
      message: "Are you sure you want to delete this item?",
      confirmButtonText: "Confirm",
      cancelButtonText: "Cancel",
      onTapConfirm: () {
        Navigator.pop(context);
      },
      onTapCancel: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.custom,
      color: Color.fromRGBO(255, 160, 142, 1),
      noImage: true,
    );
  }

  Widget row(context, index) {
    return Dismissible(
      key: Key(companies[index]), // UniqueKey().toString()
      onDismissed: (direction) {
        var company = companies[index];
        showSnackBar(context, company, index);
        removeCompany(index);
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
              //icon: Icons.delete_forever_rounded,
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
                //SizedBox(height: 50,),
              ],
            );
          },
        );
        //log('Deletion confirmed: $confirmed');
        return confirmed;
      },
      background: refreshBg(),
      child: Card(
        child: ListTile(
          title: Text(companies[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await refreshList();
        },
        child: list(),
        /*
        child: TextButton(
          onPressed: () {
            PanaraConfirmDialog.showAnimatedGrow(
              context,
              title: "Delete",
              message: "Are you sure you want to delete this item?",

              confirmButtonText: "Confirm",
              cancelButtonText: "Cancel",

              onTapConfirm: () {
                Navigator.pop(context);
              },
              onTapCancel: () {
                Navigator.pop(context);
              },
              panaraDialogType: PanaraDialogType.custom,
              color: Color.fromRGBO(255, 160, 142, 1),
              noImage: true,
            );
          },

          child: const Text("Show No Image Warning Confirm"),
        ),

         */
      ),
    );
  }
}
/*
class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
        side: BorderSide(width: 1.0, color: Color.fromRGBO(255, 160, 142, 1),),
        padding: EdgeInsets.only(left: 26,right: 26, top: 12, bottom: 12),
      ),
      onPressed: () {
        Navigator.pop(context, false); // showDialog() returns false
      },
      child: Text('Cancel', style: TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(255, 160, 142, 1),
      ),),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color.fromRGBO(255, 160, 142, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
        padding: EdgeInsets.only(left: 26,right: 26, top: 12, bottom: 12),
        //alignment: Alignment.center,
      ),

      onPressed: () {
        Navigator.pop(context, true); // showDialog() returns true
      },
      child: Text('Confirm', style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),),
    );
  }
}

 */
