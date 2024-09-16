import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

// ...
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
 
}





class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD de Carros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarListPage(),
    );
  }
}

class Car {
  String id;
  String name;
  String model;

  Car({required this.id, required this.name, required this.model});
}

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<Car> cars = []; 
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _model = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Carros'),
      ),
      body: Column(
        children: [
          _buildForm(), 
          Expanded(child: _buildCarList()), 
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre del Carro'),
              onSaved: (value) {
                _name = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Modelo'),
              onSaved: (value) {
                _model = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el modelo';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCar,
              child: Text('Agregar Carro'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCarList() {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(cars[index].name),
          subtitle: Text('Modelo: ${cars[index].model}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editCar(index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteCar(index),
              ),
            ],
          ),
        );
      },
    );
  }


  void _addCar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        cars.add(Car(id: DateTime.now().toString(), name: _name, model: _model));
      });
      _formKey.currentState!.reset();
    }
  }

  void _editCar(int index) {
    Car car = cars[index];
    TextEditingController nameController = TextEditingController(text: car.name);
    TextEditingController modelController = TextEditingController(text: car.model);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Carro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre del Carro'),
              ),
              TextField(
                controller: modelController,
                decoration: InputDecoration(labelText: 'Modelo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cars[index].name = nameController.text;
                  cars[index].model = modelController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
 
  void _deleteCar(int index) {
    setState(() {
      cars.removeAt(index);
    });
  }
}
