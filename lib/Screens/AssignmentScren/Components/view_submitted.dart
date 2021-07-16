import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardian_teacher/Helpers/Constants.dart';
import 'package:guardian_teacher/Model/Assignment.dart';
import 'package:guardian_teacher/Model/AssignmentFiles.dart';
import 'package:guardian_teacher/Model/SubmitAssignment.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Screens/AssignmentScren/Widgets/view_images.dart';
import 'package:guardian_teacher/Widgets/input.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ViewSubmitted extends StatefulWidget {
  final SubmitAssignments subAssign;
  final Assignment assig;
  final int submittedIndex;
  final int assignmentIndex;

  const ViewSubmitted({Key key, this.subAssign,this.submittedIndex, this.assig, this.assignmentIndex}) : super(key: key);
  @override
  _ViewSubmittedState createState() => _ViewSubmittedState();
}

class _ViewSubmittedState extends State<ViewSubmitted> {
  List<String> galleryItems = [];
  TextEditingController mRemark = TextEditingController();

  @override
  void initState(){
    galleryItems = [];
    for(int i = 0; i < widget.subAssign.FileUrls.length; i++){

        AssignmentFiles uploadModel = widget.subAssign.FileUrls[i];
        galleryItems.add(uploadModel.ImgUrl);

    }
    setState(() {

    });
    super.initState();
  }

  void open(BuildContext context, final int index) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: false ? Axis.vertical : Axis.horizontal,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: profileUrl ?? "",
              imageBuilder: (context, imageProvider) => Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(width: 50, height: 50, child: CircleAvatar(child: CupertinoActivityIndicator(),backgroundColor: Colors.grey.withOpacity(0.2), )),
              errorWidget: (context, url, error) => Container(width: 50, height: 50, child: CircleAvatar(child: Text("SS"))),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.subAssign.StudentName)),
                      // Text("5th B", style: TextStyle(fontSize: 15),)
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        leadingWidth: 20,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.video_call),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.call),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.assig.Title),
                                Text(widget.assig.Std + "th " + widget.assig.Section)
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text(widget.assig.SubjectName),
                          ],
                        ),
                      ),
                      Divider(height: 2,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(widget.assig.Description),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("End Date: " + widget.assig.EndDate),
                                Text(widget.assig.Status)
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Submitted: " + widget.subAssign.SubmittedDate)
                          ],
                        ),
                      ),
                      Divider(height: 2,),




                    ],
                  ),
                ),
                widget.subAssign.StudentRemark == null || widget.subAssign.StudentRemark == ""  ? SizedBox.shrink() :
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Row(
                        children: [
                          Text("Student: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                          Text(widget.subAssign.StudentRemark),
                        ],
                      ),
                    ),
                    Divider()
                  ],
                ),
                widget.subAssign.Remark == null ? SizedBox.shrink() :
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Row(
                        children: [
                          Text("Teacher Remark: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                          Text(widget.subAssign.Remark),
                        ],
                      ),
                    ),
                    Divider()
                  ],
                ) ,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text("Assignment Files", style: TextStyle(fontSize: 15),),
                      ),
                      SizedBox(height: 5,),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        padding: const EdgeInsets.only(bottom: 190),
                        childAspectRatio: 1,
                        children: List.generate(galleryItems.length, (index) {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: (){ open(context, index); },
                                  child: CachedNetworkImage(
                                    imageUrl: galleryItems[index] ?? "",
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: 300.0,
                                      height: 300.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(child: Container(width: 50, height: 50, child: CircleAvatar(child: CupertinoActivityIndicator(),backgroundColor: Colors.grey.withOpacity(0.2), ))),
                                    errorWidget: (context, url, error) => Container(width: 50, height: 50, child: CircleAvatar(child: Text("SS"))),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
          widget.subAssign.Remark != null ? SizedBox.shrink() : Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 180,
              padding: const EdgeInsets.only(bottom: 30),
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NormalInputText(title: "Enter Remark", label: "Remark", mCtrl: mRemark,),
                  widget.subAssign.Remark != null ? SizedBox.shrink() : ElevatedButton(onPressed: (){onReviewSubmitted();},  child: Text("Remark Assignment")),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  void onReviewSubmitted() async{
    if(mRemark.text.trim().length > 1){
      int val = await Provider.of<AssignmentProvider>(context, listen: false).updateAssignmentRemark(context,  widget.subAssign.Id, mRemark.text, widget.submittedIndex);
      if(val == 1){
        Navigator.pop(context);
      }
    }

  }
}
