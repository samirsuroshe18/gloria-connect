import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

import '../../guard_waiting/models/entry.dart';
import '../widgets/exit_card.dart';

class AllTab extends StatefulWidget {
  const AllTab({super.key});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  List<VisitorEntries> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardExitBloc, GuardExitState>(
        listener: (context, state) {
          if (state is ExitGetAllowedEntriesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is ExitGetAllowedEntriesSuccess) {
            _isLoading = false;
            _isError = false;
            data = state.response;
          }
          if (state is ExitGetAllowedEntriesFailure) {
            _isLoading = false;
            _isError = true;
            statusCode = state.status;
            data = [];
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return StaggeredListAnimation(index: index, child: ExitCard(data: data[index], type: 'all'));
                    },
                  ),
                ),
              ),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'All clear! No visitors at the moment.',);
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
