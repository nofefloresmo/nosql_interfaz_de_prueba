import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../env/host.dart';

class ImportDataScreen extends StatefulWidget {
  @override
  _ImportDataScreenState createState() => _ImportDataScreenState();
}

class _ImportDataScreenState extends State<ImportDataScreen> {
  final String localIp = Host.getHost(); // Default

  Future<void> importData() async {
    // Llama a la API para importar datos
    final response =
        await http.post(Uri.parse('http://$localIp:3000/tecnm/importar-datos'));
    if (response.statusCode == 201) {
      // Si la llamada a la API fue exitosa, muestra un snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos importados exitosamente')));
    } else {
      // Si la llamada a la API falló, muestra un snackbar
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al importar datos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Importar Datos'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: importData,
          child: Text('Importar Datos'),
        ),
      ),
    );
  }
}
