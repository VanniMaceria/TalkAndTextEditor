import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_and_text_editor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nota extends StatefulWidget {
  final String? testo;
  final bool isNewNote;
  final int index;
  const Nota(
      {Key? key,
      required this.testo,
      required this.isNewNote,
      required this.index})
      : super(key: key);

  @override
  State<Nota> createState() => _NotaState();
}

class _NotaState extends State<Nota> {
  TextEditingController _noteController = TextEditingController();
  List<String> _noteList = [];

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.testo!;
  }

  void _salvaNota() async {
    String nota = _noteController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingNotes = prefs.getStringList('listaNote');
    int index = widget.index;

    print("Indice nota: $index");

    if (existingNotes != null) {
      if (widget.isNewNote) {
        setState(() {
          _noteList = existingNotes;
          _noteList.add(nota);
        });
      } else {
        _noteList.clear();
        _noteList.addAll(existingNotes);
        // Sovrascrivo il testo della nota esistente
        _noteList[index] = nota;
      }
    } else {
      //se la lista è vuota sarà composta solo da questa prima nota
      setState(() {
        _noteList = [nota];
      });
    }

    //aggiorno la lista delle note
    await prefs.setStringList('listaNote', _noteList);
    //print("Note salvate: $_noteList");

    Fluttertoast.showToast(
      msg: "Nota salvata",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );

    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RootPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedf6f9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9d69a3),
        title: const Text(
          "Nota",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _noteController,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Scrivi la tua nota qui...',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9d69a3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          _salvaNota();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
