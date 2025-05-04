import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/widgets/gate_pass_card.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';
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

  Widget _buildSearchFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Search field (expanded to take available width)
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  hintText: 'Search by name, mobile, etc.',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _page = 1;
                        data.clear();
                      });
                      _fetchEntries();
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2)
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                  _page = 1;
                  data.clear();
                });
                _fetchEntries();
              },
            ),
          ),

          // Small gap between search and filter button
          const SizedBox(width: 8),

          // Filter button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () => _showFilterBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: _hasActiveFilters
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      if (_hasActiveFilters)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          title: const Text(
            "Gate Pass",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: _buildSearchFilterBar(),
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
                  child: _buildEntriesList(),
                ),
              );
            } else if (_isLazyLoading) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: _buildEntriesList(),
                ),
              );
            } else if (_isLoading && _isLazyLoading==false) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/loader.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              );
            } else if (data.isEmpty && _isError == true && statusCode == 401) {
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
                          "There is no gate pass",
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

  Widget _buildEntriesList() {

    return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index < data.length) {
            return StaggeredListAnimation(index: index, child: GatePassCard(data: data[index]));
          } else {
            if (_hasMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text("No more data to load")),
              );
            }
          }
        }
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