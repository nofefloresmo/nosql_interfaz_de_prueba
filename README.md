# *IMPORTANTE*
## /lib/env/host.dart
>Modificar ip del host a la ip de la maquina donde corre el servidor.
```js
class Host {
  static String getHost() {
    return '10.11.8.125';
  }
}
```
## Estructura del Proyecto

```plaintext
/lib
  /env
    host.dart
  /screens
    alumnos_screen.dart
    aulas_screen.dart
    docentes_screen.dart
    grupos_screen.dart
    home_screen.dart
    import_data_screen.dart
    materias_screen.dart
    planes_de_estudio_screen.dart
    queries_screen.dart
  /widgets
    drawer_menu.dart
  main.dart
```

### /lib/env/host.dart
Este archivo contiene la configuración del host para la API. Define la IP local que se utilizará para las peticiones HTTP.
```dart
class Host {
  static String getHost() {
    return '10.11.8.125';
  }
}
```

### /lib/screens/home_screen.dart
La pantalla de inicio de la aplicación. Incluye un Drawer para la navegación a otras pantallas.
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TecNM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
```

### /lib/widgets/drawer_menu.dart
El Drawer para la navegación entre las diferentes pantallas de la aplicación.
```dart
import 'package:flutter/material.dart';
import '../screens/import_data_screen.dart';
import '../screens/queries_screen.dart';
import '../screens/alumnos_screen.dart';
import '../screens/materias_screen.dart';
import '../screens/docentes_screen.dart';
import '../screens/grupos_screen.dart';
import '../screens/aulas_screen.dart';
import '../screens/planes_de_estudio_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('TecNM API'),
          ),
          ListTile(
            title: const Text('Importar todos los datos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImportDataScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Querys'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueriesScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Alumnos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlumnosScreen()),
              );
            },
          ),
          // Tiles de las entidades restantes...
        ],
      ),
    );
  }
}
```
### /lib/screens/import_data_screen.dart
Pantalla para importar datos de prueba en la base de datos. Realiza una petición HTTP POST.
```dart
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
```

### /lib/screens/queries_screen.dart
Pantalla para ejecutar consultas GET en la base de datos. Permite seleccionar una consulta y los parámetros necesarios.
```dart
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
```

### /lib/screens/alumnos_screen.dart
Pantalla para gestionar la entidad "Alumnos". Permite realizar operaciones CRUD.
```dart
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
```

### /lib/screens/docentes_screen.dart
Pantalla para gestionar la entidad "Docentes". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class DocentesScreen extends StatefulWidget {
  @override
  _DocentesScreenState createState() => _DocentesScreenState();
}

class _DocentesScreenState extends State<DocentesScreen> {
  // Variables y métodos para manejar CRUD de Docentes
}
```

### /lib/screens/materias_screen.dart
Pantalla para gestionar la entidad "Materias". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class MateriasScreen extends StatefulWidget {
  @override
  _MateriasScreenState createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  // Variables y métodos para manejar CRUD de Materias
}
```

### /lib/screens/grupos_screen.dart
Pantalla para gestionar la entidad "Grupos". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class GruposScreen extends StatefulWidget {
  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  // Variables y métodos para manejar CRUD de Grupos
}
```

### /lib/screens/aulas_screen.dart
Pantalla para gestionar la entidad "Aulas". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class AulasScreen extends StatefulWidget {
  @override
  _AulasScreenState createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  // Variables y métodos para manejar CRUD de Aulas
}
```

### /lib/screens/planes_de_estudio_screen.dart
Pantalla para gestionar la entidad "Planes de Estudio". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class PlanesDeEstudioScreen extends StatefulWidget {
  @override
  _PlanesDeEstudioScreenState createState() => _PlanesDeEstudioScreenState();
}

class _PlanesDeEstudioScreenState extends State<PlanesDeEstudioScreen> {
  // Variables y métodos para manejar CRUD de Planes de Estudio
}
```

### main.dart
Punto de entrada de la aplicación. Configura el MaterialApp y establece la pantalla de inicio.
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TecNM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
```