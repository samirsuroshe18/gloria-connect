import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/gate_pass/bloc/gate_pass_bloc.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';
import 'package:gloria_connect/features/gate_pass/widgets/pending_resident_gate_pass_card.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class PassPendingResidentScreen extends StatefulWidget {
  const PassPendingResidentScreen({super.key});

  @override
  State<PassPendingResidentScreen> createState() => _PassPendingResidentScreenState();
}

class _PassPendingResidentScreenState extends State<PassPendingResidentScreen> with AutomaticKeepAliveClientMixin {
  List<GatePassBanner> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  List<Map<String, bool>> isLoadingList = [];
  int? cardIndex;
  String? button;

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
    context.read<GatePassBloc>().add(GatePassGetPendingRes());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GatePassBloc, GatePassState>(
        listener: (context, state) {
          if (state is GatePassGetPendingResLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GatePassGetPendingResSuccess) {
            data = state.response;
            _isError = false;
            _isLoading = false;
            isLoadingList = List.generate(data.length, (index) => {
              'approve': false, 'reject': false
            },);
          }
          if (state is GatePassGetPendingResFailure) {
            data = [];
            _isError = true;
            statusCode= state.status;
            _isLoading = false;
          }

          if (state is GatePassApproveLoading) {
            setState(() {
              isLoadingList[cardIndex!][button!] = true;
            });
          }
          if (state is GatePassApproveSuccess) {
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
            context.read<GatePassBloc>().add(GatePassGetPendingRes());
          }
          if (state is GatePassApproveFailure) {
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
          }

          if (state is GatePassRejectLoading) {
            setState(() {
              isLoadingList[cardIndex!][button!] = true;
            });
          }
          if (state is GatePassRejectSuccess) {
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
            context.read<GatePassBloc>().add(GatePassGetPendingRes());
          }
          if (state is GatePassRejectFailure) {
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
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
              return StaggeredListAnimation(index: index, child: PendingResidentGatepassCard(
                isLoadingApprove: isLoadingList[index]['approve'] ?? false,
                isLoadingReject: isLoadingList[index]['reject'] ?? false,
                gatePassData: data[index],
                onApprove: () => _onApprove(data[index].id!, index),
                onReject: () => _onReject(data[index].id!, index),
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
    _fetchEntries();
  }

  void _onApprove(String id, int index){
    cardIndex = index;
    button = 'approve';
    context.read<GatePassBloc>().add(GatePassApprove(id: id));
  }

  void _onReject(String id, int index){
    cardIndex = index;
    button = 'reject';
    context.read<GatePassBloc>().add(GatePassReject(id: id));
  }

  @override
  bool get wantKeepAlive => true;
}