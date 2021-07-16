

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:guardian_teacher/Model/Announcement.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/CTSModel.dart';
import 'package:guardian_teacher/Model/OnlineClass.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/SubjectModel.dart';
import 'package:guardian_teacher/Model/SubmitAssignment.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/Model/TimeTable.dart';
import 'package:guardian_teacher/NetworkModule/api_path.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/NetworkModule/http_client.dart';



class TeacherRepository {
  Future<CustomResponse<Teacher>> fetchTeacherDetails(BuildContext context, String ph, String from, String tid, String password) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.fetch_teacher, ph));
    CustomResponse<Teacher> ss = CustomResponse<Teacher>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? Teacher.fromJson(response.Data) : null);
    return ss;
  }

  Future<CustomResponse<String>> updateAssignmentRemark(BuildContext context, String subId, String remark) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.updateAssignmentRemark, "?subId=" + subId + "&remark=" + remark));
    CustomResponse<String> ss = CustomResponse<String>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? response.Data.toString() : null);
    return ss;
  }

  Future<CustomResponse<List<SubjectModel>>> fetchAllSubjects(BuildContext context) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.getAllSubjects, ""));
    CustomResponse<List<SubjectModel>> ss = CustomResponse<List<SubjectModel>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ?  List<SubjectModel>.from(response.Data.map((model)=> SubjectModel.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<Student>>> fetchAllStudentsByClass(BuildContext context, String std, String section) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.getAllStudentsByClass, "?cls=" + std + "&sec=" + section));
    CustomResponse<List<Student>> ss = CustomResponse<List<Student>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ?  List<Student>.from(response.Data.map((model)=> Student.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<SubmitAssignments>>> fetchSubmittedAssignment(BuildContext context, String assigId) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.getSubmittedAssignment, "?assigId=" + assigId));
    CustomResponse<List<SubmitAssignments>> ss = CustomResponse<List<SubmitAssignments>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? List<SubmitAssignments>.from(response.Data.map((model)=> SubmitAssignments.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<CTSModel>>> fetchCTSByTid(BuildContext context, String tid) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.getCTSById, tid));
    CustomResponse<List<CTSModel>> ss = CustomResponse<List<CTSModel>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ?  List<CTSModel>.from(response.Data.map((model)=> CTSModel.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<Assignment>>> fetchAssignmentsByTid(BuildContext context, String tid) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.getAssignmentsByTid, tid));
    CustomResponse<List<Assignment>> ss = CustomResponse<List<Assignment>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ?  List<Assignment>.from(response.Data.map((model)=> Assignment.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<Announcement>>> fetchAnnouncement(BuildContext context, String tid) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.getAnnouncement, "?from=teacher" + "&std=" + "" + "&section=" + "" + "&tid=" + tid));
    CustomResponse<List<Announcement>> ss = CustomResponse<List<Announcement>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ?  List<Announcement>.from(response.Data.map((model)=> Announcement.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<TimeTable>>> fetchTodayClass(BuildContext context, String from, String tid) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.fetch_today, "?from="+ from + "&tid=" + tid));
    print(response.Data);
    CustomResponse<List<TimeTable>> ss = CustomResponse<List<TimeTable>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? List<TimeTable>.from(response.Data.map((model)=> TimeTable.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<List<TimeTable>>> fetchTimeTable(BuildContext context, String from, String std, String section) async {
    final response = await HttpClient.instance.fetchData(context, APIPathHelper.getValue(APIPath.fetch_time_table, "?from="+ from + "&std=" + std + "&section=" + section));
    print(response.Data);
    CustomResponse<List<TimeTable>> ss = CustomResponse<List<TimeTable>>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? List<TimeTable>.from(response.Data.map((model)=> TimeTable.fromJson(model))) : null);
    return ss;
  }

  Future<CustomResponse<OnlineClass>> addOnlineClass(BuildContext context, OnlineClass onlineClass) async {
    CustomRequest c = CustomRequest(Data: onlineClass.toJson());
    String sendingJ = json.encode(c.toJson());
    final response = await HttpClient.instance.postData(context, APIPathHelper.getValue(APIPath.add_online_class, ""), sendingJ);
    CustomResponse<OnlineClass> ss = CustomResponse<OnlineClass>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? OnlineClass.fromJson(response.Data) : null);
    return ss;
  }

  Future<CustomResponse<Assignment>> addAssignment(BuildContext context, Assignment assignment) async {
    CustomRequest c = CustomRequest(Data: assignment.toJson());
    String sendingJ = json.encode(c.toJson());
    final response = await HttpClient.instance.postData(context, APIPathHelper.getValue(APIPath.addAssignment, ""), sendingJ);
    CustomResponse<Assignment> ss = CustomResponse<Assignment>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? Assignment.fromJson(response.Data) : null);
    return ss;
  }

  Future<CustomResponse<Announcement>> addAnnouncement(BuildContext context, Announcement announcement) async {
    CustomRequest c = CustomRequest(Data: announcement.toJson());
    String sendingJ = json.encode(c.toJson());
    final response = await HttpClient.instance.postData(context, APIPathHelper.getValue(APIPath.addAnnouncement, ""), sendingJ);
    CustomResponse<Announcement> ss = CustomResponse<Announcement>(Error: response?.Error, Status: response?.Status, Data: response?.Data != null ? Announcement.fromJson(response.Data) : null);
    return ss;
  }
}