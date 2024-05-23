import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../env/host.dart';

class PlanesDeEstudioScreen extends StatefulWidget {
  @override
  _PlanesDeEstudioScreenState createState() => _PlanesDeEstudioScreenState();
}

class _PlanesDeEstudioScreenState extends State<PlanesDeEstudioScreen> {
  String localIp = Host.getHost(); // IP de la máquina host

  List<dynamic> planesDeEstudio = [];
  String? selectedPlanId;
  TextEditingController idController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController materiasController = TextEditingController();
  TextEditingController totalCreditosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlanesDeEstudio();
  }

  Future<void> fetchPlanesDeEstudio() async {
    final response = await http
        .get(Uri.parse('http://$localIp:3000/tecnm/planes-de-estudios'));
    if (response.statusCode == 200) {
      setState(() {
        planesDeEstudio = json.decode(response.body);
      });
    }
  }

  Future<void> getPlanDeEstudioById(String id) async {
    final response = await http
        .get(Uri.parse('http://$localIp:3000/tecnm/planes-de-estudios/$id'));
    if (response.statusCode == 200) {
      final plan = json.decode(response.body);
      setState(() {
        selectedPlanId = plan['_id'];
        idController.text = plan['_id'];
        carreraController.text = plan['carrera'];
        materiasController.text = plan['materias'].join(', ');
        totalCreditosController.text = plan['totalCreditos'].toString();
      });
    }
  }

  Future<void> createPlanDeEstudio() async {
    final response = await http.post(
      Uri.parse('http://$localIp:3000/tecnm/planes-de-estudios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': idController.text,
        'carrera': carreraController.text,
        'materias':
            materiasController.text.split(',').map((e) => e.trim()).toList(),
        'totalCreditos': int.parse(totalCreditosController.text),
      }),
    );
    if (response.statusCode == 201) {
      fetchPlanesDeEstudio();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plan de estudio creado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el plan de estudio')));
    }
  }

  Future<void> updatePlanDeEstudio(String id) async {
    final response = await http.put(
      Uri.parse('http://$localIp:3000/tecnm/planes-de-estudios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'carrera': carreraController.text,
        'materias':
            materiasController.text.split(',').map((e) => e.trim()).toList(),
        'totalCreditos': int.parse(totalCreditosController.text),
      }),
    );
    if (response.statusCode == 200) {
      fetchPlanesDeEstudio();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plan de estudio actualizado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el plan de estudio')));
    }
  }

  Future<void> deletePlanDeEstudio(String id) async {
    final response = await http
        .delete(Uri.parse('http://$localIp:3000/tecnm/planes-de-estudios/$id'));
    if (response.statusCode == 200) {
      fetchPlanesDeEstudio();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plan de estudio eliminado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el plan de estudio')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Planes de Estudio'),
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
                      decoration:
                          InputDecoration(labelText: 'ID Plan de Estudio'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getPlanDeEstudioById(idController.text);
                    },
                  )
                ],
              ),
              TextField(
                controller: carreraController,
                decoration: InputDecoration(labelText: 'Carrera'),
              ),
              TextField(
                controller: materiasController,
                decoration: InputDecoration(
                    labelText: 'Materias (separadas por comas)'),
              ),
              TextField(
                controller: totalCreditosController,
                decoration: InputDecoration(labelText: 'Total Créditos'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createPlanDeEstudio,
                child: Text('Crear Plan de Estudio'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedPlanId != null) {
                    updatePlanDeEstudio(selectedPlanId!);
                  }
                },
                child: Text('Actualizar Plan de Estudio'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedPlanId != null) {
                    deletePlanDeEstudio(selectedPlanId!);
                  }
                },
                child: Text('Eliminar Plan de Estudio'),
              ),
              SizedBox(height: 20),
              Text('Lista de Planes de Estudio:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: planesDeEstudio.length,
                itemBuilder: (context, index) {
                  final plan = planesDeEstudio[index];
                  return ListTile(
                    title: Text(plan['_id']),
                    subtitle: Text(plan['carrera']),
                    onTap: () {
                      setState(() {
                        selectedPlanId = plan['_id'];
                        idController.text = plan['_id'];
                        carreraController.text = plan['carrera'];
                        materiasController.text = plan['materias'].join(', ');
                        totalCreditosController.text =
                            plan['totalCreditos'].toString();
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
