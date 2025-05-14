import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/entry_card.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

import '../models/entry.dart';

class GuardWaitingScreen extends StatefulWidget {
  const GuardWaitingScreen({super.key});

  @override
  State<GuardWaitingScreen> createState() => _GuardWaitingScreenState();
}

class _GuardWaitingScreenState extends State<GuardWaitingScreen> {
  List<VisitorEntries> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<GuardWaitingBloc>().add(WaitingGetEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Waiting for Approval',
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
        ),
        body: BlocConsumer<GuardWaitingBloc, GuardWaitingState>(
          listener: (context, state) {
            if (state is WaitingGetEntriesLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is WaitingGetEntriesSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
            }
            if (state is WaitingGetEntriesFailure) {
              _isLoading = false;
              _isError = true;
              statusCode = state.status;
              data = [];
            }
          },
          builder: (context, state) {
            if (data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return StaggeredListAnimation(index: index, child: EntryCard(
                        data: data[index],
                      ));
                    },
                  ),
                ),
              );
            } else if (_isLoading) {
              return const CustomLoader();
            } else if (data.isEmpty && _isError == true && statusCode == 401) {
              return BuildErrorState(onRefresh: _onRefresh);
            } else {
              return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There is no waiting entries',);
            }
          },
        ),
    );
  }

  // Function to simulate refreshing data
  Future<void> _onRefresh() async {
    context.read<GuardWaitingBloc>().add(WaitingGetEntries());
  }
}
