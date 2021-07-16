import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Utils.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/CTSModel.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Providers/global_provider.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Widgets/input.dart';
import 'package:guardian_teacher/Widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class AddAssignment extends StatefulWidget {
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
   String _chosenValue;
   CTSModel _chosenSubValue;
   TextEditingController mName = TextEditingController();
   TextEditingController mDescription = TextEditingController();
   TextEditingController mDays = TextEditingController();
   List<CTSModel> mSubList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Assignment"),
        elevation: 0,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Consumer<TeacherProvider>(
                  builder: (context, ctsList, child){
                    return ctsList.allCTSTid == null ? Text("NA") : Column(
                      children: [

                        Row(
                          children: [
                            Flexible(flex: 1, child: NormalDropDown(label: "Class", selectedValue: _chosenValue, mList: ctsList.classList, onChanged:(val){onChanged(val,ctsList.allCTSTid);} ,)),
                            Flexible(flex: 2,
                              child: SubjectDropDown(label: "Subject", selectedValue: _chosenSubValue,  mList: mSubList, onChanged:(val){
                                onChangedSubject(val);
                              } ,),
                            ),
                          ],
                        ),


                        NormalInputText(title: "Enter assignment name",label: "Title",mCtrl: mName,),
                        NormalInputText(title: "Enter Description",label: "Description", maxLine: 4,mCtrl: mDescription,),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            children: [
                              Expanded(child: NormalInputText(title: "Enter number of days",label: "Deadline",mCtrl: mDays,)),
                              Container(alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.only(top: 18),
                                  child: Text("Days"))
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Utils.facebookBlue
                              ),
                              onPressed: (){
                                submitAssignment();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Text("Submit", style: TextStyle(color: Colors.white70),),
                              ),
                            )
                        )

                      ],
                    );
                  },
                )
            ),
          ),
          Consumer<GlobalProvider>(builder: (context, global, child){
            return LoadingScreen(isBusy: global.isBusy,error: global?.error,);
          })
        ],
      ),
    );
  }

  void onChanged(String val,List<CTSModel> mainList) {
    String Cls;
    mSubList = [];
    String Sec;
    setState(() {
      _chosenValue = val;
      _chosenSubValue = null;
      Sec = val.substring((val.length - 1), val.length);
      Cls = val.substring(0, val.length - 1);
      mSubList = mainList.where((element) => (element.Std == Cls) && (element.Section == Sec)).toList();
    });


  }

  void onChangedSubject(CTSModel val) {
    setState(() {
      _chosenSubValue = val;
    });
  }

  void submitAssignment() async{
    Teacher tea = Provider.of<TeacherProvider>(context, listen: false).teacher.Data;
    SubjectModel sub = Provider.of<TeacherProvider>(context, listen: false).getSubjectById(_chosenSubValue.SubjectId);
    Assignment assignment = Assignment(TeacherName: tea.FirstName, Tid: tea.Id, SubjectId: _chosenSubValue.SubjectId,
    Std: _chosenSubValue.Std, Section: _chosenSubValue.Section, Status: "In Progress", Description: mDescription.text,
    EndDate: mDays.text, SubjectName: sub.Subject, Title: mName.text);

    int val = await Provider.of<AssignmentProvider>(context, listen: false).addAssignment(context, assignment);
    if(val == 1){
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   margin: const EdgeInsets.all(12),
      //   content: Text("Assignment published"),
      // ));
      Navigator.pop(context);
    }
  }


}
