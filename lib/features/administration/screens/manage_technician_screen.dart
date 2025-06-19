import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';

class ManageTechnicianScreen extends StatefulWidget {
  const ManageTechnicianScreen({super.key});
  @override
  State<ManageTechnicianScreen> createState() => _ManageTechnicianScreenState();
}

class _ManageTechnicianScreenState extends State<ManageTechnicianScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Technician> _technicians = []; // Changed to final to ensure we modify the same list
  List<Technician> _filteredTechnicians = [];

  @override
  void initState() {
    super.initState();
    // Initialize with empty list, will be populated when technicians are added
    _filteredTechnicians = List.from(_technicians); // Create a new list from _technicians
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTechnicians(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTechnicians = List.from(_technicians);
      } else {
        _filteredTechnicians = _technicians
            .where((technician) =>
            technician.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  void _addTechnician() async {
    final result = await Navigator.pushNamed(context, '/add-technician-screen');
    if (result != null && result is Technician) {
      setState(() {

        _technicians.add(result);
        _filteredTechnicians = List.from(_technicians);

      });

    }
  }
  void _showDeleteConfirmation(BuildContext context, Technician technician) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(255, 235, 235, 1),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete Technician Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: 'Are you sure you want to delete ',
                    children: [
                      TextSpan(
                        text: '${technician.name}\'s',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: ' account? This action cannot be undone.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement delete functionality
                          setState(() {
                            _technicians.remove(technician);
                            _filteredTechnicians = List.from(_technicians);
                          });
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Technicians',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTechnician,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search technicians...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _filterTechnicians,
            ),
          ),
          Expanded(
            child: _buildTechniciansList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniciansList() {

    if (_filteredTechnicians.isEmpty) {
      return const Center(
        child: Text(
          'No technicians found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredTechnicians.length,
      itemBuilder: (context, index) {
        final technician = _filteredTechnicians[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF23243B),
                  Color(0xFF3B1F24),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.withValues(alpha: 0.2),
                        child: const Icon(Icons.person, size: 32, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  technician.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Active',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              technician.role,
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.call, size: 16, color: Colors.green),
                                  ),
                                  const WidgetSpan(child: SizedBox(width: 4)),
                                  TextSpan(
                                    text: technician.phoneNo,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 16, color: Colors.blueGrey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    technician.email,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: Colors.deepOrange),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    technician.address,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showDeleteConfirmation(context, technician),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          label: const Text('Delete Account'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement share credentials
                          },
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Share Creds'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}