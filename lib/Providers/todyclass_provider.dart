import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Constants.dart';
import 'package:guardian_teacher/Model/OnlineClass.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/Model/TimeTable.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Repositories/teacher_repo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TodayClassProvider with ChangeNotifier {
  TeacherRepository _todayClassRepository;
  List<TimeTable> _todayClass;
  List<TimeTable> _upClass;


  List<TimeTable> get todayClass => _todayClass;
  List<TimeTable> get upClass => _upClass;


  TodayClassProvider() {
    _todayClassRepository = TeacherRepository();
  }

  fetchTodayClass(BuildContext context, String from) async {
    String tid = Provider.of<TeacherProvider>(context, listen: false).teacher.Data.Id;
    CustomResponse<List<TimeTable>> todayTimeTable = await _todayClassRepository.fetchTodayClass(context,from, tid);

    if(from == "up"){
      _upClass = todayTimeTable?.Data;
    }else{
      _todayClass = todayTimeTable?.Data;
      _todayClass.sort((a, b) => a.FromTime.compareTo(b.FromTime));
    }
    notifyListeners();
    // return todayTimeTable;
  }

  Future<CustomResponse<OnlineClass>> addOnlineClass(BuildContext context, OnlineClass onlineClass, int index, String from) async {
    CustomResponse<OnlineClass> res = await _todayClassRepository.addOnlineClass(context, onlineClass);
    if(res.Status == 1){
      if(from == "up"){
        _upClass[index].weekSub[0].Status = "Resume";
        _upClass[index].weekSub[0].OnlineClassId = res.Data.Id;
      }else{
        _todayClass[index].weekSub[0].Status =  "Resume";
        _todayClass[index].weekSub[0].OnlineClassId = res.Data.Id;
      }
      notifyListeners();
    }
    return res;
  }



}