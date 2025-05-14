import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/search_filter_bar.dart';
import 'package:gloria_connect/common_widgets/single_paginated_list_view.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:gloria_connect/features/administration/widgets/member_card.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

class AllResidentScreen extends StatefulWidget {
  const AllResidentScreen({super.key,});

  @override
  State<AllResidentScreen> createState() => _AllResidentScreenState();
}

class _AllResidentScreenState extends State<AllResidentScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<SocietyMember> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  bool _isLazyLoading = false;
  int _page = 1;
  final int _limit = 15;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
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

    context.read<AdministrationBloc>().add(AdminGetSocietyMember(queryParams: queryParams));
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

  void _onSearchSubmitted(value) {
    setState(() {
      _searchQuery = value;
      _page = 1;
      data.clear();
    });
    _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Society Members',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
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
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyMemberLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyMemberSuccess) {
              if (_page == 1) {
                data.clear();
              }
              data.addAll(state.response.societyMembers as Iterable<SocietyMember>);
              _page++;
              _hasMore = state.response.pagination?.hasMore ?? false;
              _isLoading = false;
              _isLazyLoading = false;
              _isError = false;
            }
            if (state is AdminGetSocietyMemberFailure) {
              data = [];
              _isLoading = false;
              _isLazyLoading = false;
              _isError = true;
              statusCode= state.status;
              _hasMore = false;
            }
            if (state is AdminCreateAdminSuccess) {
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
            }
            if (state is AdminCreateAdminFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
            if (state is AdminRemoveResidentSuccess) {
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
            }
            if (state is AdminRemoveResidentFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
          },
          builder: (context, state){
            if (data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: SinglePaginatedListView<SocietyMember>(
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
                  child: SinglePaginatedListView<SocietyMember>(
                    data: data,
                    controller: _scrollController,
                    hasMore: _hasMore,
                    itemBuilder: _itemBuilder,
                  ),
                ),
              );
            } else if (_isLoading && _isLazyLoading==false) {
              return const CustomLoader();
            }else if (data.isEmpty && _isError == true && statusCode == 401) {
              return BuildErrorState(onRefresh: _onRefresh);
            } else {
              return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no residents.",);
            }
          },
        )
    );
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: MemberCard(
        data: item,
        deleteResident: _deleteResident,
        makeAdmin: _makeAdmin,
      ),
    );
  }

  Future<void> _makeAdmin(String email) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promote User to Admin'),
          content: const Text('Are you sure you want to grant admin privileges to this user? Admins have elevated permissions to manage the system.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminCreateAdminLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminCreateAdminFailure) {
                  return TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminCreateAdmin(email: email));
                    },
                  );
                }else if (state is AdminCreateAdminSuccess) {
                  onPressed(){
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Confirm'),
                  );
                } else {
                  return TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(
                        AdminCreateAdmin(email: email),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteResident(String id) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Resident', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this resident? This action cannot be undone and will remove all associated data.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveResidentLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminRemoveResidentFailure) {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveResident(id: id));
                    },
                  );
                }else if (state is AdminRemoveResidentSuccess) {
                  onPressed(){
                    _page = 1;
                    context.read<AdministrationBloc>().add(AdminGetSocietyMember(queryParams: {
                      'page': _page.toString(),
                      'limit': _limit.toString(),
                    }));
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  );
                } else {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveResident(id: id));
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    if(_hasMore) {
      await _fetchEntries();
    }
  }
}
