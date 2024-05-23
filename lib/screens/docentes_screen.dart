import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class DocentesScreen extends StatefulWidget {
  @override
  _DocentesScreenState createState() => _DocentesScreenState();
}

class _DocentesScreenState extends State<DocentesScreen> {
  String localIp = Host.getHost(); // IP de la máquina host

  List<dynamic> docentes = [];
  String? selectedDocenteId;
  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController tecnologicoController = TextEditingController();
  TextEditingController materiasImpartidasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDocentes();
  }

  Future<void> fetchDocentes() async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/docentes'));
    if (response.statusCode == 200) {
      setState(() {
        docentes = json.decode(response.body);
      });
    }
  }

  Future<void> getDocenteById(String id) async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/docentes/$id'));
    if (response.statusCode == 200) {
      final docente = json.decode(response.body);
      setState(() {
        selectedDocenteId = docente['_id'];
        idController.text = docente['_id'];
        nombreController.text = docente['nombre'];
        carreraController.text = docente['carrera'];
        tecnologicoController.text = docente['tecnologico'];
        materiasImpartidasController.text =
            json.encode(docente['materiasImpartidas']);
      });
    }
  }

  Future<void> createDocente() async {
    final response = await http.post(
      Uri.parse('http://$localIp:3000/tecnm/docentes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': idController.text,
        'nombre': nombreController.text,
        'carrera': carreraController.text,
        'tecnologico': tecnologicoController.text,
        'materiasImpartidas': json.decode(materiasImpartidasController.text)
      }),
    );
    if (response.statusCode == 201) {
      fetchDocentes();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Docente creado exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear el docente')));
    }
  }

  Future<void> updateDocente(String id) async {
    final response = await http.put(
      Uri.parse('http://$localIp:3000/tecnm/docentes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': nombreController.text,
        'carrera': carreraController.text,
        'tecnologico': tecnologicoController.text,
        'materiasImpartidas': json.decode(materiasImpartidasController.text)
      }),
    );
    if (response.statusCode == 200) {
      fetchDocentes();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Docente actualizado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el docente')));
    }
  }

  Future<void> deleteDocente(String id) async {
    final response =
        await http.delete(Uri.parse('http://$localIp:3000/tecnm/docentes/$id'));
    if (response.statusCode == 200) {
      fetchDocentes();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Docente eliminado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el docente')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Docentes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(labelText: 'ID Docente'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getDocenteById(idController.text);
                    },
                  )
                ],
              ),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: carreraController,
                decoration: InputDecoration(labelText: 'Carrera'),
              ),
              TextField(
                controller: tecnologicoController,
                decoration: InputDecoration(labelText: 'Tecnológico'),
              ),
              TextField(
                controller: materiasImpartidasController,
                decoration:
                    InputDecoration(labelText: 'Materias Impartidas (JSON)'),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createDocente,
                child: Text('Crear Docente'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    updateDocente(idController.text);
                  }
                },
                child: Text('Actualizar Docente'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    deleteDocente(idController.text);
                  }
                },
                child: Text('Eliminar Docente'),
              ),
              SizedBox(height: 20),
              Text('Lista de Docentes:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: docentes.length,
                itemBuilder: (context, index) {
                  final docente = docentes[index];
                  return ListTile(
                    title: Text(docente['nombre']),
                    subtitle: Text(docente['_id']),
                    onTap: () {
                      setState(() {
                        selectedDocenteId = docente['_id'];
                        idController.text = docente['_id'];
                        nombreController.text = docente['nombre'];
                        carreraController.text = docente['carrera'];
                        tecnologicoController.text = docente['tecnologico'];
                        materiasImpartidasController.text =
                            json.encode(docente['materiasImpartidas']);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
