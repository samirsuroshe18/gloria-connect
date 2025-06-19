import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';

class AddTechnicianScreen extends StatefulWidget {
  const AddTechnicianScreen({super.key});

  @override
  State<AddTechnicianScreen> createState() => _AddTechnicianScreenState();
}

class _AddTechnicianScreenState extends State<AddTechnicianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedRole;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {

      final technician = Technician(
        name: _nameController.text,
        email: _emailController.text,
        phoneNo: _phoneController.text,
        address: _addressController.text,
        role: _selectedRole!,
      );
      // Debug print before returning
      print('Creating new technician: ${technician.name} (${technician.role})');

      // Return the new technician to the previous screen
      Navigator.pop(context, technician);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Technician',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge),
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: TechnicianRole.values.map((role) {
                  return DropdownMenuItem(

                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Technician'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}