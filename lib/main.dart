import 'dart:async';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';
import 'package:flutter/material.dart';
import 'package:todo/colors.dart';
import 'package:quick_actions/quick_actions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller1 = TextEditingController();
  FocusNode taskfield = FocusNode();
  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  List<Tasks> alltasklist = <Tasks>[
    Tasks(maintask: 'Take bath', isDone: false, subtask: [
      Tasks(subtask: [], maintask: 'Go to bathroom', isDone: false),
      Tasks(subtask: [], maintask: 'Take shower', isDone: false)
    ]),
    Tasks(maintask: 'Get ready', isDone: false, subtask: [
      Tasks(subtask: [], maintask: 'Put on cloths', isDone: false),
      Tasks(subtask: [], maintask: 'Do breakfast', isDone: false)
    ])
  ];

  final quickActions = const QuickActions();
  List<Tasks> searchtask = [];
 

  @override
  void initState() {
    super.initState();
    quickActions.setShortcutItems(
        [const ShortcutItem(type: 'add', localizedTitle: 'Add new task')]);
    quickActions.initialize((type) {
      if (type == 'add') {
        Future.delayed(Duration.zero, () {
          FocusScope.of(context).requestFocus(taskfield);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.menu,
                color: black,
                size: 30,
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: TextField(
                        onChanged: (value) => handlesearch(value),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(color: gray, fontFamily: 'Mukta'),
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 30,
                            // color: Colors.black87,
                          ),
                          border: InputBorder.none,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Today Tasks',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Mukta')),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: FocusedMenuHolder(
                              menuItems: <FocusedMenuItem>[
                                FocusedMenuItem(
                                  title: const Text('Add a subtask'),
                                  trailingIcon: const Icon(Icons.add),
                                  onPressed: () {
                                    openDialog(index);
                                  },
                                ),
                                FocusedMenuItem(
                                  title: const Text('Delete',
                                      style: TextStyle(color: Colors.white)),
                                  trailingIcon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: red,
                                  onPressed: () {
                                    setState(() {
                                      alltasklist.removeAt(index);
                                    });
                                  },
                                )
                              ],
                              animateMenuItems: true,
                              onPressed: () {},
                              menuWidth:
                                  MediaQuery.of(context).size.width * 0.5,
                              child: ExpansionTile(
                                leading: Icon(
                                  alltasklist[index].subtask.isEmpty
                                      ? Icons.check_box_outline_blank
                                      : handleTask(index)
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                  color: blue,
                                ),
                                title: Text(
                                  alltasklist[index].maintask,
                                  style: const TextStyle(fontFamily: 'Mukta'),
                                ),
                                children: [
                                  ListView.separated(
                                      itemBuilder: (context, indexone) {
                                        return ListTile(
                                          //  tileColor: Colors.
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 30),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          leading: Icon(
                                            alltasklist[index]
                                                        .subtask[indexone]
                                                        .isDone ==
                                                    true
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: blue,
                                          ),
                                          title: Text(
                                            alltasklist[index]
                                                .subtask[indexone]
                                                .maintask,
                                            style: TextStyle(
                                              fontFamily: 'Mukta',
                                              decoration: alltasklist[index]
                                                          .subtask[indexone]
                                                          .isDone ==
                                                      true
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              decorationThickness: 3.0,
                                            ),
                                          ),
                                          trailing: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                color: red,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              color: Colors.white,
                                              iconSize: 18,
                                              onPressed: () {
                                                setState(() {
                                                  alltasklist[index]
                                                      .subtask
                                                      .removeAt(indexone);
                                                });
                                              },
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              alltasklist[index]
                                                          .subtask[indexone]
                                                          .isDone ==
                                                      true
                                                  ? alltasklist[index]
                                                      .subtask[indexone]
                                                      .isDone = false
                                                  : alltasklist[index]
                                                      .subtask[indexone]
                                                      .isDone = true;
                                            });
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount:
                                          alltasklist[index].subtask.length),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: alltasklist.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, right: 20, left: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: gray,
                              blurRadius: 10,
                              offset: Offset(0.0, 0.0),
                              spreadRadius: 0.0,
                            ),
                          ]),
                      child: TextFormField(
                        focusNode: taskfield,
                        autofocus: true,
                        controller: controller,
                        decoration: const InputDecoration(
                            hintText: 'Add new task',
                            hintStyle:
                                TextStyle(fontSize: 16, fontFamily: 'Mukta'),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15)),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 10, right: 20),
                      child: FloatingActionButton(
                        onPressed: () {
                          addTask(controller.text);
                        },
                        child: const Icon(Icons.add, color: blue),
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  bool handleTask(int index) {
    return alltasklist[index].subtask.every((subtask) => subtask.isDone);
  }

  List<Tasks>? handlesearch(String keyword) {
    List<Tasks> result = [];
    if (keyword.isEmpty) {
      result = alltasklist;
    } else {
      result =
          alltasklist.where((task) => task.maintask.contains(keyword)).toList();
    }
    setState(() {
      searchtask = result;
    });
    return null;
  }

  void addTask(String input) {
    if (input.isNotEmpty) {
      setState(() {
        alltasklist.add(Tasks(subtask: [], maintask: input, isDone: false));
      });
      controller.clear();
    }
  }

  Future<void> openDialog(int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            const Text('Add New Task', style: TextStyle(fontFamily: 'Mukta')),
        content: TextField(
          controller: controller1,
          decoration: const InputDecoration(hintText: 'Add a subtask'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addSubtask(index, controller1.text);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void addSubtask(int index, String input) {
    if (input.isNotEmpty) {
      setState(() {
        alltasklist[index]
            .subtask
            .add(Tasks(subtask: [], maintask: input, isDone: false));
      });
      controller1.clear();
    }
  }
}

class Tasks {
  String maintask;
  List<Tasks> subtask = [];
  bool isDone;

  Tasks({required this.subtask, required this.maintask, required this.isDone});
}
