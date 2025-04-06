import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gloria_connect/features/guard_profile/models/checkout_history.dart';
import 'package:gloria_connect/features/guard_profile/widgets/checkout_history_card.dart';
import 'package:lottie/lottie.dart';

class CheckoutHistoryScreen extends StatefulWidget {
  const CheckoutHistoryScreen({super.key});

  @override
  State<CheckoutHistoryScreen> createState() => _CheckoutHistoryScreenState();
}

class _CheckoutHistoryScreenState extends State<CheckoutHistoryScreen> {
  List<CheckoutHistory> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<GuardProfileBloc>().add(GetCheckoutHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          title: const Text(
            "Checkout History",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        body: BlocConsumer<GuardProfileBloc, GuardProfileState>(
          listener: (context, state) {
            if (state is GetCheckoutHistoryLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is GetCheckoutHistorySuccess) {
              data = state.response;
              _isLoading = false;
              _isError = false;
            }
            if (state is GetCheckoutHistoryFailure) {
              data = [];
              _isLoading = false;
              _isError = true;
              statusCode = state.status;
            }
          },
          builder: (context, state) {
            if (data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: data.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return CheckoutHistoryCard(data: data[index]);
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
                onRefresh: _onRefresh,
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
                onRefresh: _onRefresh,
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
                          "There is no past visitors",
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }

  Future<void> _onRefresh() async {
    context.read<GuardProfileBloc>().add(GetCheckoutHistory());
  }
}
