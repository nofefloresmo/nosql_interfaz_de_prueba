import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class MateriasScreen extends StatefulWidget {
  @override
  _MateriasScreenState createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  String localIp = Host.getHost(); // IP de la máquina host

  List<dynamic> materias = [];
  String? selectedMateriaId;
  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController plandeestudiosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMaterias();
  }

  Future<void> fetchMaterias() async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/materias'));
    if (response.statusCode == 200) {
      setState(() {
        materias = json.decode(response.body);
      });
    }
  }

  Future<void> getMateriaById(String id) async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/materias/$id'));
    if (response.statusCode == 200) {
      final materia = json.decode(response.body);
      setState(() {
        selectedMateriaId = materia['_id'];
        idController.text = materia['_id'];
        nombreController.text = materia['nombre'];
        carreraController.text = materia['carrera'];
        descripcionController.text = materia['descripcion'];
        plandeestudiosController.text = materia['plandeestudios'];
      });
    }
  }

  Future<void> createMateria() async {
    final response = await http.post(
      Uri.parse('http://$localIp:3000/tecnm/materias'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': idController.text,
        'nombre': nombreController.text,
        'carrera': carreraController.text,
        'descripcion': descripcionController.text,
        'plandeestudios': plandeestudiosController.text,
      }),
    );
    if (response.statusCode == 201) {
      fetchMaterias();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Materia creada exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear la materia')));
    }
  }

  Future<void> updateMateria(String id) async {
    final response = await http.put(
      Uri.parse('http://$localIp:3000/tecnm/materias/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': nombreController.text,
        'carrera': carreraController.text,
        'descripcion': descripcionController.text,
        'plandeestudios': plandeestudiosController.text,
      }),
    );
    if (response.statusCode == 200) {
      fetchMaterias();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Materia actualizada exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la materia')));
    }
  }

  Future<void> deleteMateria(String id) async {
    final response =
        await http.delete(Uri.parse('http://$localIp:3000/tecnm/materias/$id'));
    if (response.statusCode == 200) {
      fetchMaterias();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Materia eliminada exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la materia')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Materias'),
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
                      decoration: InputDecoration(labelText: 'ID Materia'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getMateriaById(idController.text);
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
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              TextField(
                controller: plandeestudiosController,
                decoration: InputDecoration(labelText: 'Plan de estudios'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createMateria,
                child: Text('Crear Materia'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    updateMateria(idController.text);
                  }
                },
                child: Text('Actualizar Materia'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    deleteMateria(idController.text);
                  }
                },
                child: Text('Eliminar Materia'),
              ),
              SizedBox(height: 20),
              Text('Lista de Materias:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: materias.length,
                itemBuilder: (context, index) {
                  final materia = materias[index];
                  return ListTile(
                    title: Text(materia['nombre']),
                    subtitle: Text(materia['_id']),
                    onTap: () {
                      setState(() {
                        selectedMateriaId = materia['_id'];
                        idController.text = materia['_id'];
                        nombreController.text = materia['nombre'];
                        carreraController.text = materia['carrera'];
                        descripcionController.text = materia['descripcion'];
                        plandeestudiosController.text =
                            materia['plandeestudios'];
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
