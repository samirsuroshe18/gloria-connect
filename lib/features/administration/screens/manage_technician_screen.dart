import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/common_widgets/single_paginated_list_view.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';
import 'package:gloria_connect/features/administration/widgets/technician_card.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class ManageTechnicianScreen extends StatefulWidget {
  const ManageTechnicianScreen({super.key});
  @override
  State<ManageTechnicianScreen> createState() => _ManageTechnicianScreenState();
}

class _ManageTechnicianScreenState extends State<ManageTechnicianScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Technician> data = [];
  bool _isLoading = false;
  bool _isLazyLoading = false;
  bool _isError = false;
  int? statusCode;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore && data.length>=_limit) {
        _isLazyLoading = true;
        _fetchEntries();
      }
    }
  }

  Future<void> _fetchEntries()async {
    final queryParams = {
      'page': _page.toString(),
      'limit': _limit.toString(),
    };

    if (_searchQuery.isNotEmpty) {
      queryParams['search'] = _searchQuery;
    }

    context.read<AdministrationBloc>().add(AdminGetTechnician(queryParams: queryParams));
  }

  void _onSearchSubmitted(value) {
    setState(() {
      _searchQuery = value;
      _page = 1;
      data.clear();
    });
    _fetchEntries();
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _page = 1;
      data.clear();
    });
    _fetchEntries();
  }

  void _addTechnician() async {
    final result = await Navigator.pushNamed(context, '/add-technician-screen');
    if (result != null && result is Technician) {
      setState(() {
        data.add(result);
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context, Technician technician) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state) {
            if(state is AdminRemoveTechnicianLoading){
              debugPrint('loading');
            }
            // Close dialog when deletion is complete (success or error)
            if (state is AdminRemoveTechnicianSuccess) {
              data.removeWhere((tech) => tech.id == technician.id);
              Navigator.pop(context);
              // Show success snackbar
              CustomSnackBar.show(context: context, message: '${technician.userName} has been deleted successfully', type: SnackBarType.success);
            } else if (state is AdminRemoveTechnicianFailure) {
              debugPrint('error : ${state.message}');
              Navigator.pop(context);
              // Show error snackbar
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
          },
          builder: (context, state) {
            bool isDeleting = state is AdminRemoveTechnicianLoading;

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
                            text: '${technician.userName ?? "NA"}\'s',
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
                            onPressed: isDeleting ? null : () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: isDeleting ? Colors.grey[300] : Colors.grey[200],
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
                            onPressed: isDeleting
                                ? null
                                : () {
                              context.read<AdministrationBloc>().add(
                                  AdminRemoveTechnician(id: technician.id!)
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: isDeleting ? Colors.red[300] : Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isDeleting
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Deleting...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                                : const Text(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        title: const Text(
          'Manage Technicians',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SearchFilterBar(
            searchController: _searchController,
            hintText: 'Search by name, mobile, etc.',
            searchQuery: _searchQuery,
            onSearchSubmitted: _onSearchSubmitted,
            onClearSearch: _onClearSearch,
            isFilterButton: false,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTechnician,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<AdministrationBloc, AdministrationState>(
        listener: (context, state) {
          if (state is AdminGetTechnicianLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is AdminGetTechnicianSuccess) {
            if (_page == 1) {
              data.clear();
            }
            data.addAll(state.response.technicians as Iterable<Technician>);
            _page++;
            _hasMore = state.response.pagination?.hasMore ?? false;
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
          }
          if (state is AdminGetTechnicianFailure) {
            data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
            _hasMore = false;
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: SinglePaginatedListView<Technician>(
                  data: data,
                  controller: _scrollController,
                  hasMore: _hasMore,
                  itemBuilder: _itemBuilder,
                ),
              ),
            );
          } else if (_isLazyLoading) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: SinglePaginatedListView<Technician>(
                  data: data,
                  controller: _scrollController,
                  hasMore: _hasMore,
                  itemBuilder: _itemBuilder,
                ),
              ),
            );
          } else if (_isLoading && _isLazyLoading==false) {
            return const CustomLoader();
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no technician.',);
          }
        },
      ),
    );
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: TechnicianCard(data: item, showDeleteConfirmation: ()=> _showDeleteConfirmation(context, item)),
    );
  }

  Future<void> _onRefresh() async {
    _page = 1;
    await _fetchEntries();
  }
}