import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_demo/ui/home.dart';
import 'package:sqlite_demo/ui/mainpage.dart';
import 'package:sqlite_demo/ui/signin.dart';
import 'package:sqlite_demo/ui/signup.dart';
import 'package:sqlite_demo/ui/splash_screen.dart';
import 'package:sqlite_demo/ui/test.dart';
import 'package:sqlite_demo/ui/userform.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:sqlite_demo/databasehelper.dart';
// import 'note.dart';
//
// void main() => runApp(MaterialApp(home:MyApp()));
//
// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final DBHelper dbHelper = DBHelper();
//  Random _random=new Random();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Notes App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Scaffold(
//         appBar: AppBar(title: Text('Notes')),
//         body: FutureBuilder<List<Note>>(
//           future: dbHelper.getAllNotes(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final notes = snapshot.data;
//               return ListView.builder(
//                 itemCount: notes?.length,
//                 itemBuilder: (context, index) {
//                   final note = notes?[index];
//
//                   return ListTile(
//                     title: Text(note?.title ?? ''),
//                     subtitle: Text(note?.content ?? ''),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         _deleteNoteById(note?.id ?? 0);
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.add),
//           onPressed: () {
//             _showNoteDialog(context);
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<void> _showNoteDialog(BuildContext context) async {
//
//     TextEditingController _titleController = TextEditingController();
//     TextEditingController _contentController = TextEditingController();
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Note'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                   controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 onChanged: (value) {
//
//                 },
//               ),
//               TextField(
//                 controller: _contentController,
//                 decoration: InputDecoration(labelText: 'Content'),
//                 onChanged: (value) {
//                   //newNote.content = value;
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Save'),
//               onPressed: () async {
//
//
//                 await dbHelper.insertNote(Note(id:_random.nextInt(100),
//                     title:_titleController.text,content:  _contentController.text));
//                 Navigator.of(context).pop();
//                 setState(() {});
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _deleteNoteById(int id) async {
//     await dbHelper.deleteNote(id);
//     setState(() {});
//   }
// }

