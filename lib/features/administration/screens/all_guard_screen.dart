import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_guard.dart';
import 'package:gloria_connect/features/administration/widgets/guard_card.dart';
import 'package:gloria_connect/features/administration/widgets/search_bar.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';


class AllGuardScreen extends StatefulWidget {
  const AllGuardScreen({super.key,});

  @override
  State<AllGuardScreen> createState() => _AllGuardScreenState();
}

class _AllGuardScreenState extends State<AllGuardScreen> {
  List<SocietyGuard> data = [];
  List<SocietyGuard> filteredGuards = [];
  String searchQuery = '';
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
  }

  void _filterGuards(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredGuards = data;
      } else {
        filteredGuards = data
            .where((data) =>
        data.user!.userName!.toLowerCase().contains(query.toLowerCase()) ||
            data.user!.phoneNo!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Guards',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomSearchBar(filter: _filterGuards),
          ),
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyGuardLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyGuardSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
              filteredGuards = data;
            }
            if (state is AdminGetSocietyGuardFailure) {
              _isLoading = false;
              _isError = true;
              filteredGuards = [];
              statusCode = state.status;
            }
            if (state is AdminRemoveGuardSuccess) {
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
            }
            if (state is AdminRemoveGuardFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
          },
          builder: (context, state){
            if(data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,  // Method to refresh user data
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredGuards.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    itemBuilder: (context, index) {
                      final data = filteredGuards[index];
                      return StaggeredListAnimation(
                        index: index,
                        child: GuardCard(
                          data: data,
                          deleteGuard: _deleteGuard,
                          guardReport: _guardReport,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (_isLoading) {
              return const CustomLoader();
            } else if (filteredGuards.isEmpty && _isError == true && statusCode == 401) {
              return BuildErrorState(onRefresh: _onRefresh);
            } else {
              return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no guard.",);
            }
          },
        )
    );
  }

  Future<void> _onRefresh() async {
    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
  }

  Future<void> _deleteGuard(String id) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Guard', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this security guard? This action cannot be undone and will remove all associated data.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveGuardLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminRemoveGuardFailure) {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveGuard(id: id));
                    },
                  );
                }else if (state is AdminRemoveGuardSuccess) {
                  onPressed(){
                    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
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
                      context.read<AdministrationBloc>().add(
                        AdminRemoveGuard(id: id),
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

  Future<void> _guardReport(String id) async {
    if(!mounted) return;
    Navigator.pushNamed(context, '/guard-report', arguments: id);
  }
}
