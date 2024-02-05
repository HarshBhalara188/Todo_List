import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainfile2 extends StatefulWidget {
  const Mainfile2({Key? key}) : super(key: key);

  @override
  State<Mainfile2> createState() => _Mainfile2State();
}

class _Mainfile2State extends State<Mainfile2> {
  List<String> names = [];
  List<String> searchNames = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController titleControllerEditor = TextEditingController();
  late SharedPreferences sp;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          // buildTitleRow(),
          // const SizedBox(height: 20),
          buildSearchBar(),
          const SizedBox(height: 10),
          buildNewListCreated(),
        ],
      ),
    );
  }

  Widget buildNewListCreated() {
    return Expanded(
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: searchNames.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white30,
              child: buildSlidableDeleteAndEdit(context, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSlidableDeleteAndEdit(BuildContext context, int index) {
    return Slidable(
      endActionPane: buildEndActionPane(context, index),
      startActionPane: buildStartActionPane(context, index),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.teal),
        onTap: (){
        },
        title: Text(searchNames[index]),
      ),
    );
  }

  ActionPane buildStartActionPane(BuildContext context, int index) {
    return ActionPane(
      extentRatio: 0.25,
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          onPressed: (_) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Edit Title'),
                content: TextField(
                  controller: titleControllerEditor,
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
                        String editedTitle = titleControllerEditor.text.trim();
                        names[names.indexOf(searchNames[index])] = editedTitle;
                        searchNames[index] = editedTitle;
                        titleControllerEditor.clear();
                        sp.setStringList('KeyName', names);
                      });
                      updateSharedPreferences();
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
      extentRatio: 0.25,
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
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
                        String deletedTitle = searchNames[index];
                        searchNames.removeAt(index);
                        names.remove(deletedTitle);
                      });
                      updateSharedPreferences();
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

  // Widget buildTitleRow() {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 330,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 12, top: 12),
  //           child: TextField(
  //             controller: titleController,
  //             onChanged: (value) {
  //               filterNames(value);
  //             },
  //             decoration: InputDecoration(
  //               hintText: 'Enter Title',
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(30),
  //                 borderSide: const BorderSide(color: Colors.deepOrange, width: 5.0),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 9, top: 10),
  //         child: IconButton(
  //           onPressed: () {
  //             addNewTitle();
  //           },
  //           icon: const Icon(Icons.check_circle, size: 30),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) {
          filterNames(value);
        },
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.deepOrange, width: 5.0),
          ),
        ),
      ),
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

  void getValues() async {
    sp = await SharedPreferences.getInstance();
    List<String>? data1 = sp.getStringList("KeyName");
    if (data1 != null) {
      setState(() {
        names.addAll(data1);
        searchNames.addAll(data1);
      });
    }
  }

  void _showDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Title'),
        content: TextField(
          controller: titleController,
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
            onPressed: () {
              addNewTitle();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void addNewTitle() {
    String title = titleController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        names.add(title);
        searchNames.add(title);
        titleController.clear();
      });
      updateSharedPreferences();
    }
  }

  void filterNames(String query) {
    setState(() {
      searchNames = names.where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void updateSharedPreferences() {
    sp.setStringList("KeyName", names);
  }
}
