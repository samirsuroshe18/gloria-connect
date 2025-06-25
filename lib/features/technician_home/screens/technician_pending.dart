import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:gloria_connect/features/technician_home/models/resolution_model.dart';
import 'package:gloria_connect/features/technician_home/widgets/assign_complaint_card.dart';

class TechnicianPending extends StatefulWidget {
  const TechnicianPending({super.key});

  @override
  State<TechnicianPending> createState() => _TechnicianPendingState();
}

class _TechnicianPendingState extends State<TechnicianPending> {
  final List<ResolutionElement> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<TechnicianHomeBloc>().add(GetAssignComplaint());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TechnicianHomeBloc, TechnicianHomeState>(
        listener: (context, state){
          if(state is GetAssignComplaintLoading){
            _isLoading = true;
            _isError = false;
          }
          if(state is GetAssignComplaintSuccess){
            _isLoading = false;
            _isError = false;
            data.clear();
            data.addAll(state.response);
          }
          if(state is GetAssignComplaintFailure){
            data.clear();
            _isLoading = false;
            _isError = true;
            statusCode = state.status;
          }
        },
        builder: (context, state){
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return StaggeredListAnimation(index: index, child: AssignComplaintCard(data: data[index]));
                  },
                ),
              ),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no current visitors',);
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<TechnicianHomeBloc>().add(GetAssignComplaint());
  }
}
