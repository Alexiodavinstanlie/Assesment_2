import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OPANGATIMIN App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  late List<Map<String, dynamic>> _dataTukangOjek = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _dataTukangOjek = await MYSQFLite.instance.getTukangOjek();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tukang Ojek'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _dataTukangOjek.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_dataTukangOjek[index]['nama']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah Order: '),
                      Text('Omset: '),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HalamanTambahTukangOjek()),
                    ).then((_) => _initData());
                  },
                  child: const Text('Tambah Tukang Ojek'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HalamanTambahTransaksi()),
                    ).then((_) => _initData());
                  },
                  child: const Text('Tambah Transaksi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class HalamanTambahTukangOjek extends StatelessWidget {
  // ...

  final _namaController = TextEditingController();
  final _nopolController = TextEditingController();

  void _tambahTukangOjek() async {
    String nama = _namaController.text;
    String nopol = _nopolController.text;

    await MYSQFLite.instance.insertTukangOjek(nama, nopol);

    // Setelah penyisipan berhasil, kembali ke halaman sebelumnya
    Navigator.pop(context as BuildContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tukang Ojek'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nopolController,
              decoration: const InputDecoration(labelText: 'Nomor Polisi'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _tambahTukangOjek,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class HalamanTambahTransaksi extends StatefulWidget {
  const HalamanTambahTransaksi({Key? key}) : super(key: key);

  @override
  _HalamanTambahTransaksiState createState() => _HalamanTambahTransaksiState();
}

class _HalamanTambahTransaksiState extends State<HalamanTambahTransaksi> {
  String _selectedTukangOjek = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              items: const [
                DropdownMenuItem<String>(
                  value: 'Tukang Ojek 1',
                  child: Text('Tukang Ojek 1'),
                ),
                DropdownMenuItem<String>(
                  value: 'Tukang Ojek 2',
                  child: Text('Tukang Ojek 2'),
                ),
                DropdownMenuItem<String>(
                  value: 'Tukang Ojek 3',
                  child: Text('Tukang Ojek 3'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTukangOjek = value!;
                });
              },
              value: _selectedTukangOjek,
              hint: const Text('Pilih Tukang Ojek'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan data transaksi ke database
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
