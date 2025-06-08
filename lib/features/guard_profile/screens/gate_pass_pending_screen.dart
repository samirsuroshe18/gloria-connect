import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/guard_profile/widgets/pending_gate_pass_card.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

import '../bloc/guard_profile_bloc.dart';

class GatePassPendingScreen extends StatefulWidget {
  const GatePassPendingScreen({super.key});

  @override
  State<GatePassPendingScreen> createState() => _GatePassPendingScreenState();
}

class _GatePassPendingScreenState extends State<GatePassPendingScreen> with AutomaticKeepAliveClientMixin {
  List<GatePassBannerGuard> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchEntries()async {
    context.read<GuardProfileBloc>().add(GetPendingGatePass());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardProfileBloc, GuardProfileState>(
        listener: (context, state) {
          if (state is GetPendingGatePassLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetPendingGatePassSuccess) {
            data.addAll(state.response);
            _isError = false;
            _isLoading = false;
          }
          if (state is GetPendingGatePassFailure) {
            data = [];
            _isError = true;
            statusCode= state.status;
            _isLoading = false;
          }
        },
        builder: (context, state) {
          return _buildGatePassList();
        },
      ),
    );
  }

  Widget _buildGatePassList(){
    if (data.isNotEmpty && _isLoading == false) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: AnimationLimiter(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return StaggeredListAnimation(index: index, child: PendingGatepassCard(
                gatepassData: data[index],
                onViewPressed: () {
                  // Navigate to detail page
                  CustomSnackBar.show(context: context, message: 'Currently working', type: SnackBarType.info);
                },
              ));
            },
          ),
        ),
      );
    } else if (_isLoading) {
      return const CustomLoader();
    } else if (data.isEmpty && _isError == true && statusCode == 401) {
      return BuildErrorState(onRefresh: _onRefresh, kToolbarCount: 4,);
    } else {
      return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'No Gate Pass Found', kToolbarCount: 4);
    }
  }

  Future<void> _onRefresh() async {
    await _fetchEntries();
  }

  @override
  bool get wantKeepAlive => true;
}