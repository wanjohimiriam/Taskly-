import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _devHeight, _devWidth;

  String? _newTaskContent;
  Box? _box2;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;
    //print("input value:$_newTaskContent");
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: _devHeight * 0.15,
        title: const Text(
          "Taskly!",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox("tasks"),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            _box2 = _snapshot.data;
            return _taskkList();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  // Task _newTask =
  //       Task(content: 'Read A Book!', timestamp: DateTime.now().toString(), done: false);
  // _box2?.add(_newTask.toMap());

  Widget _taskkList() {
    List tasks = _box2!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext _context, int _index) {
          final task = Task.fromMap(tasks[_index]);
          return ListTile(
              title: Text(
                task.content,
                style: TextStyle(
                    decoration: task.done ? TextDecoration.lineThrough : null),
              ),
              subtitle: Text(task.timestamp),
              trailing: Icon(
                task.done
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: Colors.red,
              ),
              onTap: () {
                task.done = !task.done;
                _box2!.putAt(_index, task.toMap());
                setState(() {});
              },
              onLongPress: (){
                _box2!.deleteAt(_index);
                setState(() {});
              },
              );
        });
  }

  // List tasks = _box2!.values.toList();
  // return ListView.builder(
  //   itemCount: tasks.length,
  //   itemBuilder: (BuildContext _context, int _index){
  //   var task = Task.fromMap(tasks[_index]);
  //     return ListTile(
  //       title: const Text(
  //         "Make a login Screen",
  //         style: TextStyle(decoration: TextDecoration.lineThrough),
  //       ),
  //       subtitle: Text(
  //         DateTime.now().toString()),
  //       trailing: const Icon(
  //         Icons.check_box_outlined,
  //         color: Colors.red,
  //       ),
  //     );
  //   }
  //   );
  //}

  //   ListView(
  //     children: [
  //       ListTile(
  //         title: const Text(
  //           "Do Laundry!",
  //           style: TextStyle(decoration: TextDecoration.lineThrough),
  //         ),
  //         subtitle: Text(DateTime.now().toString()),
  //         trailing: const Icon(
  //           Icons.check_box_outlined,
  //           color: Colors.red,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: Icon(Icons.add),
    );
  }

  void _displayTaskPopup() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text("Add New Task!"),
            content: TextField(onSubmitted: (_value) {
              if (_newTaskContent != null) {
                var _task = Task(
                    content: _newTaskContent!,
                    timestamp: DateTime.now().toString(),
                    done: false);
                _box2!.add(_task.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
            }, onChanged: (_value) {
              setState(() {
                _newTaskContent = _value;
              });
            }),
          );
        });
  }
}
