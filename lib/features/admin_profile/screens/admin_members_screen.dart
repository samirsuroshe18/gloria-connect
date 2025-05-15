import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/admin_profile/widgets/build_apt_member_card.dart';
import 'package:gloria_connect/features/resident_profile/bloc/resident_profile_bloc.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

import '../../resident_profile/models/member.dart';

class AdminMembersScreen extends StatefulWidget {
  const AdminMembersScreen({super.key,});

  @override
  State<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends State<AdminMembersScreen> {
  List<Member> data = [];
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    context.read<ResidentProfileBloc>().add(GetApartmentMembers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Apartment Members',
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
        ),
      body: BlocConsumer<ResidentProfileBloc, ResidentProfileState>(
        listener: (context, state){
          if (state is GetApartmentMembersLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetApartmentMembersSuccess) {
            _isLoading = false;
            _isError = false;
            data = state.response;
          }
          if (state is GetApartmentMembersFailure) {
            _isLoading = false;
            _isError = true;
            data = [];
          }
        },
        builder: (context, state){
          if(data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,  // Method to refresh user data
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  itemBuilder: (context, index) {
                    final member = data[index];
                    return StaggeredListAnimation(index: index, child: BuildAptMemberCard(member: member));
                  },
                ),
              ),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else if (data.isEmpty && _isError == true) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no apartment members",);
          }
        },
      )
    );
  }

  Future<void> _onRefresh() async {
    context.read<ResidentProfileBloc>().add(GetApartmentMembers());
  }
}
