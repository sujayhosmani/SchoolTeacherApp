import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Constants.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubmitAssignment.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Screens/AssignmentScren/Components/view_submitted.dart';
import 'package:provider/provider.dart';

class SubmittedAssignment extends StatefulWidget {
  final String from;
  final int assignmentIndex;
  final Assignment assig;

  const SubmittedAssignment({Key key, this.from, this.assig,this.assignmentIndex}) : super(key: key);

  @override
  _SubmittedAssignmentState createState() => _SubmittedAssignmentState();
}

class _SubmittedAssignmentState extends State<SubmittedAssignment> {
  List<SubmittedAssignment> finalSubmitted = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.from),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.assig.Title),
                    Text(widget.assig.Std + "th " + widget.assig.Section)
                  ],
                ),
                Text(widget.assig.SubjectName),
              ],
            ),
          ),

          Expanded(
            child: Consumer<AssignmentProvider>(builder: (context, sea, child){
              List<Student> pendingStudents = sea.currentClassStudents;
              for(int i = 0; i < pendingStudents.length; i++){
                for(int j = 0; j < sea.currentSubmittedAssignments.length; j ++){
                  if(pendingStudents[i].Id == sea.currentSubmittedAssignments[j].Sid){
                    pendingStudents.removeAt(i);
                  }
                }
              }
              return  widget.from == "Pending Students" ? PendingStudentList(onPressed: onNotifyClicked, allStudents: pendingStudents,):
              widget.from == "Review Students" ? ReviewPendingStudentList(onPressed: onPressed, allSubmitted: sea.currentSubmittedAssignments,) : TotalStudentList(onPressed: onPressed, allSubmitted: sea.currentSubmittedAssignments,);
            },),
          )
        ],
      ),
    );
  }

  void onPressed(SubmitAssignments subAssign, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return ViewSubmitted(submittedIndex: index,subAssign: subAssign,assig: widget.assig,);
    }));
  }
  void onNotifyClicked() {

  }

}


class PendingStudentList extends StatelessWidget {
  final List<Student> allStudents;
  final Function onPressed;

  const PendingStudentList({Key key, this.allStudents, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allStudents.length,
        itemBuilder: (BuildContext context, int index){
          Student subAssig =  allStudents[index];
          return Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: GestureDetector(
                  onTap: (){ onPressed(); },
                  child: Column(
                    children: [
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: subAssig.ImageUrl ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(width: 50, height: 50, child: CircleAvatar(child: CupertinoActivityIndicator(),backgroundColor: Colors.grey.withOpacity(0.2), )),
                            errorWidget: (context, url, error) => Container(width: 50, height: 50, child: CircleAvatar(child: Text("SS"))),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subAssig.Name),
                                    Text("Notify", style: TextStyle(fontSize: 12, color: Colors.blue),)
                                  ],
                                ),
                                subAssig.RollNo != null ? Text(subAssig?.RollNo, style: TextStyle(fontSize: 13),) : SizedBox.shrink()
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              )
          );
        });
  }
}

class TotalStudentList extends StatelessWidget {
  final List<SubmitAssignments> allSubmitted;
  final Function onPressed;

  const TotalStudentList({Key key, this.allSubmitted, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allSubmitted.length,
        itemBuilder: (BuildContext context, int index){
          SubmitAssignments subAssig =  allSubmitted[index];
          return Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: GestureDetector(
                  onTap: (){ onPressed(subAssig, index); },
                  child: Column(
                    children: [
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: subAssig.StuImg ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(width: 50, height: 50, child: CircleAvatar(child: CupertinoActivityIndicator(),backgroundColor: Colors.grey.withOpacity(0.2), )),
                            errorWidget: (context, url, error) => Container(width: 50, height: 50, child: CircleAvatar(child: Text(subAssig.StudentName.substring(0,2).toString().toUpperCase()))),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subAssig.StudentName),
                                    subAssig.Remark != null ? Text("Reviewed", style: TextStyle(fontSize: 12, color: Colors.green),) :
                                    Text("Review", style: TextStyle(fontSize: 12, color: Colors.blue),)
                                  ],
                                ),
                                Text("Submitted date: " + subAssig.SubmittedDate, style: TextStyle(fontSize: 13),)
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              )
          );
        });
  }
}

class ReviewPendingStudentList extends StatelessWidget {
  final List<SubmitAssignments> allSubmitted;
  final Function onPressed;

  const ReviewPendingStudentList({Key key, this.allSubmitted, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allSubmitted.length,
        itemBuilder: (BuildContext context, int index){
          SubmitAssignments subAssig =  allSubmitted[index];
          return subAssig.Remark == null ? Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: GestureDetector(
                  onTap: (){ onPressed(subAssig, index); },
                  child: Column(
                    children: [
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: subAssig.StuImg ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(width: 50, height: 50, child: CircleAvatar(child: CupertinoActivityIndicator(),backgroundColor: Colors.grey.withOpacity(0.2), )),
                            errorWidget: (context, url, error) => Container(width: 50, height: 50, child: CircleAvatar(child: Text(subAssig.StudentName.substring(0,2).toString().toUpperCase()))),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subAssig.StudentName),
                                    subAssig.Remark != null ? Text("Reviewed", style: TextStyle(fontSize: 12, color: Colors.green),) :
                                    Text("Review", style: TextStyle(fontSize: 12, color: Colors.blue),)
                                  ],
                                ),
                                Text("Submitted date: " + subAssig.SubmittedDate, style: TextStyle(fontSize: 13),)
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              )
          ) : SizedBox.shrink();
        });
  }
}

