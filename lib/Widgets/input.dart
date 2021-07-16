import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/CTSModel.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:provider/provider.dart';


class InputText extends StatelessWidget {
  final String title;
  final bool isPassword;
  final IconData icon;
  final TextEditingController mCtrl;

  const InputText({Key key, this.title, this.isPassword = false, this.icon, this.mCtrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade200,
      ),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      child: TextField(
        obscureText: isPassword,
        controller: mCtrl,
        decoration: InputDecoration(
            hintText: title,
            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            border: InputBorder.none
        ),
      ),
    );
  }
}


class NormalInputText extends StatelessWidget {
  final String title, label;
  final int maxLine;
  final TextEditingController mCtrl;


  const NormalInputText({Key key, this.title, this.mCtrl, this.label, this.maxLine = 1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label == null ? SizedBox.shrink() : Text(label),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: TextField(
              controller: mCtrl,
              maxLines: maxLine,
              decoration: InputDecoration(
                  hintText: title,
                  contentPadding: EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                  border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class NormalDropDown extends StatelessWidget {
  final String label;
  final TextEditingController mCtrl;
  final Function onChanged;
  final List<String> mList;
  final String selectedValue;

  const NormalDropDown({Key key, this.label, this.mCtrl, this.selectedValue, this.onChanged, this.mList, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                underline: SizedBox.shrink(),
                style: TextStyle(color: Colors.black),
                items: mList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  label,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14),
                ),
                onChanged: (String value) {
                  onChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectDropDown extends StatelessWidget {
  final String label;
  final TextEditingController mCtrl;
  final Function onChanged;
  final List<CTSModel> mList;
  final CTSModel selectedValue;

  const SubjectDropDown({Key key, this.label, this.mCtrl, this.selectedValue, this.onChanged, this.mList, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
              child: DropdownButton<CTSModel>(
                value: selectedValue,
                isExpanded: true,
                underline: SizedBox.shrink(),
                style: TextStyle(color: Colors.black),
                items: mList.map<DropdownMenuItem<CTSModel>>((CTSModel value) {
                  return DropdownMenuItem<CTSModel>(
                    value: value,
                    child: Text(Provider.of<TeacherProvider>(context, listen: false).getSubjectById(value.SubjectId).Subject),
                  );
                }).toList(),
                hint: Text(
                  "choose a " + label,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                onChanged: (CTSModel value) {
                  onChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}