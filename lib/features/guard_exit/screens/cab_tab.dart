import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

import '../../guard_waiting/models/entry.dart';
import '../bloc/guard_exit_bloc.dart';
import '../widgets/exit_card.dart';

class CabTab extends StatefulWidget {
  const CabTab({super.key});

  @override
  State<CabTab> createState() => _CabTabState();
}

class _CabTabState extends State<CabTab> with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  List<VisitorEntries> data = [];

  @override
  void initState() {
    super.initState();
    context.read<GuardExitBloc>().add(ExitGetCabEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardExitBloc, GuardExitState>(
        listener: (context, state) {
          if (state is ExitGetCabEntriesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is ExitGetCabEntriesSuccess) {
            _isLoading = false;
            _isError = false;
            data = state.response;
          }
          if (state is ExitGetCabEntriesFailure) {
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
                      return StaggeredListAnimation(index: index, child: ExitCard(
                        data: data[index],
                        type: 'cab',
                      ));
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
    context.read<GuardExitBloc>().add(ExitGetCabEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
