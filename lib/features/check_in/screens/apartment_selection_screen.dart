import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/features/administration/widgets/search_bar.dart';
import 'package:gloria_connect/features/check_in/widgets/apartment_card.dart';
import 'package:gloria_connect/features/check_in/widgets/check_in_search_bar.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
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
      filteredFlats = allFlats.where((flat) => flat.toLowerCase().contains(query)).toList();
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
              fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CheckInSearchBar(searchController: searchController, hintText: 'Search Apartment',),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Block : $blockName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 2.5,
                        ),
                        itemBuilder: (context, index) {
                          final flat = filteredFlats[index];
                          final selected = '$blockName ${filteredFlats[index]}';
                          final isSelected = selectedFlats.contains(selected);
                          return ApartmentCard(toggleFlatSelection: toggleFlatSelection, selected: selected, flat: flat, isSelected: isSelected);
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
                          borderRadius: BorderRadius.circular(22.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      widget.formData?['isAddService'] == true
                      ? "Submit"
                      : 'Continue',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else if (allFlats.isEmpty && _isError == true) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no apartments',);
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
      Navigator.popUntil(context, (route) => route.settings.name == '/guard-home');
      Navigator.pushNamed(context, '/add-service-screen', arguments: widget.formData);
    }else if (selectedFlats.isNotEmpty) {
      Navigator.pushNamed(context, '/mobile-no-screen', arguments: {'entryType': widget.entryType, 'categoryOption': widget.categoryOption});
    } else {
      CustomSnackBar.show(context: context, message: 'Please select apartment', type: SnackBarType.error);
    }
  }
}
