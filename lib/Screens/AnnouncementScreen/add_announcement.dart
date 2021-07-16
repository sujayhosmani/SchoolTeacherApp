import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Constants.dart';
import 'package:guardian_teacher/Helpers/Utils.dart';
import 'package:guardian_teacher/Model/Announcement.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/CTSModel.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/announcement_provider.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Providers/global_provider.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Widgets/input.dart';
import 'package:guardian_teacher/Widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class AddAnnouncement extends StatefulWidget {
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  List<bool> _selections = [];
  String _chosenValue;
  String _chosenCat;
  CTSModel _chosenSubValue;
  TextEditingController mDescription = TextEditingController();
  List<CTSModel> mSubList = [];
  List<bool> isSelected = [
    false,
  ];


  Iterable<Widget> generateToggleButtons(List<String> source, List<bool> values) sync* {

      final children = source.map((value) => Wrap(children: [Text(value)], )).toList();
      final isSelected = values;

      yield ToggleButtons(
        children: children,
        isSelected: _selections,
        selectedColor: Colors.white,
        fillColor: Colors.blue,
        onPressed: (index) {
          setState(() {
            isSelected[index] = !isSelected[index];
          });
        },
      );

  }

  @override
  void initState() {
    List<String> clsList = Provider.of<TeacherProvider>(context, listen: false).classList;
    _selections = List.generate(clsList?.length, (_) => false);
    super.initState();
  }


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
                child: Consumer<TeacherProvider>(builder: (context, ctsList, child){
                  if(_selections.length == 0){
                    _selections = List.generate(ctsList.classList.length, (_) => false);
                  }
                    return ctsList.allCTSTid == null ? Text("NA") :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ToggleButtons(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Select all Classes that you take"),
                            ),
                          ], isSelected: isSelected,
                          onPressed: (int index){
                            setState(() {
                              isSelected[index] = !isSelected[index];
                              for(int i = 0; i < _selections.length; i++){
                                if(isSelected[index] == true){
                                  _selections[i] = true;
                                }else{
                                  _selections[i] = false;
                                }

                              }

                            });

                          },
                            selectedColor: Colors.white,
                          fillColor: Colors.brown,
                          ),
                        ),
                        WrapToggleIconButtons(
                          iconList: ctsList.classList,
                          isSelected: _selections,
                          onPressed: (int index) {
                            setState(() {
                              _selections[index] = !_selections[index];
                              // for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                              //   if (buttonIndex == index) {
                              //
                              //   } else {
                              //     isSelected[buttonIndex] = false;
                              //   }
                              // }
                            });
                          },
                        ),
                        // Row(
                        //   children: [
                        //     // Flexible(flex: 1, child: NormalDropDown(label: "Class", selectedValue: _chosenValue, mList: ctsList.classList, onChanged:(val){onChanged(val,ctsList.allCTSTid);} ,)),
                        //     Flexible(flex: 2,
                        //       child: SubjectDropDown(label: "Subject", selectedValue: _chosenSubValue,  mList: mSubList, onChanged:(val){
                        //         onChangedSubject(val);
                        //       } ,),
                        //     ),
                        //   ],
                        // ),

                        SizedBox(height: 10,),
                        NormalDropDown(label: "Category", selectedValue: _chosenCat, mList: mCategories, onChanged:(val){onChangedCategory(val);} ,),
                        NormalInputText(title: "Enter Description",label: "Description", maxLine: 4,mCtrl: mDescription,),

                        SizedBox(height: 40,),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Utils.facebookBlue
                              ),
                              onPressed: (){
                                submitAssignment(ctsList.classList);
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

  void onChangedCategory(String val){
    setState(() {
      _chosenCat = val;
    });
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

  void submitAssignment(List<String> classList) async{
    List<String> selectedClasses = [];
    for(int i = 0; i < _selections.length; i++){
      if(_selections[i] == true){
        selectedClasses.add(classList[i]);
      }
    }
    Teacher tea = Provider.of<TeacherProvider>(context, listen: false).teacher.Data;
    Announcement announcement = Announcement(Description: mDescription.text, Category: _chosenCat, isForSchool: false, isForTeacher: false, Subject: "", StdSec: selectedClasses, UploadedBy: tea.FirstName, UploadedId: tea.Id);

    int val = await Provider.of<AnnouncementProvider>(context, listen: false).addAssignment(context, announcement);
    if(val == 1){
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   margin: const EdgeInsets.all(12),
      //   content: Text("Assignment published"),
      // ));
      Navigator.pop(context);
    }
  }


}


class WrapToggleIconButtons extends StatefulWidget {
  final List<String> iconList;
  final List<bool> isSelected;
  final Function onPressed;

  WrapToggleIconButtons({
    @required this.iconList,
    @required this.isSelected,
    @required this.onPressed,
  });

  @override
  _WrapToggleIconButtonsState createState() => _WrapToggleIconButtonsState();
}

class _WrapToggleIconButtonsState extends State<WrapToggleIconButtons> {
  int index;

  @override
  Widget build(BuildContext context) {
    assert(widget.iconList.length == widget.isSelected.length);
    index = -1;
    return Wrap(
      children: widget.iconList.map((String icon){
        index++;
        return IconToggleButton(
          active: widget.isSelected[index],
          icon: icon,
          onTap: widget.onPressed,
          index: index,
        );
      }).toList(),
    );
  }
}

class IconToggleButton extends StatelessWidget {
  final bool active;
  final String icon;
  final Function onTap;
  final int width;
  final int height;
  final int index;

  IconToggleButton({
    @required this.active,
    @required this.icon,
    @required this.onTap,
    @required this.index,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.transparent,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(icon, style: TextStyle(color: active ? Colors.white : Colors.black87,),),
        ),
        onTap: () => onTap(index),
      ),
    );
  }
}
