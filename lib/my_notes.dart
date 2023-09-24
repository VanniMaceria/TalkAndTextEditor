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
    if (text.length > 80) {
      return "${text.substring(0, 80)} ...";
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

  void _mostraDialogBox(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Attenzione"),
          content: const Text("Vuoi eliminare la nota?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //Chiudi l'alert
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Color(0xFF225560),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _eliminaNota(index);
                Navigator.pop(context); //Chiudi l'alert
              },
              child: const Text(
                "Si",
                style: TextStyle(
                  color: Color(0xFF225560),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF225560),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
        child: Column(
          children: [
            Expanded(
              //genera una griglia
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      1.2, // Regola il rapporto tra altezza e larghezza delle card
                ),
                itemCount: _noteList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: const Color(0xFFedf6f9),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Stack(
                        children: [
                          ListTile(
                            title: Text(_troncaTesto(_noteList[index])),
                            onTap: () {
                              //è fondamentale che io passi a Nota il contenuto della nota e l'indice
                              _navigateToNota(_noteList[index], index);
                            },
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: -2.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xFFed1c24),
                              ),
                              onPressed: () {
                                _mostraDialogBox(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF0803C),
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
