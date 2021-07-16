import 'package:flutter/material.dart';
import 'package:guardian_teacher/Meeting/meeting_main.dart';
import 'package:guardian_teacher/Model/OnlineClass.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/Model/TimeTable.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/global_provider.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Providers/todyclass_provider.dart';
import 'package:guardian_teacher/Screens/TodayClass/Widgets/today_class_view.dart';
import 'package:guardian_teacher/Widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class TodayClassScreen extends StatefulWidget {
  @override
  _TodayClassScreenState createState() => _TodayClassScreenState();
}

class _TodayClassScreenState extends State<TodayClassScreen> {

  String from = "na";
  @override
  void initState() {

    getTodayClass();
    super.initState();
  }

  getTodayClass() async{
    CustomResponse<List<TimeTable>> f = await Provider.of<TodayClassProvider>(context,listen: false).fetchTodayClass(context, "na");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today Classes", ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<TodayClassProvider>(builder: (context, tClass, child){
                return  ShowTodayClassList(from: from, timeTable: tClass.todayClass, onPressed: (online, index, from){ onPressed(online, index, from);},);
              },),
            ),
            Consumer<GlobalProvider>(builder: (context, global, child){
              return LoadingScreen(isBusy: global.isBusy,error: global?.error,);
            })
          ],
        )
      ),
    );
  }

  void onPressed(TimeTable online, int index, String from) async{

    Teacher tea = Provider.of<TeacherProvider>(context, listen: false).teacher.Data;
    SubjectModel sub = Provider.of<TeacherProvider>(context, listen: false).getSubjectById(online.weekSub[0].SubjectId);
    // prepare to launch
    if(online.weekSub[0].OnlineClassId == null){

      OnlineClass onlineClass = OnlineClass(ActualStartTime: online.FromTime, ActualEndTime: online.EndTime,
          Section: online.Section, Std: online.Std, Subject: sub.Subject, SubjectCode: sub.SubjectCode.toString(), SubjectId: online.weekSub[0].SubjectId,
          TeacherId: tea.TeacherId, TeacherName: tea.FirstName, Tid: online.weekSub[0].TId,CTSId: online.weekSub[0].CTSId, Week: online.weekSub[0].Week);

      print(tea.FirstName);

      CustomResponse<OnlineClass> val = await Provider.of<TodayClassProvider>(context, listen: false).addOnlineClass(context, onlineClass, index, from);
      if(val.Status == 1){
        print(val.Data.Id + "Join the room");
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return Meeting(roomId: val.Data.Id, name: tea.FirstName,subject: sub.Subject,);
        }));
      }else{
        getTodayClass();
      }
    }else{

      print(online.weekSub[0].OnlineClassId + "Join the room 2");
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        return Meeting(roomId: online.weekSub[0].OnlineClassId, name: tea.FirstName,subject: sub.Subject,);
      }));
    }


  }
}
