import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserForm(),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  String? _gender;
  bool _isMarried = false;

  // Form field variables
  String? _cedula;
  String? _nombres;
  String? _apellidos;
  DateTime? _birthDate;
  int? _age;

  // Date Picker for Fecha de Nacimiento
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
        _age = DateTime.now().year - picked.year;
      });
    }
  }

  // Validation for Cedula
  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su cedula';
    }
    if (value.length < 10) {
      return 'La cedula debe tener al menos 10 dígitos';
    }
    return null;
  }


  String? _validateText(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
        backgroundColor: const Color.fromARGB(255, 145, 104, 181),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Cédula
              TextFormField(
                decoration: InputDecoration(labelText: 'Cedula'),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: _validateCedula,
                onSaved: (value) => _cedula = value,
              ),
              // Nombres
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombres'),
                validator: (value) => _validateText(value, 'nombres'),
                onSaved: (value) => _nombres = value,
              ),
              // Apellidos
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellidos'),
                validator: (value) => _validateText(value, 'apellidos'),
                onSaved: (value) => _apellidos = value,
              ),
              // Fecha de Nacimiento
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleccione su fecha de nacimiento';
                  }
                  return null;
                },
              ),
              // Edad
              TextFormField(
                decoration: InputDecoration(labelText: 'Edad'),
                readOnly: true,
                controller: TextEditingController(
                  text: _age != null ? '$_age años' : '',
                ),
              ),
              // Genero
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Genero'),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Masculino'),
                      value: 'Masculino',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Femenino'),
                      value: 'Femenino',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              // Estado Civil
              CheckboxListTile(
                title: Text('¿Esta casado?'),
                value: _isMarried,
                onChanged: (value) {
                  setState(() {
                    _isMarried = value!;
                  });
                },
              ),
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Formulario valido')),
                        );
                      }
                    },
                    child: Text('Siguiente'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Salir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
