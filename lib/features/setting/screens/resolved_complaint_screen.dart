import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/common_widgets/single_paginated_list_view.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/setting/widgets/complaint_card.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ResolvedComplaintScreen extends StatefulWidget {
  final bool? isAdmin;
  const ResolvedComplaintScreen({super.key, this.isAdmin = false});

  @override
  State<ResolvedComplaintScreen> createState() => _ResolvedComplaintScreenState();
}

class _ResolvedComplaintScreenState extends State<ResolvedComplaintScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Complaint> _data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  bool _isLazyLoading = false;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasActiveFilters = false;

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
      if (!_isLoading && _hasMore && _data.length>=_limit) {
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

    if (_startDate != null) {
      queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
    }

    if (_endDate != null) {
      queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }
    widget.isAdmin == true ? context.read<AdministrationBloc>().add(AdminGetResolvedComplaint(queryParams: queryParams)) : context.read<SettingBloc>().add(SettingGetResolvedComplaint(queryParams: queryParams));
  }

  void _applyFilters() {
    setState(() {
      _page = 1;
      _hasMore = true;
      _data.clear();
      _hasActiveFilters = _startDate != null || _endDate != null;
    });
    _fetchEntries();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _raiseComplaint(BuildContext context) async {
    // Store the context read functions before the async gap
    final isAdmin = widget.isAdmin == true;
    final adminBlocFunction = context.read<AdministrationBloc>().add;
    final settingBlocFunction = context.read<SettingBloc>().add;

    final data = await Navigator.pushNamed(context, '/complaint-form-screen');

    // Check if the widget is still mounted before proceeding
    if (!mounted) return;

    if (data is Map<String, dynamic>) {
      if (isAdmin) {
        adminBlocFunction(AdminGetPendingComplaint(queryParams: const {
          'page': '1',
          'limit': '10',
        }));
      } else {
        settingBlocFunction(SettingGetPendingComplaint(queryParams: const {
          'page': '1',
          'limit': '10',
        }));
      }
    }
  }

  void _onClearSearch(){
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _page = 1;
      _data.clear();
    });
    _fetchEntries();
  }

  void _onSearchSubmitted(value) {
    setState(() {
      _searchQuery = value;
      _page = 1;
      _data.clear();
    });
    _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<AdministrationBloc, AdministrationState>(
        listener: (context, state) {
          if (state is AdminGetResolvedComplaintLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is AdminGetResolvedComplaintSuccess) {
            if (state.response.pagination?.currentPage == 1) {
              _data.clear();
              _page=1;
            }
            _data.addAll(state.response.complaints as Iterable<Complaint>);
            _page++;
            _hasMore = state.response.pagination?.hasMore ?? false;
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
          }
          if (state is AdminGetResolvedComplaintFailure) {
            _data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
            _hasMore = false;
          }
        },
        builder: (context, state) {
          return BlocConsumer<SettingBloc, SettingState>(
            listener: (context, state) {
              if (state is SettingGetResolvedComplaintLoading) {
                _isLoading = true;
                _isError = false;
              }
              if (state is SettingGetResolvedComplaintSuccess) {
                if (state.response.pagination?.currentPage == 1) {
                  _data.clear();
                  _page=1;
                }
                _data.addAll(state.response.complaints as Iterable<Complaint>);
                _page++;
                _hasMore = state.response.pagination?.hasMore ?? false;
                _isLoading = false;
                _isLazyLoading = false;
                _isError = false;
              }
              if (state is SettingGetResolvedComplaintFailure) {
                _data = [];
                _isLoading = false;
                _isLazyLoading = false;
                _isError = true;
                statusCode= state.status;
                _hasMore = false;
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  SearchFilterBar(
                      searchController: _searchController,
                      hintText: "Search by id, category, etc.",
                      searchQuery: _searchQuery,
                      hasActiveFilters: _hasActiveFilters,
                      onFilterPressed: () => _showFilterBottomSheet(context),
                      onSearchSubmitted: _onSearchSubmitted,
                      onClearSearch: _onClearSearch
                  ),
                  Expanded(
                      child: _buildComplaintList(_data, context)
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'pendingFAB',
        onPressed: () => _raiseComplaint(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white70),
        label: const Text(
          'New Complaint',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }


  Widget _buildComplaintList(List<Complaint> complaints, BuildContext context) {
    if (_data.isNotEmpty && _isLoading == false) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: AnimationLimiter(
          child: SinglePaginatedListView<Complaint>(
            data: _data,
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
          child: SinglePaginatedListView<Complaint>(
            data: _data,
            controller: _scrollController,
            hasMore: _hasMore,
            itemBuilder: _itemBuilder,
          ),
        ),
      );
    } else if (_isLoading && _isLazyLoading==false) {
      return const CustomLoader();
    }else if (_data.isEmpty && _isError == true && statusCode == 401) {
      return BuildErrorState(onRefresh: _onRefresh);
    } else {
      return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no resolved complaints", kToolbarCount: 4,);
    }
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: ComplaintCard(
        complaint: item,
        onTap: _cardOnTap,
      ),
    );
  }

  Future<void> _cardOnTap(Complaint complaint, BuildContext context) async {
    // Store the context read functions before the async gap
    final isAdmin = widget.isAdmin == true;
    final adminBlocFunction = context.read<AdministrationBloc>().add;
    final settingBlocFunction = context.read<SettingBloc>().add;

    Map<String, dynamic> args = {'id': complaint.id,};

    var result = await Navigator.pushNamed(
      context,
      '/complaint-details-screen',
      arguments: args,
    );

    // Check if the widget is still mounted before proceeding
    if (!mounted) return;

    if (result is Complaint) {
      setState(() {
        int index = _data.indexWhere((item) => item.complaintId == complaint.complaintId);
        if (index != -1) {
          // _data[index] = result;
          _data.removeAt(index);
        }
      });
      if(result.status == 'resolved'){
        if (isAdmin) {
          setState(() {
            _data.clear();
            _page = 1;
          });
          adminBlocFunction(AdminGetResolvedComplaint(queryParams: const {
            'page': '1',
            'limit': '10',
          }));
        } else {
          setState(() {
            _data.clear();
            _page = 1;
          });
          settingBlocFunction(SettingGetResolvedComplaint(queryParams: const {
            'page': '1',
            'limit': '10',
          }));
        }
      }else{
        if (isAdmin) {
          adminBlocFunction(AdminGetPendingComplaint(queryParams: const {
            'page': '1',
            'limit': '10',
          }));
        } else {
          settingBlocFunction(SettingGetPendingComplaint(queryParams: const {
            'page': '1',
            'limit': '10',
          }));
        }
      }
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date Range',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        await _selectDateRange(context);
                        setModalState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 8),
                            Text(
                              _startDate != null && _endDate != null
                                  ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                                  : 'Select date range',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: SizedBox(
                            height: 48, // Equal height for both buttons
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48, // Same height
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _applyFilters();
                              },
                              child: const Text('Apply'),
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

  Future<void> _onRefresh() async {
    _page=1;
    await _fetchEntries();
  }

  @override
  bool get wantKeepAlive => true;
}