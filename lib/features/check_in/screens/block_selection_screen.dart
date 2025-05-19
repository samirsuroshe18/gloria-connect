import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/check_in/widgets/block_card.dart';
import 'package:gloria_connect/features/check_in/widgets/check_in_search_bar.dart';

class BlockSelectionScreen extends StatefulWidget {
  final String? entryType;
  final String? categoryOption;
  final Map<String, dynamic>? formData;
  const BlockSelectionScreen({super.key, this.entryType, this.formData, this.categoryOption});

  @override
  State<BlockSelectionScreen> createState() => _BlockSelectionScreenState();
}

class _BlockSelectionScreenState extends State<BlockSelectionScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> data = [];
  List<String> filteredBlocks = [];
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    context.read<CheckInBloc>().add(CheckInGetBlock());
    filteredBlocks = data;
    searchController.addListener(() {
      filterBlocks();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Method to filter blocks based on the search input
  void filterBlocks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredBlocks = data
          .where((block) => block.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,),
            onPressed: () {
              context.read<CheckInBloc>().add(ClearFlat());
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.black.withValues(alpha: 0.2),  // Change AppBar color here
          title: const Text(
            'Select Block',
            style: TextStyle(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold),  // Text color adjusted to white for visibility
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CheckInSearchBar(searchController: searchController, hintText: 'Search block',),
          ),
        ),
        body: BlocConsumer<CheckInBloc, CheckInState>(
          listener: (context, state){
            if(state is CheckInGetBlockLoading){
              _isLoading = true;
              _isError = false;
            }
            if(state is CheckInGetBlockSuccess){
              data = state.response;
              filteredBlocks = data;
              _isLoading = false;
              _isError = false;
            }
            if(state is CheckInGetBlockFailure){
              filteredBlocks = [];
              _isLoading = false;
              _isError = true;
            }
          },
          builder: (context, state){
            if(filteredBlocks.isNotEmpty && _isLoading == false){
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: GridView.builder(
                          itemCount: filteredBlocks.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 2.5,
                          ),
                          itemBuilder: (context, index) {
                            return BlockCard(onFunctionCall: () => onBlockPressed(filteredBlocks[index]), blockName: filteredBlocks[index],);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (_isLoading) {
              return const CustomLoader();
            } else if (filteredBlocks.isEmpty && _isError == true) {
              return BuildErrorState(onRefresh: _onRefresh);
            } else{
              return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no Block',);
            }
          },
        )
    );
  }

  Future<void> _onRefresh() async {
    context.read<CheckInBloc>().add(CheckInGetBlock());
  }

  void onBlockPressed(String blockName) {
    Navigator.pushNamed(context, '/apartment-selection-screen', arguments: {'blockName' : blockName, 'entryType' : widget.entryType, 'formData': widget.formData, 'categoryOption': widget.categoryOption});
  }
}
