
import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubmitAssignment.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Repositories/teacher_repo.dart';
import 'package:provider/provider.dart';


class AssignmentProvider with ChangeNotifier {
  TeacherRepository _todayClassRepository;
  List<Assignment> _assignments;
  List<Student> currentClassStudents;
  List<SubmitAssignments> currentSubmittedAssignments;


  List<Assignment> get assignments => _assignments;


  AssignmentProvider() {
    _todayClassRepository = TeacherRepository();
    // fetchAssignmentsByTid(null);
  }

  fetchAssignmentsByTid(BuildContext context, String teaId) async {
    String tid = context == null ? teaId : Provider.of<TeacherProvider>(context, listen: false).teacher.Data.Id;
    CustomResponse<List<Assignment>> assignment = await _todayClassRepository.fetchAssignmentsByTid(context, tid);
    print(assignment.Data);
    _assignments = assignment?.Data;
    _assignments.sort((a, b) => a.EndDate.compareTo(b.EndDate));
    notifyListeners();
    // return todayTimeTable;
  }

  Future<int> addAssignment(BuildContext context, Assignment assignment) async {
    CustomResponse<Assignment> res = await _todayClassRepository.addAssignment(context, assignment);
    if(res.Status == 1){
      String tid = Provider.of<TeacherProvider>(context, listen: false).teacher.Data.Id;
      fetchAssignmentsByTid(null, tid);
    }
    return res.Status;
  }

  fetchCurrentClassStudents(BuildContext context, Assignment assig) async{
    currentClassStudents = null;
    CustomResponse<List<Student>> allStudents = await _todayClassRepository.fetchAllStudentsByClass(context, assig.Std, assig.Section);
    if(allStudents.Status == 1){
      print("students: " + allStudents.Data.length.toString());
      currentClassStudents = allStudents.Data;
      notifyListeners();
    }
  }

  Future<int> updateAssignmentRemark(BuildContext context, String id, String remark, int submittedIndex)async{
    CustomResponse<String> update = await _todayClassRepository.updateAssignmentRemark(context, id, remark);
    if(update.Status == 1){
      print(update.Data);
      currentSubmittedAssignments[submittedIndex].Remark = remark;
      notifyListeners();
    }
    return update.Status;
  }

  fetchSubmittedAssignment(BuildContext context, Assignment assignment) async {
    currentSubmittedAssignments = null;
    CustomResponse<List<SubmitAssignments>> submittedResponse = await _todayClassRepository.fetchSubmittedAssignment(context, assignment.Id);
    if (submittedResponse.Status == 1){
      print(submittedResponse.Data.length);
      currentSubmittedAssignments = submittedResponse.Data;
      notifyListeners();
    }else{
      currentSubmittedAssignments = [];
      notifyListeners();
    }

  }


}