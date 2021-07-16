
import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/Announcement.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubmitAssignment.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Repositories/teacher_repo.dart';
import 'package:provider/provider.dart';


class AnnouncementProvider with ChangeNotifier {
  TeacherRepository _todayClassRepository;
  List<Announcement> _announcement;

  List<Announcement> get announcement => _announcement;


  AnnouncementProvider() {
    _todayClassRepository = TeacherRepository();
    // fetchAssignmentsByTid(null);
  }

  fetchAnnouncement(BuildContext context, String teaId) async {
    String tid = context == null ? teaId : Provider.of<TeacherProvider>(context, listen: false).teacher.Data.Id;
    CustomResponse<List<Announcement>> assignment = await _todayClassRepository.fetchAnnouncement(context, tid);
    print(assignment.Data);
    _announcement = assignment?.Data;
    _announcement.sort((a, b) => a.StartDate.compareTo(b.StartDate));
    notifyListeners();
    // return todayTimeTable;
  }

  Future<int> addAssignment(BuildContext context, Announcement announcement) async {
    CustomResponse<Announcement> res = await _todayClassRepository.addAnnouncement(context, announcement);
    if(res.Status == 1){
      String tid = Provider.of<TeacherProvider>(context, listen: false).teacher.Data.Id;
      fetchAnnouncement(null, tid);
    }
    return res.Status;
  }



}