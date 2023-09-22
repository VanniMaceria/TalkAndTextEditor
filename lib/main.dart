import 'package:flutter/material.dart';
import 'package:talk_and_text_editor/my_notes.dart';
import 'package:talk_and_text_editor/registra.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Talk and Text Editor',
      theme: ThemeData(
        fontFamily: "TitilliumWeb",
        //imposto il colore di sfondo per tutte le pagine dell'app
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
      ),
      home: const RootPage(), //la schermata di Home è RootPage
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({
    super.key,
  });

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    Registra(),
    MyNotes()
  ]; //lista delle pagine della bottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF7F9F9),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,
            ),
            label: "Registra",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
            ),
            label: "Le mie note",
          ),
        ],
        onTap: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        currentIndex: currentPage,
        selectedItemColor: const Color(
            0xFF9d69a3), // Colore dell'icona della pagina selezionata
        unselectedItemColor: Colors.black87, // Colore delle altre icone
      ),
    );
  }
}
