import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<String> tasklist = ["Complete Flutter project", "Buy groceries"];
  TextEditingController textcontrol = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _clearAllTasks() {
    if (tasklist.isEmpty) return;
    
    final deletedTasks = List<String>.from(tasklist); // Copy the list
    
    setState(() {
      tasklist.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All tasks cleared'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasklist.addAll(deletedTasks);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(
          elevation: 5,
          shadowColor: Colors.orange.withOpacity(0.5),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("To Do App", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.shade50,
                Colors.orange.shade100,
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),)
                            ]
                          ),
                          child: TextFormField(
                            controller: textcontrol,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a task';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              border: InputBorder.none,
                              hintText: "Enter a new task...",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                tasklist.add(textcontrol.text);
                                textcontrol.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Task added!'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: tasklist.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_outlined,
                                  size: 60, color: Colors.grey.shade400),
                              SizedBox(height: 10),
                              Text(
                                "No tasks yet!",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasklist.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(tasklist[index]),
                              background: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                              secondaryBackground: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm"),
                                      content: Text(
                                          "Are you sure you want to delete this task?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(
                                            "Delete",
                                            style:
                                                TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  final removedTask = tasklist.removeAt(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('"$removedTask" removed'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          setState(() {
                                            tasklist.insert(index, removedTask);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  leading: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade800),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    tasklist[index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: Colors.grey.shade400),
                                    onPressed: () {
                                      setState(() {
                                        tasklist.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: tasklist.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Clear all tasks"),
                        content: Text(
                            "Are you sure you want to delete all tasks?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _clearAllTasks();
                            },
                            child: Text(
                              "Clear All",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.delete_sweep),
                backgroundColor: Colors.red,
                tooltip: 'Clear all tasks',
              )
            : null,
      ),
    );
  }
}