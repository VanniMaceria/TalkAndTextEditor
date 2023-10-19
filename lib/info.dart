import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  List<bool> isExpanded = [false, false, false];
  List<String> titoli = ["Crediti artistici", "Sviluppo"];
  List<String> testiAggiuntivi = [
    "Illustrazioni di Storyset da @freepikcompany",
    "L'applicazione è stata realizzata usando il linguaggio di programmazione Dart ed il framework Flutter"
  ];

  void toggleExpanded(int index) {
    setState(() {
      isExpanded[index] = !isExpanded[index];
    });
  }

  Widget elemento(int index, String titolo, String sottoParagrafo) {
    return Column(
      children: <Widget>[
        ListTile(
          tileColor: const Color(0xFFedf6f9),
          title: Text(
            titolo,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF0803C),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: IconButton(
              onPressed: () {
                toggleExpanded(index);
              },
              icon: Icon(isExpanded[index]
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              color: Colors.white,
            ),
          ),
        ),
        if (isExpanded[index])
          Container(
            width: double.infinity,
            color: const Color(0xFFedf6f9),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                sottoParagrafo,
                style:
                    const TextStyle(fontSize: 16.0, color: Color(0xFF225560)),
              ),
            ),
          ),
      ],
    );
  }

  Widget separatore() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF225560),
        title: const Text(
          "Informazioni",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            elemento(0, titoli[0], testiAggiuntivi[0]),
            separatore(),
            elemento(1, titoli[1], testiAggiuntivi[1]),
            separatore(),
          ],
        ),
      ),
    );
  }
}
