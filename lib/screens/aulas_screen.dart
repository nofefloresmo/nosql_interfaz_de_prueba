import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class AulasScreen extends StatefulWidget {
  @override
  _AulasScreenState createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  String localIp = Host.getHost(); // IP de la máquina host

  List<dynamic> aulas = [];
  String? selectedAulaId;
  TextEditingController idController = TextEditingController();
  TextEditingController edificioController = TextEditingController();
  TextEditingController gruposAtendidosController = TextEditingController();
  TextEditingController descripcionEquipamientoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAulas();
  }

  Future<void> fetchAulas() async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/aulas'));
    if (response.statusCode == 200) {
      setState(() {
        aulas = json.decode(response.body);
      });
    }
  }

  Future<void> getAulaById(String id) async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/aulas/$id'));
    if (response.statusCode == 200) {
      final aula = json.decode(response.body);
      setState(() {
        selectedAulaId = aula['_id'];
        idController.text = aula['_id'];
        edificioController.text = aula['edificio'];
        gruposAtendidosController.text = aula['gruposAtendidos'].join(', ');
        descripcionEquipamientoController.text =
            aula['descripcionEquipamiento'];
      });
    }
  }

  Future<void> createAula() async {
    final response = await http.post(
      Uri.parse('http://$localIp:3000/tecnm/aulas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': idController.text,
        'edificio': edificioController.text,
        'gruposAtendidos': gruposAtendidosController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'descripcionEquipamiento': descripcionEquipamientoController.text,
      }),
    );
    if (response.statusCode == 201) {
      fetchAulas();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Aula creada exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear el aula')));
    }
  }

  Future<void> updateAula(String id) async {
    final response = await http.put(
      Uri.parse('http://$localIp:3000/tecnm/aulas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'edificio': edificioController.text,
        'gruposAtendidos': gruposAtendidosController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'descripcionEquipamiento': descripcionEquipamientoController.text,
      }),
    );
    if (response.statusCode == 200) {
      fetchAulas();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aula actualizada exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al actualizar el aula')));
    }
  }

  Future<void> deleteAula(String id) async {
    final response =
        await http.delete(Uri.parse('http://$localIp:3000/tecnm/aulas/$id'));
    if (response.statusCode == 200) {
      fetchAulas();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Aula eliminada exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar el aula')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Aulas'),
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
                      decoration: InputDecoration(labelText: 'ID Aula'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getAulaById(idController.text);
                    },
                  )
                ],
              ),
              TextField(
                controller: edificioController,
                decoration: InputDecoration(labelText: 'Edificio'),
              ),
              TextField(
                controller: gruposAtendidosController,
                decoration: InputDecoration(
                    labelText: 'Grupos Atendidos (separados por comas)'),
              ),
              TextField(
                controller: descripcionEquipamientoController,
                decoration:
                    InputDecoration(labelText: 'Descripción Equipamiento'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createAula,
                child: Text('Crear Aula'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    updateAula(idController.text);
                  }
                },
                child: Text('Actualizar Aula'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    deleteAula(idController.text);
                  }
                },
                child: Text('Eliminar Aula'),
              ),
              SizedBox(height: 20),
              Text('Lista de Aulas:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: aulas.length,
                itemBuilder: (context, index) {
                  final aula = aulas[index];
                  return ListTile(
                    title: Text(aula['_id']),
                    subtitle: Text(aula['edificio']),
                    onTap: () {
                      setState(() {
                        selectedAulaId = aula['_id'];
                        idController.text = aula['_id'];
                        edificioController.text = aula['edificio'];
                        gruposAtendidosController.text =
                            aula['gruposAtendidos'].join(', ');
                        descripcionEquipamientoController.text =
                            aula['descripcionEquipamiento'];
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
