import 'package:flutter/material.dart';
import 'package:guardian_teacher/Model/Student.dart';
import 'package:guardian_teacher/Model/Teacher.dart';
import 'package:guardian_teacher/NetworkModule/api_response.dart';
import 'package:guardian_teacher/Providers/global_provider.dart';
import 'package:guardian_teacher/Providers/teacher_provider.dart';
import 'package:guardian_teacher/Screens/NavScreen/Component/nav_screen.dart';
import 'package:guardian_teacher/Widgets/input.dart';
import 'package:guardian_teacher/Widgets/loading_dialog.dart';

import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController mUserName = TextEditingController();
  TextEditingController mPassword = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("School Name",style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.green.withOpacity(0.8),
        // leading: Icon(Icons.home,),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            // margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Image.asset("assets/images/clogo.png", height: 100,),
                SizedBox(height: 5,),
                Text("My guardian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),),
                SizedBox(height: 30,),

                SizedBox(height: 10,),
                NormalInputText(title: "Enter Username", mCtrl: mUserName,),
                InputText(title: "Password",isPassword: true,mCtrl: mPassword,),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(

                    ),
                    onPressed: (){onLoginClicked(context);},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      child: Text("Login"),
                    )),
                SizedBox(height: 80,),

              ],
            ),
          ),
          Consumer<GlobalProvider>(builder: (context, global, child){
            return LoadingScreen(isBusy: global.isBusy,error: global?.error,);
          })
        ],
      ),
    );
  }

  void onLoginClicked(BuildContext context) async{
    CustomResponse<Teacher> res = await Provider.of<TeacherProvider>(context, listen: false).teacherLogin(context, mUserName.text, "login", "tid","");
    if(res.Status == 1 || res.Data != null){
      print(res.Data);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return NavScreen();
      }));
    }

  }
}

















