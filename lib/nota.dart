import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_and_text_editor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nota extends StatefulWidget {
  final String? testo; //parametro che devo passare alle pagine che vengono qui
  const Nota({Key? key, required this.testo}) : super(key: key);

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

    setState(() {
      _noteList.add(nota); //aggiungo la nota alla lista delle note
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('listaNote', _noteList);

    Fluttertoast.showToast(
      msg: "Nota salvata",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Timer(const Duration(seconds: 2), () {
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
          maxLines: null, // Permette più righe di testo
          expands:
              true, // Espande il TextField per riempire lo spazio disponibile
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
