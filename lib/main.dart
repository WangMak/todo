import 'package:flutter/material.dart';
import 'task.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'To-Do List',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.blue,
          secondary: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Task> tasks = [];
final TextEditingController titleController = TextEditingController();
final TextEditingController detailsController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController timeController = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: ListView(
        children: getTask(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayDialog(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void addItem(Task task) {
    setState(() {
      tasks.add(task);
    });
    titleController.clear();
    detailsController.clear();
    dateController.clear();
    timeController.clear();
  }

  Widget buildItem(Task task, int i) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => detail(i)),
        ).then((value) => setState(() {}));
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Checkbox(
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  setState(() {
                    tasks[i].remove = value!;
                  });
                },
                value: tasks[i].remove,
              ),
              title: Text(task.title, style: const TextStyle()),
              subtitle: Text(task.duedate + " " + task.time,
                  style: const TextStyle()),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    tasks.removeAt(i);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Future> displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task: '),
            content: Column(children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(hintText: 'Details'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(hintText: 'Due Date'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(hintText: 'Time'),
              ),
            ]),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                  addItem(Task(titleController.text, detailsController.text,
                      dateController.text, timeController.text, false));
                },
              ),
              TextButton(
                child: const Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> getTask() {
    final List<Widget> task = <Widget>[];
    for (int i = 0; i < tasks.length; i++) {
      task.add(buildItem(tasks[i], i));
    }
    return task;
  }
}

class detail extends StatefulWidget {
  final int index;
  const detail(this.index);

  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  void editItem(Task task, int i) {
    setState(() {
      tasks[i] = task;
    });
    titleController.clear();
    detailsController.clear();
    dateController.clear();
    timeController.clear();
  }

  Future<Future> _displayDialog(BuildContext context) async {
    titleController.text = tasks[widget.index].title;
    detailsController.text = tasks[widget.index].details;
    dateController.text = tasks[widget.index].duedate;
    timeController.text = tasks[widget.index].time;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            title: const Text('Edit task'),
            content: Column(children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'title'),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(hintText: 'details'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(hintText: 'date'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(hintText: 'time'),
              ),
            ]),
            actions: <Widget>[
              TextButton(
                child: const Text('Edit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  editItem(
                      Task(titleController.text, detailsController.text,
                          dateController.text, timeController.text, false),
                      widget.index);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Edit Task',
          child: Icon(Icons.food_bank),
          backgroundColor: Colors.grey),
    );
  }
}
