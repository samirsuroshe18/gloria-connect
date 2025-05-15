import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/grouped_paginated_list_view.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/models/past_delivery_model.dart';
import 'package:gloria_connect/features/my_visitors/widgets/visitor_denied_card.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DeniedVisitorsScreen extends StatefulWidget {
  const DeniedVisitorsScreen({super.key});

  @override
  State<DeniedVisitorsScreen> createState() => _DeniedVisitorsScreenState();
}

class _DeniedVisitorsScreenState extends State<DeniedVisitorsScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Entry> data = [];
  bool _isLoading = false;
  bool _isLazyLoading = false;
  bool _isError = false;
  int? statusCode;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';
  String _selectedEntryType = '';
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

    if (_selectedEntryType.isNotEmpty) {
      queryParams['entryType'] = _selectedEntryType;
    }

    if (_startDate != null) {
      queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
    }

    if (_endDate != null) {
      queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<MyVisitorsBloc>().add(GetDeniedEntries(queryParams: queryParams));
  }

  void _applyFilters() {
    setState(() {
      _page = 1;
      _hasMore = true;
      data.clear();
      _hasActiveFilters = _selectedEntryType.isNotEmpty || _startDate != null || _endDate != null;
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
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
    super.build(context);
    return Scaffold(
        body: Column(
          children: [
            // Persistent search and filter bar at the top
            SearchFilterBar(
            searchController: _searchController,
            hintText: 'Search by name, mobile, etc.',
            searchQuery: _searchQuery,
            onSearchSubmitted: _onSearchSubmitted,
            onClearSearch: _onClearSearch,
            isFilterButton: true,
            hasActiveFilters: _hasActiveFilters,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),

            Expanded(
              child: BlocConsumer<MyVisitorsBloc, MyVisitorsState>(
                    listener: (context, state) {
              if (state is GetDeniedEntriesLoading) {
                _isLoading = true;
                _isError = false;
              }
              if (state is GetDeniedEntriesSuccess) {
                if (_page == 1) {
                  data.clear();
                }
                data.addAll(state.response.entries as Iterable<Entry>);
                _page++;
                _hasMore = state.response.pagination?.hasMore ?? false;
                _isLoading = false;
                _isLazyLoading = false;
                _isError = false;
              }
              if (state is GetDeniedEntriesFailure) {
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
                    child: GroupedPaginatedListView<Entry>(
                      groupedData: _getGroupedData(),
                      controller: _scrollController,
                      hasMore: _hasMore,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      groupHeaderBuilder: _groupHeaderBuilder,
                      itemBuilder: _itemBuilder,
                    ),
                  ),
                );
              } else if (_isLazyLoading) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: AnimationLimiter(
                    child: GroupedPaginatedListView<Entry>(
                      groupedData: _getGroupedData(),
                      controller: _scrollController,
                      hasMore: _hasMore,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      groupHeaderBuilder: _groupHeaderBuilder,
                      itemBuilder: _itemBuilder,
                    ),
                  ),
                );
              } else if (_isLoading && _isLazyLoading==false) {
                return const CustomLoader();
              } else if (data.isEmpty && _isError == true && statusCode == 401) {
                return BuildErrorState(onRefresh: _onRefresh);
              } else {
                return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no denied visitors", kToolbarCount: 4,);
              }
            },
          ),
        ),
      ],
    ),
  );
}

  Future<void> _onRefresh() async {
    if(_hasMore) {
      await _fetchEntries();
    }
  }

  Map<String, List<Entry>> _getGroupedData(){
    // Group entries by date
    final Map<String, List<Entry>> groupedEntries = {};
    for (var entry in data) {
      final String dateKey = _formatDate(entry.exitTime!);

      if (!groupedEntries.containsKey(dateKey)) {
        groupedEntries[dateKey] = [];
      }

      groupedEntries[dateKey]!.add(entry);
    }
    return groupedEntries;
  }

  Widget _groupHeaderBuilder(date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ),
    );
  }

  Widget _itemBuilder(entry, index) {
    return StaggeredListAnimation(
      index: index,
      child: VisitorDeniedCard(data: entry),
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
                              _selectedEntryType = '';
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
                      'Entry Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('Delivery', 'delivery', setModalState),
                        _buildFilterChip('Guest', 'guest', setModalState),
                        _buildFilterChip('Cab', 'cab', setModalState),
                        _buildFilterChip('Other', 'other', setModalState),
                        _buildFilterChip('Service', 'service', setModalState),
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
      selected: _selectedEntryType == value,
      onSelected: (selected) {
        setModalState(() {
          _selectedEntryType = selected ? value : '';
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
