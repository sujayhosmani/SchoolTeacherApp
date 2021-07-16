import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/TimeTable.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Repositories/teacher_repo.dart';
import 'package:provider/provider.dart';


class TimeTableProvider with ChangeNotifier {
  int selectedIndex = 0;
  TeacherRepository _studentRepository;
  List<String> headerArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  ScrollController controller = ScrollController();
  List<TimeTable> timeTable;

  TimeTableProvider() {
    _studentRepository = TeacherRepository();
    selectedIndex = 0;

  }

  fetchTimeTable(BuildContext context, from, String std, String sec) async{
    timeTable = null;
    if (timeTable == null && std != null){
      CustomResponse<List<TimeTable>> todayTimeTable = await _studentRepository.fetchTimeTable(context,from, std,sec);
      timeTable = todayTimeTable?.Data;
      timeTable?.sort((a, b) => a.FromTime.compareTo(b.FromTime));
      notifyListeners();
    }
  }



  onChangeWeek(int index){
    selectedIndex = index;
    controller.animateTo(getScrollValue(), duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    notifyListeners();
  }

  double getScrollValue() {
    if (selectedIndex == 0){
      return  controller.position.minScrollExtent;
    }else if (selectedIndex == 1){
      return  controller.position.minScrollExtent + 10;
    }else if (selectedIndex == 2){
      return controller.position.minScrollExtent + 20;
    }else if (selectedIndex == 3){
      return  controller.position.minScrollExtent + 30;
    }else if (selectedIndex == 4){
      return  controller.position.maxScrollExtent - 30;
    }else if (selectedIndex == 5){
      return  controller.position.maxScrollExtent - 20;
    }else if (selectedIndex == 6){
      return  controller.position.maxScrollExtent - 10;
    }else if (selectedIndex == 7){
      return  controller.position.maxScrollExtent;
    }else{
      return 0;
    }
  }

}