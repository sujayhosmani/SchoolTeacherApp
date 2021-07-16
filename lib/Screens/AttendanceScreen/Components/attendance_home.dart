import 'package:flutter/material.dart';
import 'package:guardian_teacher/Screens/AttendanceScreen/Widgets/attendance_card.dart';

class AttendanceHome extends StatefulWidget {
  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  List<String> subj = ["Kannada", "Hindi", "Maths", "English", "Science", "Social", ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Utils.fromHex("#fff8fa"),
      appBar: AppBar(
        title: Text("Attendance"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20,30, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AttendanceCard(title: "Total",number: "85",titleColor: Colors.white,isGradient: true,isPercentage: true,),
                  AttendanceCard(title: "Absents",number: "24",titleColor: Colors.red,),
                  AttendanceCard(title: "Present",number: "80",titleColor: Colors.green,),

                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text("Subjects", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black54),),
            ),
            ListView.builder(
              itemCount: subj.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8,),
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  child: Container(
                    // color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(subj[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.8), letterSpacing: 1.2),),
                                  Text("Total: 87%", style: TextStyle(fontSize: 12),)
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text("12", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.withOpacity(0.8)),),
                                      Text("Absent", style: TextStyle(letterSpacing: 1, fontSize: 13),)
                                    ],
                                  ),
                                  SizedBox(width: 38,),
                                  Column(
                                    children: [
                                      Text("87", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.withOpacity(0.8),),),
                                      Text("Present", style: TextStyle(letterSpacing: 1, fontSize: 13),)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
