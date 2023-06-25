import 'package:flutter/material.dart';
import 'package:sampleee/database_helper.dart';
import 'package:sampleee/models/task.dart';
import 'package:sampleee/widgets.dart';

import '../models/todo.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  TaskPage({this.task});
  @override
  State<TaskPage> createState() => _TaskState();
}

class _TaskState extends State<TaskPage> {
  DatabaseHelper _dbHelper = new DatabaseHelper();
  String? _taskTitle="";
  int? _taskId=0;
  String? _taskDescription="";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState(){
    if(widget.task!=null){
      //set visibilty to true
      _contentVisible = true;
      _taskTitle = widget.task?.title;
      _taskDescription = widget.task?.description;
      _taskId = widget.task?.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();

  }

  @override
  void dispose()
  {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Image(
                              image: AssetImage('assets/images/back_arrow.png'),
                              height: 30.0,
                              width: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                              focusNode: _titleFocus,
                              onSubmitted: (value) async {

                                //check if the field is not empty
                                if(value != ""){

                                  //check if the field is null
                                  if(widget.task==null){
                                    Task _newTask = Task(
                                      title: value,
                                    );
                                    _taskId = await _dbHelper.insertTask(_newTask);
                                    setState(() {
                                      _contentVisible = true;
                                      _taskTitle = value;
                                    });
                                  }else{
                                    await _dbHelper.updateTaskTitle(_taskId!, value);
                                    print("Task Updtaed");
                                  }
                                  _descriptionFocus.requestFocus();
                                }
                              },
                              controller: TextEditingController()..text = _taskTitle!,
                          decoration: InputDecoration(
                            hintText: "Enter Task Title...",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551)),
                        ))
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                      bottom: 42.0
                    ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if(value != ""){
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId!, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()..text = _taskDescription!,
                        decoration: InputDecoration(
                          hintText: "Enter Description for the Task...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          )
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                        future: _dbHelper.getTodo(_taskId!),
                        builder: (context, snapshot){
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index){
                                return GestureDetector(
                                  onTap: () async {
                                    //switch the todo completion state
                                    if(snapshot.data![index].isDone == 0){
                                      await _dbHelper.updateTodoDone(snapshot.data![index].id, 1);
                                    }
                                    else{
                                      await _dbHelper.updateTodoDone(snapshot.data![index].id, 0);
                                    }
                                    setState(() {});
                                  },
                                  child: TodoWidget(
                                    text: snapshot.data![index].title,
                                    isDone: snapshot.data![index].isDone == 0 ? false : true ,
                                  ),
                                );
                              },

                          ),
                        );
                        }
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 20.0,
                              height: 20.0,
                              margin: EdgeInsets.only(
                                right: 12.0,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(
                                      color: Color(0xFF86829D),
                                      width: 1.5
                                  )

                              ),
                              child: Image(
                                image: AssetImage(
                                    'assets/images/check_icon.png'
                                ),
                                height: 20.0,
                                width: 20.0,
                              )
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                //check if the field is not empty
                                if(value != ""){

                                  //check if the field is null
                                  if(_taskId != 0){

                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                    print("Creating New Todo");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter TODO Item...",
                                border: InputBorder.none,
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                    bottom: 24.0,
                    right: 24.0,
                    child: GestureDetector(
                      onTap: () async {
                        if(_taskId!=0){
                          await _dbHelper.deleteTask(_taskId!);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(

                        child: Image(
                          image: AssetImage(
                              'assets/images/delete_icon.png'
                          ),
                          height: 70.0,
                          width: 70.0,
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
