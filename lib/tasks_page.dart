import 'dart:ui';

import 'package:chaidoro20/Assets/SubTaskWidget.dart';
import 'package:chaidoro20/Assets/custom_widgets.dart';
import 'package:chaidoro20/Assets/task_widget.dart';
import 'package:chaidoro20/screen_dimension.dart';
import 'package:chaidoro20/db/db_provider.dart';
import 'package:chaidoro20/task_list_view.dart';
import 'package:flutter/material.dart';
import 'Assets/svgs.dart';
import 'Models/task.dart';
import 'main.dart';
import 'editing.dart';
class TaskPage extends StatefulWidget {
  const TaskPage( {super.key} );

  @override
  State<TaskPage> createState() => _TaskPageState();

}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin, RouteAware{

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }
  late AnimationController _animationController ;
  late Animation<double> blurAnimation;

  MapEntry<Task, List<SubTask>> selectedTaskMap =<Task, List<SubTask>> { Task(id:0,title: "", dateCreated: DateTime.now(),seconds: 0) : <SubTask>[]}.entries.first ;


  int editTaskId = -1;
  int editSubtaskId = -1;
  bool editing = false;
  bool taskEditing = false;
  bool subtaskEditing = false;
  bool taskAdding = false;
  bool subtaskAdding =false ;


  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  late ValueChanged<String> _onSubmitted ;
  String textfieldHint = "Enter a new task ฅ^•ﻌ•^ฅ";


  @override
  void initState()  {
    // TODO: implement initState

    //Animation
    _animationController = AnimationController(duration: const Duration(milliseconds: 350),vsync: this);
    blurAnimation = Tween<double>(begin: 0, end: 15).chain(CurveTween(curve: Curves.easeIn)).animate(_animationController);
    _animationController.addListener(() {
      setState(() {
      });
    });

    //TaskView
    DbProvider.instance.updateController.listen((event) async{
      selectedTaskMap = await DbProvider.instance.queryTaskId(editTaskId) ;
      setState(() {
      });
    });
    EditController.instance.editController.stream.listen((event) async {
      // addSubtask [ n : -1 ]
      // addTask [ -1 : -1 ]
      // selectSubtask [ n : m ]
      // selectTask [ n : -2 ]
      // MapEntries for editing
      if(event.key!=-1){
        editing = true;
        if(event.value==-1){
          subtaskEditing = false;
          taskAdding = false;
          taskEditing = false;

          subtaskAdding =true ;
          editTaskId = event.key;
          selectedTaskMap = await DbProvider.instance.queryTaskId(editTaskId);
          editSubtaskId = -1;
          _controller.text = "";
        }else if(event.value==-2){
           subtaskEditing = false;
           taskAdding = false;
           subtaskAdding =false;

           taskEditing = true;
           editTaskId = event.key;
           selectedTaskMap = await DbProvider.instance.queryTaskId(editTaskId);
           editSubtaskId = -2;
           _controller.text = selectedTaskMap.key.title;
        }else{
          taskAdding = false;
          subtaskAdding =false;
          taskEditing = false;

          subtaskEditing = true;
          editTaskId = event.key;
          selectedTaskMap = await DbProvider.instance.queryTaskId(editTaskId);
          editSubtaskId = event.value;
          print("$editSubtaskId selected");

          selectedTaskMap.value.forEach((element) {
           if(element.subtaskId==editSubtaskId){
             _controller.text = element.subtitle;

           }
          });
        }
        _focusNode.requestFocus();
      }
      setState(() {});
    });
    _focusNode.addListener(() {
      if(_focusNode.hasFocus){
        if(editTaskId == -1){
          taskAdding = true;

          subtaskEditing = false;
          taskEditing = false;
          subtaskAdding =false ;
          editTaskId = -1;
          editSubtaskId = -1;
        }else{
          _animationController.forward();
        }
      }else{
        print("reset");
        subtaskEditing = false;
        taskAdding = false;
        taskEditing = false;
        subtaskAdding =false ;
        editTaskId = -1;
        editSubtaskId = -1;
        _controller.text = "";
        setState(() {
        });
        _animationController.reverse();
      }
    });

    //Text manipulation
    _onSubmitted = (_) async {
      print("done 1");
      if (taskAdding) {
        Task newTask = Task(
          title: _controller.text,
          dateCreated: DateTime.now(),
          seconds: 0,
        );
        await DbProvider.instance.insertTask(newTask);
        print("done 3");
        taskAdding = false;
      }else if(editing){
        print("done 2");
        if(subtaskAdding){
          SubTask newSubTask = SubTask(taskId: editTaskId, subtitle: _controller.text,toggleOn:0);
          await DbProvider.instance.insertSubTask(newSubTask);
        }else {
          if (taskEditing) {
            await DbProvider.instance
                .updateTaskTitle(editTaskId, _controller.text);
            taskEditing = false;
            editTaskId = -1;
            editSubtaskId = -1;
          } else if (subtaskEditing) {
            await DbProvider.instance
                .updateSubtask(editSubtaskId, 0, _controller.text);
            subtaskEditing = false;
            editTaskId = -1;
            editSubtaskId = -1;
          }
          _focusNode.unfocus();
        }
      }
      _controller.text = "";
      setState(() {});
    };
    _controller=TextEditingController();
    _controller.addListener(() { setState(() {}); });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  const Color.fromRGBO(247, 218, 210, 1),
        body: Center(
            child: Stack(
              children: [
                Container(
                  width:100.vw(context),
                  height: 100.vh(context),
                  padding: EdgeInsets.only(top: 1.getPadding(context).top,bottom: 1.getPadding(context).bottom),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 40,
                          padding:const EdgeInsets.only(bottom: 15),
                          child:  FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(dateTimeFormatter(DateTime.now()),style:const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: TaskListView()
                        ),
                        const SizedBox(
                          width: double.maxFinite,
                          height: 70,
                        )
                      ],
                    ),
                  ),
                ),
                //Start Point of TaskEditWidget
                if(blurAnimation.value!=0 && editing) Opacity(
                  opacity: blurAnimation.value/15,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurAnimation.value,sigmaY: blurAnimation.value ),
                    child: Container(
                      width: 100.vw(context),
                      height: 100.vh(context),
                      padding: EdgeInsets.only(top: 1.getPadding(context).top + 40,bottom: 1.getPadding(context).bottom),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: double.maxFinite,
                                        child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child:  Container(
                                              width: 100,
                                              padding: const EdgeInsets.only(top: 15,left: 20, right: 15,bottom: 15 ),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(23  ),
                                                  border: Border.all(color: Colors.black, width: 1.5, ),
                                                  color:  const Color.fromRGBO(247, 218, 210, 1)
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: GestureDetector(
                                                              onTap: (){
                                                                EditController.instance.editController.add(MapEntry(selectedTaskMap.key.id!, -2));
                                                              },
                                                              child: Text((editSubtaskId==-2 && editing)? _controller.text :  selectedTaskMap.key.title , style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w800,height: 1.0),))
                                                      ),
                                                      GestureDetector(
                                                          onTap: (){
                                                            EditController.instance.editController.add( MapEntry(selectedTaskMap.key.id!,-1));
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: plusIcon(),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: double.maxFinite,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemCount:  selectedTaskMap.value.length,
                                                            itemBuilder: (context, index){
                                                              return Dismissible(
                                                                  key: UniqueKey(),
                                                                  onDismissed: (direction) async {
                                                                    await DbProvider.instance.deleteSubTask( selectedTaskMap.value.elementAt(index).subtaskId!);
                                                                    selectedTaskMap.value.removeAt(index);
                                                                    setState(() {});
                                                                  },
                                                                  background:Container(color: Colors.red,),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(top: 7),
                                                                    child: SubTaskWidget(
                                                                      subtitle: (selectedTaskMap.value.elementAt(index).subtaskId == editSubtaskId&&editing)? _controller.text : selectedTaskMap.value.elementAt(index).subtitle ,
                                                                      toggleOn:  selectedTaskMap.value.elementAt(index).toggleOn ,
                                                                      subtaskId: selectedTaskMap.value.elementAt(index).subtaskId!,
                                                                      taskId: selectedTaskMap.key.id!,
                                                                    ),
                                                                  )
                                                              );
                                                            },
                                                            padding: const EdgeInsets.only(left: 5,top: 4,right: 0,bottom: 0),
                                                          ),
                                                        ),
                                                        if(subtaskAdding) Container(
                                                            width: double.maxFinite,
                                                            padding: const EdgeInsets.only(left: 5,top: 7),
                                                            child: SubTaskWidget(subtitle:  _controller.text , toggleOn: 0, subtaskId: 0,taskId: 0,)
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                            // child: TaskEditWidget(taskMap: selectedTaskMap, input: _controller.text,addSubTask: addSubtask,editDone: editDone,subtaskId: editSubtaskIndex,)
                                        ),
                                    ),
                                  ],
                                ),
                            ),
                            const SizedBox(
                              width: double.maxFinite,
                              height: 70,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width:100.vw(context),
                  height: 100.vh(context),
                  padding: EdgeInsets.only(top: 1.getPadding(context).top,bottom: 1.getPadding(context).bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 0.2),
                        child: SizedBox(
                          width: double.maxFinite+.0,
                          child: Image.asset(
                            "assets/sideImage.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 95,
                        color:  const Color.fromRGBO(247, 218, 210, 1),
                        // color: Colors.red,
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                top: 0,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 67.vw(context),
                                    maxWidth: 90.vw(context)
                                  ),
                                  child: IntrinsicWidth(
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      onChanged: (values){
                                        setState(() {});
                                      },
                                      autocorrect: false,
                                      focusNode: _focusNode,
                                      controller: _controller,
                                      textInputAction: TextInputAction.unspecified,
                                      onSubmitted: _onSubmitted,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black
                                      ),
                                      decoration: InputDecoration(
                                        hintStyle:const TextStyle(
                                            color: Colors.black
                                        ),
                                        hintText: textfieldHint,
                                        focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(70),borderSide: const BorderSide(strokeAlign: BorderSide.strokeAlignCenter,width: 1.5,color: Colors.black)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(70),borderSide: const BorderSide(strokeAlign: BorderSide.strokeAlignCenter,width: 1.5,color: Colors.black)),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(70),borderSide: const  BorderSide(strokeAlign: BorderSide.strokeAlignCenter,width: 1.5,color: Colors.black)),
                                        contentPadding: null,
                                      ),
                                    )  ,
                                  ),
                                )
                            ),
                            Positioned(
                              top: -8.5,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(247, 218, 210, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black,width:3,strokeAlign: BorderSide.strokeAlignCenter)
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: smallPlus()
                              ),
                            ),
                          ],
                        ) ,
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );

  }

  @override
  void dispose(){
    _animationController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
