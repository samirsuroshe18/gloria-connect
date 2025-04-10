import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../bloc/check_in_bloc.dart';

class ApartmentSelectionScreen extends StatefulWidget {
  final String? entryType;
  final String? blockName;
  final String? categoryOption;
  final Map<String, dynamic>? formData;
  const ApartmentSelectionScreen({super.key, this.blockName, this.entryType, this.formData, this.categoryOption});

  @override
  State<ApartmentSelectionScreen> createState() => _ApartmentSelectionScreenState();
}

class _ApartmentSelectionScreenState extends State<ApartmentSelectionScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> allFlats = [];
  List<String> filteredFlats = [];
  List<String> selectedFlats = [];
  String? blockName;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    blockName = widget.blockName;
    context.read<CheckInBloc>().add(CheckInGetApartment(blockName: blockName!));
    filteredFlats = allFlats;
    searchController.addListener(filterFlats);
    context.read<CheckInBloc>().add(AddFlat());
  }

  void filterFlats() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredFlats =
          allFlats.where((flat) => flat.toLowerCase().contains(query)).toList();
    });
  }

  void toggleFlatSelection(String flat) {
    if (selectedFlats.contains(flat)) {
      context.read<CheckInBloc>().add(RemoveFlat(flatName: flat));
    } else {
      context.read<CheckInBloc>().add(AddFlat(flatName: flat));
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2), // Change AppBar color here
        title: const Text(
          'Select apartment',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight
                  .bold), // Text color adjusted to white for visibility
        ),
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is FlatState) {
            selectedFlats = state.selectedFlats;
          }
          if (state is CheckInGetApartmentLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is CheckInGetApartmentSuccess) {
            allFlats = state.response;
            filteredFlats = allFlats;
            _isLoading = false;
            _isError = false;
          }
          if (state is CheckInGetApartmentFailure) {
            allFlats = [];
            _isLoading = false;
            _isError = true;
          }
        },
        builder: (context, state) {
          if (allFlats.isNotEmpty && _isLoading == false) {
            return Column(
              children: [
                // Search Bar and Block Info
                Container(
                  color: Colors.black.withOpacity(0.2),
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true, // Enables the fill color
                      fillColor: Colors.white.withOpacity(0.2),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Search apartment',
                      hintStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Block : $blockName',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white60),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to previous page (block selection)
                          Navigator.of(context).pop();
                        },
                        child: const Text("Select Another Block", style: TextStyle(color: Colors.white60),),
                      )
                    ],
                  ),
                ),
                if (selectedFlats.isNotEmpty)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedFlats.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            backgroundColor: Colors.black.withOpacity(0.2),
                            label: Text(selectedFlats[index], style: const TextStyle(color: Colors.white70),),
                            onDeleted: () {
                              // context.read().add(RemoveFlat(blockName: blockName!, flatName: selectedFlats[index]));
                              toggleFlatSelection(selectedFlats[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                // Apartment Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: GridView.builder(
                        itemCount: filteredFlats.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 2.5,
                        ),
                        itemBuilder: (context, index) {
                          final flat = filteredFlats[index];
                          final selected = '$blockName ${filteredFlats[index]}';
                          final isSelected = selectedFlats.contains(selected);
                          return Card(
                            color: Colors.black.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                toggleFlatSelection(selected);
                              },
                              borderRadius: BorderRadius.circular(15.0),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.home,
                                        color: Colors.white70),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        flat,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500, color: Colors.white70),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        toggleFlatSelection(selected);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Next Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _onContinuePress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(widget.formData?['isAddService'] == true ? "Submit" : 'Continue',
                        style: const TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            );
          } else if (_isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animations/loader.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            );
          } else if (allFlats.isEmpty && _isError == true) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/error.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Something went wrong!",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/no_data.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "There are no apartments",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<CheckInBloc>().add(CheckInGetApartment(blockName: blockName!));
  }

  void _onContinuePress() {
    if (widget.formData?['isAddService'] == true) {

// Navigate to the desired screen after clearing above routes
//       Navigator.pushReplacementNamed(
//         context,
//         '/add-service-screen',
//         arguments: widget.formData,
//       );

    // Navigator.pop(context, widget.formData);
    //   Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     '/add-service-screen', // The target screen to push
    //         (route) {
    //       // Keep pages with specific route names
    //       return route.settings.name == '/guard-home';
    //     },
    //     arguments: widget.formData,
    //   );

      Navigator.popUntil(context, (route) => route.settings.name == '/guard-home');
// Re-add the necessary screens
      Navigator.pushNamed(context, '/add-service-screen', arguments: widget.formData);



    }else if (selectedFlats.isNotEmpty) {
      Navigator.pushNamed(context, '/mobile-no-screen',
          arguments: {'entryType': widget.entryType, 'categoryOption': widget.categoryOption});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select apartment'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
