import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/common_widgets/single_paginated_list_view.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/widgets/expired_gate_pass_card.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../bloc/guard_profile_bloc.dart';

class GatePassExpiredScreen extends StatefulWidget {
  const GatePassExpiredScreen({super.key});

  @override
  State<GatePassExpiredScreen> createState() => _GatePassExpiredScreenState();
}

class _GatePassExpiredScreenState extends State<GatePassExpiredScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<GatePassBannerGuard> data = [];
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
  int? cardIndex;
  List<bool> isLoadingList = [];

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

    context.read<GuardProfileBloc>().add(GetExpiredGatePassSecurity(queryParams: queryParams));
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
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardProfileBloc, GuardProfileState>(
        listener: (context, state) {
          if (state is GetExpiredGatePassSecurityLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetExpiredGatePassSecuritySuccess) {
            if (_page == 1) {
              data.clear();
            }
            data.addAll(state.response.gatePassBanner as Iterable<GatePassBannerGuard>);
            _page++;
            _hasMore = state.response.pagination?.hasMore ?? false;
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
            isLoadingList = List.generate(data.length, (index) => false,);
          }
          if (state is GetExpiredGatePassSecurityFailure) {
            data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
            _hasMore = false;
          }

          if(state is RemoveGetGatePassLoading){
            setState(() {
              isLoadingList[cardIndex!] = true;
            });
          }
          if(state is RemoveGetGatePassSuccess){
            setState(() {
              isLoadingList[cardIndex!] = false;
            });
            _page = 1;
            _fetchEntries();
          }
          if(state is RemoveGetGatePassFailure){
            setState(() {
              isLoadingList[cardIndex!] = false;
            });
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                color: Colors.black.withValues(alpha: 0.2),
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
              Expanded(
                  child: _buildGatePassList()
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGatePassList(){
    if (data.isNotEmpty && _isLoading == false) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: AnimationLimiter(
            child: SinglePaginatedListView<GatePassBannerGuard>(
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
            child: SinglePaginatedListView<GatePassBannerGuard>(
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
      return BuildErrorState(onRefresh: _onRefresh, kToolbarCount: 4,);
    } else {
      return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'No Gate Pass Entries Found', kToolbarCount: 4);
    }
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: ExpiredGatePassCard(
        gatePass: item,
          onDelete: ()=> _onDelete(data[index].id!, index),
          isLoading: isLoadingList[index]
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

  Future<void> _onRefresh() async {
    _page=1;
    _fetchEntries();
  }

  void _onDelete(String id, int index){
    cardIndex = index;
    context.read<GuardProfileBloc>().add(RemoveGatePass(id: id));
  }

  @override
  bool get wantKeepAlive => true;
}