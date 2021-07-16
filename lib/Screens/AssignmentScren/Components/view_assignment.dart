import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubmitAssignment.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Screens/AssignmentScren/Components/submitted_students.dart';
import 'package:provider/provider.dart';

class ViewAssignment extends StatefulWidget {
  final int assignmentIndex;
  final Assignment assig;

  const ViewAssignment({Key key, this.assignmentIndex, this.assig}) : super(key: key);
  @override
  _ViewAssignmentState createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {


  @override
  void initState(){
    Provider.of<AssignmentProvider>(context, listen: false).fetchCurrentClassStudents(context, widget.assig);
    Provider.of<AssignmentProvider>(context, listen: false).fetchSubmittedAssignment(context, widget.assig);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.assig.Title),
                    Text(widget.assig.Std + "th " + widget.assig.Section)
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(widget.assig.SubjectName),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(widget.assig.Description),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("End Date: " + widget.assig.EndDate),
                    Text(widget.assig.Status)
                  ],
                ),
              ),
              Divider(),
              Consumer<AssignmentProvider>(builder: (context, sea, child){
                List<SubmitAssignments> pendingForReview;
                if(sea.currentSubmittedAssignments != null){
                  pendingForReview = sea.currentSubmittedAssignments.where((e) => e.Remark == null).toList();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: sea.currentSubmittedAssignments != null ? (){ onTotalClicked(sea.currentClassStudents, sea.currentSubmittedAssignments);} : null,
                      title: Text("Total Submitted:"),
                      trailing: TextButton(child: sea.currentSubmittedAssignments != null ? Text(sea.currentSubmittedAssignments.length.toString()) : CupertinoActivityIndicator(),onPressed: (){},),
                    ),
                    Divider(),
                    ListTile(
                      onTap: (sea.currentSubmittedAssignments != null && sea.currentClassStudents != null) ? (){onTotalPendingClicked(sea.currentClassStudents, sea.currentSubmittedAssignments);} : null,
                      title: Text("Total Pending:"),
                      trailing: TextButton(child: (sea.currentSubmittedAssignments != null && sea.currentClassStudents != null) ? Text((sea.currentClassStudents.length - sea.currentSubmittedAssignments.length).toString()):CupertinoActivityIndicator() ,onPressed: (){},),
                    ),
                    Divider(),
                    ListTile(
                      onTap: sea.currentSubmittedAssignments != null ? (){onPendingReviewClicked(sea.currentClassStudents, sea.currentSubmittedAssignments);} : null,
                      title: Text("Pending for Review:"),
                      trailing: TextButton(child: pendingForReview != null ? Text(pendingForReview.length.toString()) : CupertinoActivityIndicator(),onPressed: (){},),
                    ),
                    Divider(),
                    ListTile(
                      onTap: null,
                      title: Text("Total Students:"),
                      trailing: TextButton(child: sea.currentClassStudents != null ? Text(sea.currentClassStudents.length.toString()) : CupertinoActivityIndicator(),onPressed: (){},),
                    ),
                    Divider(),
                  ],
                );
              },)



            ],
          ),
        ),
      ),
    );
  }

  void onTotalClicked(List<Student> student, List<SubmitAssignments> submitted) {
    if(submitted.length > 0){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        return SubmittedAssignment(assig: widget.assig,from: "Total Submitted",);
      }));
    }
  }

  void onPendingReviewClicked(List<Student> student, List<SubmitAssignments> submitted) {
    if(submitted.length > 0){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        return SubmittedAssignment(assig: widget.assig,from: "Review Students",);
      }));
    }
  }

  void onTotalPendingClicked(List<Student> student, List<SubmitAssignments> submitted) {
    if(student.length > 0){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        return SubmittedAssignment(assig: widget.assig,from: "Pending Students",);
      }));
    }
  }
}
