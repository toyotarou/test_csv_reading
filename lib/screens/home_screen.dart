import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<dynamic>> _csvData = [];
  String? _fileName; // ファイル名を保存するための変数

  ///
  // CSVファイルをピックして読み込むメソッド
  Future<void> _pickAndLoadCsvFile() async {
    // ファイルをピックする
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      // ファイル名を取得
      String fileName = result.files.single.name;

      // 選択したファイルを取得
      File file = File(result.files.single.path!);

      // ファイルの内容をUTF-8で読み込み、CSVとしてパース
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      setState(() {
        _csvData = fields; // CSVデータを保存
        _fileName = fileName; // ファイル名を保存
      });
    } else {
      // ファイルが選択されなかった場合
      print('ファイルが選択されませんでした');
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV File Picker Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickAndLoadCsvFile,
            child: const Text('CSVファイルを選択'),
          ),
          if (_fileName != null) // ファイル名が存在する場合表示
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '選択したファイル: $_fileName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _csvData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_csvData[index].join(', ')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
