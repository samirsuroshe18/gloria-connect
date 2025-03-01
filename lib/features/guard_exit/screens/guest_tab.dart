import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../guard_waiting/models/entry.dart';
import '../bloc/guard_exit_bloc.dart';
import '../widgets/exit_card.dart';

class GuestTab extends StatefulWidget {
  const GuestTab({super.key});

  @override
  State<GuestTab> createState() => _GuestTabState();
}

class _GuestTabState extends State<GuestTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  List<Entry> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<GuardExitBloc>().add(ExitGetGuestEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardExitBloc, GuardExitState>(
        listener: (context, state) {
          if (state is ExitGetGuestEntriesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is ExitGetGuestEntriesSuccess) {
            data = state.response;
            _isLoading = false;
            _isError = false;
          }
          if (state is ExitGetGuestEntriesFailure) {
            data = [];
            _isLoading = false;
            _isError = true;
            statusCode = state.status;
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return ExitCard(
                    data: data[index],
                    type: 'guest',
                  );
                },
              ),
            );
          } else if (_isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animations/loader.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            );
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/error.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Something went wrong!",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/no_data.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "All clear! No visitors at the moment.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _refresh() async {
    context.read<GuardExitBloc>().add(ExitGetGuestEntries());
  }

  void onSearch(value) {}

  // ignore: unused_element
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearch,
          decoration: InputDecoration(
            hintText: 'Search by Name, Flat, or Vehicle number',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.search, color: Colors.blue),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0), // Adjusting padding
          ),
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          cursorColor: Colors.blue, // Cursor color
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
