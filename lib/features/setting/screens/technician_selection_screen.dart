import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';

class TechnicianSelectionScreen extends StatefulWidget {
  TechnicianSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TechnicianSelectionScreen> createState() => _TechnicianSelectionScreenState();
}

class _TechnicianSelectionScreenState extends State<TechnicianSelectionScreen> {
  final List<Technician> mockTechnicians = [
    Technician(
      id: '1',
      userName: 'Alex Johnson',
      profile: '',
      email: 'alex.johnson@example.com',
      phoneNo: '9876543210',
      role: 'Electrician',
      technicianPassword: '',
    ),
    Technician(
      id: '2',
      userName: 'Priya Singh',
      profile: '',
      email: 'priya.singh@example.com',
      phoneNo: '9123456780',
      role: 'Plumber',
      technicianPassword: '',
    ),
    Technician(
      id: '3',
      userName: 'Rahul Mehra',
      profile: '',
      email: 'rahul.mehra@example.com',
      phoneNo: '9988776655',
      role: 'Carpenter',
      technicianPassword: '',
    ),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mockTechnicians.where((t) {
      final q = searchQuery.toLowerCase();
      return t.userName?.toLowerCase().contains(q) == true || t.phoneNo?.contains(q) == true;
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF032F7C), // Deep blue
            Color(0xFF640018), // Deep maroon
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Technicians'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => searchQuery = v),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white60),
                  hintText: 'Search by name or mobile number',
                  hintStyle: const TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tech = filtered[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context, tech),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          _buildAvatar(tech),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tech.userName ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tech.role ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Technician tech) {
    if (tech.profile != null && tech.profile!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(tech.profile!),
        radius: 22,
      );
    } else {
      final initial = (tech.userName != null && tech.userName!.isNotEmpty)
          ? tech.userName!.trim()[0].toUpperCase()
          : '';
      return CircleAvatar(
        backgroundColor: Colors.white24,
        radius: 22,
        child: Text(
          initial,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    }
  }
}