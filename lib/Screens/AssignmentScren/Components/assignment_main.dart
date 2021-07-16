import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Constants.dart';
import 'package:guardian_teacher/Helpers/Utils.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Providers/todyclass_provider.dart';
import 'package:guardian_teacher/Screens/AssignmentScren/Components/view_assignment.dart';
import 'package:guardian_teacher/Screens/AssignmentScren/Widgets/assignment_list.dart';
import 'package:guardian_teacher/Screens/TodayClass/Widgets/today_class_view.dart';
import 'package:provider/provider.dart';

import 'add_assignment.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {

  @override
  void initState() {
    Provider.of<AssignmentProvider>(context, listen: false).fetchAssignmentsByTid(context, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment"),
        // leadingWidth: 25,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 5),
        //   child: Icon(Icons.arrow_back, color: Colors.black87),
        // ),
        centerTitle: false,
        elevation: 0,
        actions: [

        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(72.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(left: 10),
        //         child: Row(
        //           children: [
        //             Expanded(
        //               child: TextField(
        //                 decoration: InputDecoration(
        //                   hintText: "Search",
        //                   fillColor: Theme.of(context).dividerColor.withOpacity(0.07),
        //                   filled: true,
        //                   contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        //                   border: OutlineInputBorder(
        //                     borderSide: BorderSide.none,
        //                     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //                   ),
        //                   suffixIcon: InkWell(
        //                     onTap: () {
        //
        //                     },
        //                     child: Container(
        //                       // padding: EdgeInsets.all(defaultPadding * 0.75),
        //                       // margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        //                       decoration: BoxDecoration(
        //                         color: Utils.facebookBlue,
        //                         borderRadius: const BorderRadius.all(Radius.circular(10)),
        //                       ),
        //                       child: Icon(Icons.search, color: Colors.white,),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //
        //               },
        //               child: Container(
        //                 padding: EdgeInsets.all(defaultPadding * 0.75),
        //                 margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        //                 decoration: BoxDecoration(
        //                   color: Colors.orange,
        //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
        //                 ),
        //                 child: Icon(Icons.sort, color: Colors.white,),
        //               ),
        //             ),
        //
        //           ],
        //         ),
        //       ),
        //       SizedBox(height: 10,),
        //
        //     ],
        //   ),
        // ),
        // backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Consumer<AssignmentProvider>(builder: (context, tClass, child){
            return  AssignmentList(from: "na", assignments: tClass.assignments, onPressed: (assig, index){ onPressed(assig, index);},);
          },),
          Container(
            // width: double.infinity,
            alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(

                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                            return AddAssignment();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),

                          ),

                          // padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap
                        ),
                        child: Text("Add Assignment", style: TextStyle(color: Colors.white70),)
                    ),
                  ),
                ],
              )
          )
        ],
      )
    );
  }

  void onPressed(Assignment assig, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return ViewAssignment(assignmentIndex: index, assig: assig,);
    }));
  }
}
