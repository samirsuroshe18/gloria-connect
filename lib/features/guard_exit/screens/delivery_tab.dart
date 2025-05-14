import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';

import '../../guard_waiting/models/entry.dart';
import '../bloc/guard_exit_bloc.dart';
import '../widgets/exit_card.dart';

class DeliveryTab extends StatefulWidget {
  const DeliveryTab({super.key});

  @override
  State<DeliveryTab> createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  List<VisitorEntries> data = [];

  @override
  void initState() {
    super.initState();
    context.read<GuardExitBloc>().add(ExitGetDeliveryEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardExitBloc, GuardExitState>(
        listener: (context, state) {
          if (state is ExitGetDeliveryEntriesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is ExitGetDeliveryEntriesSuccess) {
            _isLoading = false;
            _isError = false;
            data = state.response;
          }
          if (state is ExitGetDeliveryEntriesFailure) {
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
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExitCard(
                      data: data[index],
                      type: 'delivery',
                    );
                  },
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
    context.read<GuardExitBloc>().add(ExitGetDeliveryEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
