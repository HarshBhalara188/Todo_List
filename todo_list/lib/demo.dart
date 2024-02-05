import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_widget/swipe_widget.dart';
//import 'package:todo_list/getData.dart';

class Mainfile extends StatefulWidget {
  const Mainfile({super.key});

  @override
  State<Mainfile> createState() => _MainfileState();
}

class _MainfileState extends State<Mainfile> {

  List<String> names = [];
  late List<String> searchnames = [];
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController titlecontrollerediter = TextEditingController();
  late SharedPreferences sp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              _showDialog();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.lightGreen,
          ),
      body: Column(
        children: [
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged:(value) =>  _searchtext(value),
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
                ),
                suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildnewlistcreated(),
        ],
      ),
    );
  }

  Widget buildnewlistcreated() {
    return Expanded(
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white30,
              child: buildSlidabledeleteandedit(context, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSlidabledeleteandedit(BuildContext context, int index) {
    return Slidable(
             endActionPane: buildEndActionPane(context, index),
             startActionPane: buildStartActionPane(context, index),
             child: ListTile(
               leading: const Icon(Icons.check_circle, color: Colors.teal),
               onTap: () {
                 names[index] = titlecontroller.text.trimRight();
               },
               title: Text(names[index]),
             ),
           );
  }

  ActionPane buildStartActionPane(BuildContext context, int index) {
    return ActionPane(
             extentRatio: 0.5,
             motion: const StretchMotion(),
             children: [
               SlidableAction(
                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                 onPressed: (_) {
                   // Show a confirmation dialog before deletion
                   showDialog(
                     barrierDismissible: false,
                     context: context,
                     builder: (context) => AlertDialog(
                       title: const Text('Edit Title'),
                       content: TextField(
                         controller: titlecontrollerediter,
                         decoration: InputDecoration(
                           hintText: 'Enter Title',
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(30),
                             borderSide: const BorderSide(color: Colors.deepOrange, width: 5.0),
                           ),
                         ),
                       ),
                       actions: [
                         TextButton(
                           onPressed: () {
                             Navigator.of(context).pop();
                           },
                           child: const Text('Cancel'),
                         ),
                         TextButton(
                           onPressed: () {
                             setState(() {
                               names[index] = titlecontrollerediter.text.trim();
                               titlecontrollerediter.clear();
                             });
                             Navigator.of(context).pop();
                           },
                           child: const Text('Update'),
                         ),
                       ],
                     ),
                   );
                 },
                 backgroundColor: Colors.lightBlueAccent,
                 foregroundColor: Colors.white,
                 icon: Icons.edit,
                 label: 'Edit',
               ),
             ],
           );
  }

  ActionPane buildEndActionPane(BuildContext context, int index) {
    return ActionPane(
             extentRatio: 0.5,
             motion: const StretchMotion(),
             children: [
               SlidableAction(
                 borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                 onPressed: (_) {
                   showDialog(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: const Text('Confirm Deletion'),
                       content: const Text('Are you sure you want to delete this item?'),
                       actions: [
                         TextButton(
                           onPressed: () {
                             Navigator.of(context).pop();
                           },
                           child: const Text('Cancel'),
                         ),
                         TextButton(
                           onPressed: () {
                             setState(() {
                               names.removeAt(index);
                               sp.setStringList("KeyName", names);
                             });
                             Navigator.of(context).pop();
                           },
                           child: const Text('Delete'),
                         ),
                       ],
                     ),
                   );
                 },
                 backgroundColor: Colors.deepOrange,
                 foregroundColor: Colors.white,
                 icon: Icons.delete,
                 label: 'Delete',
               ),
             ],
           );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Center(
        child: Text(
          'Todo List',
          style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  void getvalue() async{
    sp = await SharedPreferences.getInstance();
    List<String>? data1 = sp.getStringList("KeyName");
    if(data1 != null){
      setState(() {
        names.addAll(data1);
      });
    }
  }

  void _showDialog() async{
    return showDialog(
        context: context,
        builder:(context) => AlertDialog(
          title: Text('Enter Title'),
          content: TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                hintText: 'Enter Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
                ),
              ),
            ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                String title = titlecontroller.text.trim();
                if(title.isNotEmpty){
                  setState(() {
                    names.add(title);
                    titlecontroller.clear();
                  });
                }
                sp.setStringList("KeyName", names);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ));
  }

  _searchtext(String value) {

    if(value.isEmpty){
      setState(() {
        names = searchnames;
      });
    }
    else{
      setState(() {
        names = searchnames.where((task) => task.toLowerCase().contains(value)).toList();
      });
    }
  }
}

