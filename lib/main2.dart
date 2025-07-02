import 'package:flutter/material.dart';

// 1. main() adalah titik masuk aplikasi, seperti _app.js atau layout.js
//    runApp() akan me-render widget akar ke layar.
void main() {
  runApp(const MyApp());
}

// 2. MyApp adalah widget akar (root widget).
//    Ini adalah StatelessWidget karena tidak akan berubah.
//    MaterialApp adalah widget dasar yang menyediakan banyak fungsionalitas
//    seperti routing, tema, dll.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // `home` adalah halaman pertama yang akan ditampilkan.
      home: const MyHomePage(title: 'Halaman Utama Flutter'),
    );
  }
}
h (counter).
// 3. MyHomePage adalah StatefulWidget karena kontennya akan beruba
//    Ini analog dengan komponen yang memiliki state.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Ini seperti props di React

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 4. _MyHomePageState adalah kelas State yang menyimpan data yang bisa berubah.
class _MyHomePageState extends State<MyHomePage> {
  // `_counter` adalah state kita. `_` di awal nama berarti private.
  int _counter = 0;

  // Metode untuk mengubah state.
  void _incrementCounter() {
    // setState() memberitahu Flutter bahwa state telah berubah
    // dan UI perlu di-rebuild/re-render.
    setState(() {
      _counter++;
    });
  }

  // 5. Metode build() adalah tempat Anda mendefinisikan UI.
  //    Ini akan dipanggil setiap kali setState() dipanggil.
  //    Mirip dengan fungsi render() atau return JSX di React.
  @override
  Widget build(BuildContext context) {
    // Scaffold adalah widget layout dasar untuk sebuah halaman di MaterialApp.
    // Menyediakan AppBar, body, FloatingActionButton, dll.
    return Scaffold(
      appBar: AppBar(
        // `widget.title` digunakan untuk mengakses props dari kelas StatefulWidget.
        title: Text(widget.title),
      ), 
      // `body` adalah konten utama halaman.
      // `Center` adalah widget yang memposisikan anaknya di tengah.
      body: Center(
        // `Column` menyusun widget secara vertikal.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda telah menekan tombol ini sebanyak:',
            ),
            Text(
              '$_counter', // Menampilkan nilai state
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // Tombol aksi mengambang
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Event handler, seperti onClick
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
