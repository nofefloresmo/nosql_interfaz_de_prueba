import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class AlumnosScreen extends StatefulWidget {
  @override
  _AlumnosScreenState createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  String localIp = Host.getHost(); // IP de la máquina host

  List<dynamic> alumnos = [];
  String? selectedAlumnoId;
  TextEditingController idController = TextEditingController();
  TextEditingController nctrlController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController tecnologicoController = TextEditingController();
  TextEditingController plandeestudiosController = TextEditingController();
  TextEditingController expedienteAcademicoController = TextEditingController();
  TextEditingController horarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAlumnos();
  }

  Future<void> fetchAlumnos() async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/alumnos'));
    if (response.statusCode == 200) {
      setState(() {
        alumnos = json.decode(response.body);
      });
    }
  }

  Future<void> getAlumnoById(String id) async {
    final response =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/alumnos/$id'));
    if (response.statusCode == 200) {
      final alumno = json.decode(response.body);
      setState(() {
        selectedAlumnoId = alumno['_id'];
        idController.text = alumno['_id'];
        nctrlController.text = alumno['nctrl'];
        nombreController.text = alumno['nombre'];
        carreraController.text = alumno['carrera'];
        tecnologicoController.text = alumno['tecnologico'];
        plandeestudiosController.text = alumno['plandeestudios'];
        expedienteAcademicoController.text =
            json.encode(alumno['expedienteAcademico']);
        horarioController.text = alumno['horario'].join(', ');
      });
    }
  }

  Future<void> createAlumno() async {
    final response = await http.post(
      Uri.parse('http://$localIp:3000/tecnm/alumnos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': idController.text,
        'nctrl': nctrlController.text,
        'nombre': nombreController.text,
        'carrera': carreraController.text,
        'tecnologico': tecnologicoController.text,
        'plandeestudios': plandeestudiosController.text,
        'expedienteAcademico': json.decode(expedienteAcademicoController.text),
        'horario':
            horarioController.text.split(',').map((e) => e.trim()).toList(),
      }),
    );
    if (response.statusCode == 201) {
      fetchAlumnos();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Alumno creado exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear el alumno')));
    }
  }

  Future<void> updateAlumno(String id) async {
    final response = await http.put(
      Uri.parse('http://$localIp:3000/tecnm/alumnos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nctrl': nctrlController.text,
        'nombre': nombreController.text,
        'carrera': carreraController.text,
        'tecnologico': tecnologicoController.text,
        'plandeestudios': plandeestudiosController.text,
        'expedienteAcademico': json.decode(expedienteAcademicoController.text),
        'horario':
            horarioController.text.split(',').map((e) => e.trim()).toList(),
      }),
    );
    if (response.statusCode == 200) {
      fetchAlumnos();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alumno actualizado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el alumno')));
    }
  }

  Future<void> deleteAlumno(String id) async {
    final response =
        await http.delete(Uri.parse('http://$localIp:3000/tecnm/alumnos/$id'));
    if (response.statusCode == 200) {
      fetchAlumnos();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alumno eliminado exitosamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar el alumno')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Alumnos'),
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
                      decoration: InputDecoration(labelText: 'ID Alumno'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getAlumnoById(idController.text);
                    },
                  )
                ],
              ),
              TextField(
                controller: nctrlController,
                decoration: InputDecoration(labelText: 'Número de Control'),
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
                controller: plandeestudiosController,
                decoration: InputDecoration(labelText: 'Plan de Estudios'),
              ),
              TextField(
                controller: expedienteAcademicoController,
                decoration:
                    InputDecoration(labelText: 'Expediente Académico (JSON)'),
                maxLines: 5,
              ),
              TextField(
                controller: horarioController,
                decoration:
                    InputDecoration(labelText: 'Horario (separado por comas)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createAlumno,
                child: Text('Crear Alumno'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    updateAlumno(idController.text);
                  }
                },
                child: Text('Actualizar Alumno'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (idController.text.isNotEmpty) {
                    deleteAlumno(idController.text);
                  }
                },
                child: Text('Eliminar Alumno'),
              ),
              SizedBox(height: 20),
              Text('Lista de Alumnos:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: alumnos.length,
                itemBuilder: (context, index) {
                  final alumno = alumnos[index];
                  return ListTile(
                    title: Text(alumno['_id']),
                    subtitle: Text(alumno['nombre']),
                    onTap: () {
                      setState(() {
                        selectedAlumnoId = alumno['_id'];
                        idController.text = alumno['_id'];
                        nctrlController.text = alumno['nctrl'];
                        nombreController.text = alumno['nombre'];
                        carreraController.text = alumno['carrera'];
                        tecnologicoController.text = alumno['tecnologico'];
                        plandeestudiosController.text =
                            alumno['plandeestudios'];
                        expedienteAcademicoController.text =
                            json.encode(alumno['expedienteAcademico']);
                        horarioController.text = alumno['horario'].join(', ');
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
