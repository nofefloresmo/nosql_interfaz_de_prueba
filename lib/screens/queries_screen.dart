import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class QueriesScreen extends StatefulWidget {
  @override
  _QueriesScreenState createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {
  String selectedQuery = 'Q1';
  String? selectedAlumnoId;
  String? selectedGrupoId;
  String? selectedMateriaId;
  String? selectedDocenteId;
  List<String> alumnos = [];
  List<String> grupos = [];
  List<String> materias = [];
  List<String> docentes = [];
  String queryResult = '';
  String localIp = Host.getHost(); // Default

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Aquí puedes hacer llamadas a tus API para obtener los datos necesarios para los Dropdowns
    final alumnosResponse =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/alumnos'));
    final gruposResponse =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/grupos'));
    final materiasResponse =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/materias'));
    final docentesResponse =
        await http.get(Uri.parse('http://$localIp:3000/tecnm/docentes'));

    if (alumnosResponse.statusCode == 200 &&
        gruposResponse.statusCode == 200 &&
        materiasResponse.statusCode == 200 &&
        docentesResponse.statusCode == 200) {
      setState(() {
        alumnos = List<String>.from(
            json.decode(alumnosResponse.body).map((alumno) => alumno['_id']));
        grupos = List<String>.from(
            json.decode(gruposResponse.body).map((grupo) => grupo['_id']));
        materias = List<String>.from(json
            .decode(materiasResponse.body)
            .map((materia) => materia['_id']));
        docentes = List<String>.from(json
            .decode(docentesResponse.body)
            .map((docente) => docente['_id']));
      });
    }
  }

  Future<void> executeQuery() async {
    Uri uri;
    switch (selectedQuery) {
      case 'Q1':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/alumnos/$selectedAlumnoId/materias');
        break;
      case 'Q2':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/grupos/$selectedGrupoId/materias/$selectedMateriaId/alumnos');
        break;
      case 'Q3':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/alumnos/$selectedAlumnoId/calificaciones');
        break;
      case 'Q4':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/materias/$selectedMateriaId/docentes');
        break;
      case 'Q5':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/materias/$selectedMateriaId/alumnos/calificaciones');
        break;
      case 'Q6':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/materias/$selectedMateriaId/grupos');
        break;
      case 'Q7':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/alumnos/$selectedAlumnoId/horario');
        break;
      case 'Q8':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/alumnos/$selectedAlumnoId/materias/faltantes');
        break;
      case 'Q9':
        uri = Uri.parse(
            'http://$localIp:3000/tecnm/docentes/$selectedDocenteId/materias');
        break;
      // Agrega más casos según tus queries
      default:
        return;
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        queryResult = response.body;
      });
    } else {
      setState(() {
        queryResult = 'Error en la consulta: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: selectedQuery,
                onChanged: (value) {
                  setState(() {
                    selectedQuery = value!;
                    selectedAlumnoId = null;
                    selectedGrupoId = null;
                    selectedMateriaId = null;
                    selectedDocenteId = null;
                    queryResult = '';
                  });
                },
                items: [
                  DropdownMenuItem(
                      value: 'Q1',
                      child: Text(
                          'Q1: Listar materias que un alumno ha cursado',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q2',
                      child: Text(
                          'Q2: Listar alumnos en un grupo y materia específicos',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q3',
                      child: Text(
                          'Q3: Listar calificaciones de un alumno en todas sus materias cursadas',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q4',
                      child: Text(
                          'Q4: Listar docentes que imparten una materia específica',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q5',
                      child: Text(
                          'Q5: Listar alumnos con calificaciones superiores a 90 en una materia específica',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q6',
                      child: Text(
                          'Q6: Listar grupos que corresponden a una materia específica',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q7',
                      child: Text(
                          'Q7: Listar las materias que cursa un alumno en específico (horario)',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q8',
                      child: Text(
                          'Q8: Listar las materias que faltan por cursar a un alumno en específico',
                          overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(
                      value: 'Q9',
                      child: Text(
                          'Q9: Listar las materias que imparte un docente en específico, junto con los alumnos que cursan cada una de las materias',
                          overflow: TextOverflow.ellipsis)),
                  // Agrega más DropdownMenuItem según tus queries
                ],
              ),
              if (selectedQuery == 'Q1' ||
                  selectedQuery == 'Q3' ||
                  selectedQuery == 'Q7' ||
                  selectedQuery == 'Q8')
                DropdownButton<String>(
                  hint: Text('Selecciona un Alumno ID'),
                  value: selectedAlumnoId,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedAlumnoId = value;
                    });
                  },
                  items: alumnos.map((alumno) {
                    return DropdownMenuItem(
                      value: alumno,
                      child: Text(alumno),
                    );
                  }).toList(),
                ),
              if (selectedQuery == 'Q2')
                Column(
                  children: [
                    DropdownButton<String>(
                      hint: Text('Selecciona un Grupo ID'),
                      value: selectedGrupoId,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedGrupoId = value;
                        });
                      },
                      items: grupos.map((grupo) {
                        return DropdownMenuItem(
                          value: grupo,
                          child: Text(grupo),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      hint: Text('Selecciona una Materia ID'),
                      value: selectedMateriaId,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedMateriaId = value;
                        });
                      },
                      items: materias.map((materia) {
                        return DropdownMenuItem(
                          value: materia,
                          child: Text(materia),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              if (selectedQuery == 'Q4' ||
                  selectedQuery == 'Q5' ||
                  selectedQuery == 'Q6')
                DropdownButton<String>(
                  hint: Text('Selecciona una Materia ID'),
                  value: selectedMateriaId,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedMateriaId = value;
                    });
                  },
                  items: materias.map((materia) {
                    return DropdownMenuItem(
                      value: materia,
                      child: Text(materia),
                    );
                  }).toList(),
                ),
              if (selectedQuery == 'Q9')
                DropdownButton<String>(
                  hint: Text('Selecciona un Docente ID'),
                  value: selectedDocenteId,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedDocenteId = value;
                    });
                  },
                  items: docentes.map((docente) {
                    return DropdownMenuItem(
                      value: docente,
                      child: Text(docente),
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: executeQuery,
                child: Text('Ejecutar consulta'),
              ),
              SizedBox(height: 20),
              Text(queryResult),
            ],
          ),
        ),
      ),
    );
  }
}
