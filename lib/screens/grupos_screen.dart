import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class GruposScreen extends StatefulWidget {
  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  String localIp = Host.getHost(); // IP de la máquina host

  List<dynamic> grupos = [];
  String? selectedGrupoId;
  TextEditingController idController = TextEditingController();
  TextEditingController materiaController = TextEditingController();
  TextEditingController docenteController = TextEditingController();
  TextEditingController estudiantesController = TextEditingController();
  TextEditingController aulaController = TextEditingController();
  TextEditingController diaController = TextEditingController();
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController horaFinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGrupos();
  }

  Future<void> fetchGrupos() async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/grupos'));
    if (response.statusCode == 200) {
      setState(() {
        grupos = json.decode(response.body);
      });
    }
  }

  Future<void> getGrupoById(String id) async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/grupos/$id'));
    if (response.statusCode == 200) {
      final grupo = json.decode(response.body);
      setState(() {
        selectedGrupoId = grupo['_id'];
        idController.text = grupo['_id'];
        materiaController.text = grupo['materia'];
        docenteController.text = grupo['docente'];
        estudiantesController.text = grupo['estudiantes'].join(', ');
        aulaController.text = grupo['aula'];
        diaController.text = grupo['horario']['dia'];
        horaInicioController.text = grupo['horario']['horaInicio'];
        horaFinController.text = grupo['horario']['horaFin'];
      });
    }
  }

  Future<void> createGrupo() async {
    final response = await http.post(
      Uri.parse('http://$localIp:3000/tecnm/grupos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': idController.text,
        'materia': materiaController.text,
        'docente': docenteController.text,
        'estudiantes':
            estudiantesController.text.split(',').map((e) => e.trim()).toList(),
        'aula': aulaController.text,
        'horario': {
          'dia': diaController.text,
          'horaInicio': horaInicioController.text,
          'horaFin': horaFinController.text,
        },
      }),
    );
    if (response.statusCode == 201) {
      fetchGrupos();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Grupo creado exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear el grupo')));
    }
  }

  Future<void> updateGrupo(String id) async {
    final response = await http.put(
      Uri.parse('http://$localIp:3000/tecnm/grupos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'materia': materiaController.text,
        'docente': docenteController.text,
        'estudiantes':
            estudiantesController.text.split(',').map((e) => e.trim()).toList(),
        'aula': aulaController.text,
        'horario': {
          'dia': diaController.text,
          'horaInicio': horaInicioController.text,
          'horaFin': horaFinController.text,
        },
      }),
    );
    if (response.statusCode == 200) {
      fetchGrupos();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo actualizado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el grupo')));
    }
  }

  Future<void> deleteGrupo(String id) async {
    final response =
        await http.delete(Uri.parse('http://$localIp:3000/tecnm/grupos/$id'));
    if (response.statusCode == 200) {
      fetchGrupos();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo eliminado exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar el grupo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Grupos'),
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
                      decoration: InputDecoration(labelText: 'ID Grupo'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getGrupoById(idController.text);
                    },
                  )
                ],
              ),
              TextField(
                controller: materiaController,
                decoration: InputDecoration(labelText: 'Materia'),
              ),
              TextField(
                controller: docenteController,
                decoration: InputDecoration(labelText: 'Docente'),
              ),
              TextField(
                controller: estudiantesController,
                decoration: InputDecoration(
                    labelText: 'Estudiantes (separados por comas)'),
              ),
              TextField(
                controller: aulaController,
                decoration: InputDecoration(labelText: 'Aula'),
              ),
              TextField(
                controller: diaController,
                decoration: InputDecoration(labelText: 'Día'),
              ),
              TextField(
                controller: horaInicioController,
                decoration: InputDecoration(labelText: 'Hora de Inicio'),
              ),
              TextField(
                controller: horaFinController,
                decoration: InputDecoration(labelText: 'Hora de Fin'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createGrupo,
                child: Text('Crear Grupo'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    updateGrupo(idController.text);
                  }
                },
                child: Text('Actualizar Grupo'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    deleteGrupo(idController.text);
                  }
                },
                child: Text('Eliminar Grupo'),
              ),
              SizedBox(height: 20),
              Text('Lista de Grupos:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: grupos.length,
                itemBuilder: (context, index) {
                  final grupo = grupos[index];
                  return ListTile(
                    title: Text(grupo['_id']),
                    subtitle: Text(grupo['materia']),
                    onTap: () {
                      setState(() {
                        selectedGrupoId = grupo['_id'];
                        idController.text = grupo['_id'];
                        materiaController.text = grupo['materia'];
                        docenteController.text = grupo['docente'];
                        estudiantesController.text =
                            grupo['estudiantes'].join(', ');
                        aulaController.text = grupo['aula'];
                        diaController.text = grupo['horario']['dia'];
                        horaInicioController.text =
                            grupo['horario']['horaInicio'];
                        horaFinController.text = grupo['horario']['horaFin'];
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
