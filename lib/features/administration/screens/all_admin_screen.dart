import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:gloria_connect/features/administration/widgets/admin_card.dart';
import 'package:gloria_connect/features/administration/widgets/search_bar.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

class AllAdminScreen extends StatefulWidget {
  const AllAdminScreen({super.key,});

  @override
  State<AllAdminScreen> createState() => _AllAdminScreenState();
}

class _AllAdminScreenState extends State<AllAdminScreen> {
  List<SocietyMember> data = [];
  List<SocietyMember> filteredAdmin = [];
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
    context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
  }

  void _filterAdmin(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAdmin = data;
      } else {
        filteredAdmin = data
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
            'Society Admin',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomSearchBar(filter: _filterAdmin),
          ),
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyAdminLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyAdminSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
              filteredAdmin = data;
            }
            if (state is AdminGetSocietyAdminFailure) {
              _isLoading = false;
              _isError = true;
              filteredAdmin = [];
              statusCode = state.status;
            }
            if (state is AdminRemoveAdminSuccess) {
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
            }
            if (state is AdminRemoveAdminFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
          },
          builder: (context, state){
            if(filteredAdmin.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,  // Method to refresh user data
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredAdmin.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    itemBuilder: (context, index) {
                      final data = filteredAdmin[index];
                      return StaggeredListAnimation(
                        index: index,
                        child: AdminCard(
                          data: data,
                          removeAdmin: _removeAdmin,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (_isLoading) {
              return const CustomLoader();
            } else if (filteredAdmin.isEmpty && _isError == true && statusCode == 401) {
              return BuildErrorState(onRefresh: _onRefresh);
            } else {
              return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no admin.",);
            }
          },
        )
    );
  }

  Future<void> _onRefresh() async {
    context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
  }

  Future<void> _removeAdmin(String email) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Revoke Admin Privileges', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to revoke admin privileges from this user? They will lose access to admin-level features and permissions.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveAdminLoading) {
                  return const CircularProgressIndicator(color: Colors.red,);
                } else if (state is AdminRemoveAdminFailure) {
                  return TextButton(
                    child: const Text('Revoke', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveAdmin(email: email));
                    },
                  );
                }else if (state is AdminRemoveAdminSuccess) {
                  onPressed(){
                    context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Revoke', style: TextStyle(color: Colors.red)),
                  );
                } else {
                  return TextButton(
                    child: const Text('Revoke', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(
                        AdminRemoveAdmin(email: email),
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
}
