import 'package:flutter/material.dart';
import 'package:todo_list/getData.dart';

class tododemo extends StatefulWidget {
  const tododemo({super.key});

  @override
  State<tododemo> createState() => _tododemoState();
}

class _tododemoState extends State<tododemo> {

  List<Data> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Todo List Data Passing',style: TextStyle(fontSize: 20),)),),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.lightGreenAccent,
          onPressed: () async{
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => getdata()));

              // Data d = value[0];
              // print("Data ${d.username}");
              // print("Data ${d.usernumber}");
              // print("Data ${d.usercity}");

              if (result != null && result is List<Data>) {
                setState(() {
                  dataList.addAll(result);
                });
              };},
            ),
            body: Column(
            children: [
            Expanded(
              child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context , index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.white30,
                      child: ListTile(
                        leading: const Icon(Icons.dataset),
                         title: RichText(
                           text: TextSpan(
                             children: [
                               TextSpan(text: 'FName:',style: TextStyle(fontSize: 12,color: Colors.black)),
                               TextSpan(text: dataList[index].userfirstname,style: TextStyle(fontSize: 18,color: Colors.black)),
                               WidgetSpan(child: SizedBox(width: 15,)),
                               TextSpan(text: 'LName:',style: TextStyle(fontSize: 12,color: Colors.black)),
                               TextSpan(text: dataList[index].userlastname,style: TextStyle(fontSize: 18,color: Colors.black)),
                             ]
                           ),
                         ),
                         subtitle: Text("City: ${dataList[index].usercity}",style: const TextStyle(fontSize: 12)),
                         trailing: IconButton(
                           onPressed: () {
                             setState(() {
                             });
                           },icon: IconButton(onPressed: () {
                             setState(() {
                               dataList.removeAt(index);
                             });
                           }, icon: Icon(Icons.delete)),
                         )
                      ),
                    ),
                  )),
            )
        ],
      ),
      );
  }
}
