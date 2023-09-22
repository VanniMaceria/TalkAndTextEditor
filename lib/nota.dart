import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_and_text_editor/main.dart';
import 'package:talk_and_text_editor/my_notes.dart';
import 'package:talk_and_text_editor/registra.dart';

class Nota extends StatefulWidget {
  const Nota({super.key});

  @override
  State<Nota> createState() => _NotaState();
}

class _NotaState extends State<Nota> {
  TextEditingController _noteController = TextEditingController();

  void _salvaNota() {
    String nota = _noteController.text;
    // Aggiungi il codice per salvare la nota sulla memoria del cellulare
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
          Fluttertoast.showToast(
              msg: "Nota salvata",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);

          Timer(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
