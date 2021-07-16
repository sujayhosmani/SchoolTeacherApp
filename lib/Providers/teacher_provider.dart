import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Constants.dart';
import 'package:guardian_teacher/Model/CTSModel.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Repositories/teacher_repo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TeacherProvider with ChangeNotifier {
  TeacherRepository _teacherRepository;
  CustomResponse<Teacher> _teacher;
  SharedPreferences prefs;
  bool isLoggined = false;

  List<SubjectModel> _allSubjects;
  List<String> _classList;
  List<CTSModel> _allCTSTid;


  List<SubjectModel> get allSubjects => _allSubjects;
  List<String> get classList => _classList;

  List<CTSModel> get allCTSTid => _allCTSTid;

  CustomResponse<Teacher> get teacher => _teacher;

  TeacherProvider() {
    _teacherRepository = TeacherRepository();
    fetchFromSharedPreference();


  }

  Future<CustomResponse<Teacher>> teacherLogin(BuildContext context, String ph, String from, String tid, String password) async {
    CustomResponse<Teacher> teacher = await _teacherRepository.fetchTeacherDetails(context, ph,from, tid, password);
    _teacher = teacher;
    if(_teacher.Data != null){
      saveToSharedPreference();
      fetchSubjects(null);
      fetchCTSByTid(null);
    }
    notifyListeners();
    return teacher;
  }

  fetchFromSharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    String userValues = prefs.getString(loginUser) ?? "";
    if(userValues != ""){
      Teacher tea = Teacher.fromJson(jsonDecode(userValues));
      _teacher = CustomResponse(Data: tea,Status: 1,Error: null);
      fetchSubjects(null);
      fetchCTSByTid(null);
      notifyListeners();
    }
  }

  saveToSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(loginUser, jsonEncode(_teacher.Data.toJson()));
  }

  fetchSubjects(BuildContext context) async {
    CustomResponse<List<SubjectModel>> res = await _teacherRepository.fetchAllSubjects(context);
    _allSubjects = res?.Data;
    notifyListeners();
  }

  fetchCTSByTid(BuildContext context) async {
      CustomResponse<List<CTSModel>> res = await _teacherRepository.fetchCTSByTid(context, _teacher.Data.Id);
      _allCTSTid = res?.Data;
      setClassList(_allCTSTid);
      notifyListeners();

  }

  SubjectModel getSubjectById(String id){
    SubjectModel sub = SubjectModel(SubjectCode: 0, Subject: "Empty");
    return allSubjects?.firstWhere((element) => element.Id == id, orElse: () => sub);
  }

  fetchSubAsy(String id)async{
    await fetchSubjects(null);
    return allSubjects?.where((element) => element.Id == id)?.first;
  }

  void setClassList(List<CTSModel> allCTSTid) {
    _classList = [];
    for(int i = 0; i < allCTSTid.length; i++){
      _classList.add(allCTSTid[i].Std + allCTSTid[i].Section);
      _classList = _classList.toSet().toList();
    }
  }


}