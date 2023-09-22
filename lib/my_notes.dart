import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_and_text_editor/nota.dart';
import 'info.dart';

class MyNotes extends StatefulWidget {
  const MyNotes({super.key});

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  List<String> _noteList = [];

  @override
  void initState() {
    super.initState();
    _loadNoteList();
  }

  void _loadNoteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? noteList = prefs.getStringList('listaNote');

    print("Lista note:  " + noteList!.join("\n"));

    if (noteList != null) {
      setState(() {
        _noteList = noteList;
      });
    }
  }

  String _troncaTesto(String text) {
    if (text.length > 200) {
      return "${text.substring(0, 200)} ...";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9d69a3),
        title: const Text(
          "Le mie note",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Info()),
                );
              },
              icon: const Icon(
                Icons.toc_outlined,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        //genera una lista di Widget in base ai dati forniti da SharedPreferences
        itemCount: _noteList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_troncaTesto(_noteList[index])),
              // Altri widget o azioni associati alla nota
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9d69a3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const Nota(
                        testo: "",
                      ))));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
