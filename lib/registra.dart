import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_and_text_editor/nota.dart';
import 'info.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Registra extends StatefulWidget {
  const Registra({Key? key}) : super(key: key);

  @override
  State<Registra> createState() => _RegistraState();
}

class _RegistraState extends State<Registra> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = "";
  List<String>? _noteList = [];

  @override
  void initState() {
    super.initState();
    _caricaLista();
  }

  void _caricaLista() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _noteList = prefs.getStringList('listaNote');
    //print("Lista note: $_noteList");
  }

  int restituisciAlmenoIndiceZero() {
    //se la lista è vuota...
    if (_noteList == null || _noteList!.isEmpty) {
      return 0; //passo l'indice 0 che coincide con l'inizio della lista
    }
    //altrimenti la lista non è vuota e l'indice della nota sarà la sua lunghezza -1
    return _noteList!.length - 1;
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
        listenMode: stt.ListenMode.dictation,
      );
    } else {
      print("Riconoscimento vocale non disponibile");
    }
  }

  void _stopListening() {
    _speech.stop();
  }

  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Salvare la registrazione?"),
          content:
              const Text("Vuoi salvare la registrazione in una nota scritta?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //Chiudi l'alert
              },
              child: const Text(
                "No",
                style: TextStyle(color: Color(0xFF225560), fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //quando vado nella pagina Nota passo il testo, bool e index
                    builder: (context) => Nota(
                      testo: _text,
                      isNewNote: true,
                      index: restituisciAlmenoIndiceZero(),
                    ),
                  ),
                ); // Chiudi l'alert
              },
              child: const Text(
                "Si",
                style: TextStyle(color: Color(0xFF225560), fontSize: 20),
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
          "Talk and Text Editor",
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/img/voice_assistant_pana.png"),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Text(
                    _text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: ElevatedButton(
                      onPressed: _startListening,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF225560),
                        fixedSize: const Size(170, 100),
                      ),
                      child: const FittedBox(
                        //ridimensiona il testo in base alle dimensioni del pulsante
                        child: Text(
                          "Avvia registrazione",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _stopListening();
                        _showSaveConfirmationDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(170, 100),
                          side: const BorderSide(color: Color(0xFFed1c24))),
                      child: const FittedBox(
                        child: Text(
                          "Arresta registrazione",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 24, color: Color(0xFFed1c24)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
