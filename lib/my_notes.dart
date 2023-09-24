import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_and_text_editor/nota.dart';
import 'info.dart';

class MyNotes extends StatefulWidget {
  const MyNotes({Key? key}) : super(key: key);

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

    if (noteList != null) {
      setState(() {
        _noteList = noteList;
      });
    } else {
      _noteList = [];
    }
  }

  void _eliminaNota(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? noteList = prefs.getStringList('listaNote');

    if (noteList != null) {
      noteList.removeAt(index);

      setState(() {
        _noteList = noteList;
      });

      await prefs.setStringList('listaNote', noteList);
    }
  }

  String _troncaTesto(String text) {
    if (text.length > 200) {
      return "${text.substring(0, 200)} ...";
    }
    return text;
  }

  void _navigateToNota(String nota, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Nota(
          testo: nota,
          //la nota non è nuova, sto accedendo a una nota già in memoria
          isNewNote: false,
          index: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9d69a3),
        automaticallyImplyLeading: false,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _noteList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(_troncaTesto(_noteList[index])),
                    trailing: Container(
                      child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color(0xFFed1c24),
                          ),
                          onPressed: () {
                            _eliminaNota(index);
                          }),
                    ),
                    onTap: () {
                      //è fondamentale che io passsi a Nota il contenuto della nota e l'indice
                      _navigateToNota(_noteList[index], index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9d69a3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => Nota(
                    testo: "",
                    isNewNote: true, //dal pulsante '+' creo nuove note
                    index: _noteList.length,
                  )),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
