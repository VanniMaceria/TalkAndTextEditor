import 'package:flutter/material.dart';
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

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
        listenMode: stt.ListenMode.dictation, // Impostato il listenMode
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
                Navigator.of(context).pop(); // Chiudi l'alert
              },
              child: const Text(
                "No",
                style: TextStyle(color: Color(0xFF9d69a3)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Salva la registrazione nella nota scritta
                // (Aggiungi qui il codice per salvare la registrazione)
                Navigator.of(context).pop(); // Chiudi l'alert
              },
              child:
                  const Text("Si", style: TextStyle(color: Color(0xFF9d69a3))),
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
        backgroundColor: const Color(0xFF9d69a3),
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
                // Aggiunto questo widget
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        backgroundColor: const Color(0xFF9d69a3),
                        fixedSize: const Size(170, 100),
                      ),
                      child: const Text(
                        "Avvia registrazione",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
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
                      child: const Text(
                        "Arresta registrazione",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 24, color: Color(0xFFed1c24)),
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
