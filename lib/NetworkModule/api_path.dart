
enum APIPath {
  fetch_student,
  fetch_teacher,
  fetch_today,
  add_online_class,
  getAllSubjects,
  getAllStudentsByClass,
  getSubmittedAssignment,
  getCTSById,
  updateAssignmentRemark,
  getAssignmentsByTid,
  getAnnouncement,
  addAssignment,
  addAnnouncement,
  fetch_time_table,
}

class APIPathHelper{
  static String getValue(APIPath path, String param){
    switch(path){
      case APIPath.fetch_student:
        return "school/getByPh/" + param;
      case APIPath.updateAssignmentRemark:
        return "assignment/updateAssignmentRemark/" + param;
      case APIPath.fetch_teacher:
        return "Teachers/teacherByPh/" + param;
      case APIPath.fetch_today:
        return "timetable/getTodayTeacherTimeTable" + param;
      case APIPath.fetch_time_table:
        return "TimeTable/getTimeTable" + param;
      case APIPath.add_online_class:
        return "timetable/addOnlineClass";
      case APIPath.getAllSubjects:
        return "timetable/getSubjects";
      case APIPath.getAllStudentsByClass:
        return "school/GetAllStudents" + param;
      case APIPath.getCTSById:
        return "timetable/getCTSById/" + param;
      case APIPath.getSubmittedAssignment:
        return "assignment/getAllSubmittedAssignment/" + param;
      case APIPath.getAssignmentsByTid:
        return "assignment/getAssignmentsByTid/" + param;
      case APIPath.getAnnouncement:
        return "announcement/getAAnnouncement/" + param;
      case APIPath.addAssignment:
        return "assignment/addAssignment";
      case APIPath.addAnnouncement:
        return "announcement/addAnnouncement";
      default:
        return "";
    }
  }
}
