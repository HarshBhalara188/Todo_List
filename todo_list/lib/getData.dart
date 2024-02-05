import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class getdata extends StatefulWidget {
  const getdata({super.key});

  @override
  State<getdata> createState() => _getdataState();
}

class _getdataState extends State<getdata> {

  List<Data> userinputdata = [];


  final TextEditingController userfirstname = TextEditingController();
  final TextEditingController userlastname = TextEditingController();
  final TextEditingController usercity = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          const Text('Enter Your First Name:',style: TextStyle(fontSize: 20,fontFamily: 'Poppins',fontWeight: FontWeight.w600),),
          SizedBox(height: 15,),
          buildusername(),
          SizedBox(height: 15,),
          const Text('Enter Your Last Number:',style: TextStyle(fontSize: 20,fontFamily: 'Poppins',fontWeight: FontWeight.w600),),
          SizedBox(height: 15,),
          buildusrnumber(),
          SizedBox(height: 15,),
          const Text('Enter City',style: TextStyle(fontSize: 20,fontFamily: 'Poppins',fontWeight: FontWeight.w600),),
          SizedBox(height: 15,),
          buildusercity(),

        ],
      ),
    );
  }

  Padding buildusercity() {
    return Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: TextField(
            controller: usercity,
            decoration: InputDecoration(
              errorText: _validate ? 'Please Enter City' : null,
                hintText: 'Enter Your City:',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.deepPurple,width: 5.0)
                )
            ),
          ),
        );
  }

  Padding buildusrnumber() {
    return Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: TextField(
            controller: userlastname,
            decoration: InputDecoration(
              errorText: _validate ? 'Please Last Name' : null,
              hintText: 'Enter Last Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.deepPurple,width: 5.0)
              )
            ),
          ),
        );
  }

  Padding buildusername() {
    return Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: TextField(
            controller: userfirstname,
            decoration: InputDecoration(
              errorText: _validate ? 'Please Enter Name': null,
              hintText: 'Your Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
              )
            ),
          ),
        );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Fill Details',style: TextStyle(fontSize: 30),),
      actions: [
        IconButton(onPressed: () {
          _validate = false;

          if(userfirstname.text.isEmpty){
           _validate = true;
          }
          else if(userlastname.text.isEmpty){
            _validate = true;
          }
          else if(usercity.text.isEmpty){
            _validate = true;
          }
          else{
            userinputdata.add(Data(userfirstname: userfirstname.text, userlastname: userlastname.text, usercity: usercity.text));
          }

          userfirstname.clear();
          userlastname.clear();
          usercity.clear();

          Navigator.pop(
            context,
            userinputdata
          );

        }, icon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(Icons.credit_score,size: 35,),
        ))
      ],
    );
  }
}

class Data {

  String userfirstname;
  String userlastname;
  String usercity;

  Data({required this.userfirstname, required this.userlastname, required this.usercity});

}
