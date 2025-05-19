import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/common_widgets/single_paginated_list_view.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/widgets/gate_pass_card.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../bloc/guard_profile_bloc.dart';

class GatePassListScreen extends StatefulWidget {
  const GatePassListScreen({super.key});

  @override
  State<GatePassListScreen> createState() => _GatePassListScreenState();
}

class _GatePassListScreenState extends State<GatePassListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<GatePassBanner> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  bool _isLazyLoading = false;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';
  String _selectedStatusType = '';
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
      if (!_isLoading && _hasMore) {
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

    if (_selectedStatusType.isNotEmpty) {
      queryParams['status'] = _selectedStatusType;
    }

    if (_startDate != null) {
      queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
    }

    if (_endDate != null) {
      queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<GuardProfileBloc>().add(GetGatePass(queryParams: queryParams));
  }

  void _applyFilters() {
    setState(() {
      _page = 1;
      _hasMore = true;
      data.clear();
      _hasActiveFilters = _selectedStatusType.isNotEmpty || _startDate != null || _endDate != null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          title: const Text(
            "Gate Pass",
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
              isFilterButton: true,
              hasActiveFilters: _hasActiveFilters,
              onFilterPressed: () => _showFilterBottomSheet(context),
            ),
          ),
        ),
        body: BlocConsumer<GuardProfileBloc, GuardProfileState>(
          listener: (context, state) {
            if (state is GetGatePassLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is GetGatePassSuccess) {
              if (_page == 1) {
                data.clear();
              }
              data.addAll(state.response.gatePassBanner as Iterable<GatePassBanner>);
              _page++;
              _hasMore = state.response.pagination?.hasMore ?? false;
              _isLoading = false;
              _isLazyLoading = false;
              _isError = false;
            }
            if (state is GetGatePassFailure) {
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
                  child: SinglePaginatedListView<GatePassBanner>(
                    data: data,
                    controller: _scrollController,
                    hasMore: _hasMore,
                    itemBuilder: _itemBuilder,
                  )
                ),
              );
            } else if (_isLazyLoading) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: SinglePaginatedListView<GatePassBanner>(
                    data: data,
                    controller: _scrollController,
                    hasMore: _hasMore,
                    itemBuilder: _itemBuilder,
                  )
                ),
              );
            } else if (_isLoading && _isLazyLoading==false) {
              return const CustomLoader();
            } else if (data.isEmpty && _isError == true && statusCode == 401) {
              return BuildErrorState(onRefresh: _onRefresh);
            } else {
              return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no gate passes or services.',);
            }
          },
        ),
    );
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: GatePassCard(
        data: item,
      ),
    );
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
                          'Filter Entries',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedStatusType = '';
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('All', 'all', setModalState),
                        _buildFilterChip('Active', 'active', setModalState),
                        _buildFilterChip('Expired', 'expired', setModalState),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date Range',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildFilterChip(String label, String value, StateSetter setModalState) {
    return FilterChip(
      label: Text(label),
      selected: _selectedStatusType == value,
      onSelected: (selected) {
        setModalState(() {
          _selectedStatusType = selected ? value : '';
        });
      },
    );
  }

  Future<void> _onRefresh() async {
    if(_hasMore) {
      await _fetchEntries();
    }
  }
}