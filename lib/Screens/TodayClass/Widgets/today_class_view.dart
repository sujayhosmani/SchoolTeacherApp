import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/TimeTable.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Providers/todyclass_provider.dart';
import 'package:provider/provider.dart';


class ShowTodayClassList extends StatelessWidget {
  final List<TimeTable> timeTable;
  final Function(TimeTable, int, String) onPressed;
  final String from;

  const ShowTodayClassList({Key key, this.timeTable, this.onPressed, this.from = "na"}) : super(key: key);


  checkStatus(val){
    if(val == "Start" || val == "Resume"){
      return true;
    }else{
      return false;
    }
  }

  getColor(val){
    if(val == "Waiting"){
      return Colors.orange;
    }else if(val == "Start" || val == "Resume"){
      return Colors.blue;
    }else if(val == "Ended" || val == "NA Ended"){
      return Colors.red.shade300;
    }else{
      return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return timeTable == null  ? SizedBox.shrink() :
    timeTable.length == 0  ? Text("Nothing for today", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)) :
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        timeTable == null ? SizedBox.shrink() : Text(timeTable[0]?.weekSub[0]?.Week, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
        Expanded(
          child: ListView.builder(
              itemCount: timeTable?.length,
              scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              // physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                String sub = Provider.of<TeacherProvider>(context, listen: false).getSubjectById(timeTable[index].weekSub[0].SubjectId).Subject;
                return Column(
                  children: [
                    ListTile(
                      trailing: TextButton(child: Text(timeTable[index].weekSub[0].Status, style: TextStyle(color: getColor(timeTable[index].weekSub[0].Status)),), onPressed:  checkStatus(timeTable[index].weekSub[0].Status) ? () => onPressed(timeTable[index], index, from) : null,),
                      onTap: () {print("d");},
                      title:  timeTable == null ? SizedBox.shrink() :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(timeTable[index].Std + "th " + timeTable[index].Section + " Section "),

                            ],
                          ),
                          Text(sub),
                        ],
                      ),

                      subtitle: timeTable == null ? SizedBox.shrink() :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(timeTable[index].FromTime + " - " + timeTable[index].EndTime),

                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 2,),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
