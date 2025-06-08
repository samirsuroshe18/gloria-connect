import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/features/gate_pass/bloc/gate_pass_bloc.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class GatepassServiceScreen extends StatefulWidget {
  final GatePassBannerGuard data;

  const GatepassServiceScreen({
    super.key,
    required this.data,
  });

  @override
  State<GatepassServiceScreen> createState() => _GatepassServiceScreenState();
}

class _GatepassServiceScreenState extends State<GatepassServiceScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isAddingApartment = false;
  bool _isDeleteLoading = false;
  String? _removingApartmentId;
  bool _isLoading = false;
  int? statusCode;
  GatePassBannerGuard? gatePassBanner;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<GuardProfileBloc>().add(GetGatePassDetails(id: widget.data.id!));
  }

  void _onApartmentDelete(String aptId) {
    context.read<GatePassBloc>().add(GatePassRemoveApartmentSecurity(id: widget.data.id!, aptId: aptId));
  }

  void _onGatePassDelete() {
    context.read<GuardProfileBloc>().add(RemoveGatePass(id: widget.data.id!));
  }

  void _onApartmentAdd(String email) {
    context.read<GatePassBloc>().add(GatePassAddApartment(id: widget.data.id!, email: email));
  }

  Future<void> _onRefresh() async {
    context.read<GuardProfileBloc>().add(GetGatePassDetails(id: widget.data.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gatepass Service Management',
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      body: BlocConsumer<GatePassBloc, GatePassState>(
        listener: (context, state){
          if(state is GatePassAddApartmentLoading){
            _isAddingApartment = true;
          }
          if(state is GatePassAddApartmentSuccess){
            _isAddingApartment = false;
            gatePassBanner = state.response;
            _emailController.clear();
            CustomSnackBar.show(context: context, message: "Apartment added successfully", type: SnackBarType.success);
          }
          if(state is GatePassAddApartmentFailure){
            _isAddingApartment = false;
            statusCode = state.status;
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.success);
          }

          if(state is GatePassRemoveApartmentSecuritySuccess){
            gatePassBanner = state.response;
            CustomSnackBar.show(context: context, message: "Apartment removed successfully", type: SnackBarType.success);
          }
          if(state is GatePassRemoveApartmentSecurityFailure){
            statusCode = state.status;
            CustomSnackBar.show(context: context, message: "Something went wrong", type: SnackBarType.success);
          }

          if(state is RemoveGetGatePassLoading){
            _isDeleteLoading = true;
          }
          if(state is RemoveGetGatePassSuccess){
            _isDeleteLoading = false;
            Navigator.of(context).pop();
          }
          if(state is RemoveGetGatePassFailure){
            _isDeleteLoading = false;
            CustomSnackBar.show(context: context, message: "Something went wrong", type: SnackBarType.success);
          }
        },
        builder: (context, state){
          return BlocConsumer<GuardProfileBloc, GuardProfileState>(
            listener: (context, state) {
              if(state is GetGatePassDetailsLoading){
                _isLoading = true;
              }
              if(state is GetGatePassDetailsSuccess){
                _isLoading = false;
                gatePassBanner = state.response;
              }
              if(state is GetGatePassDetailsFailure){
                _isLoading = false;
                statusCode = state.status;
              }
            },
            builder: (context, state) {
              if (gatePassBanner != null && _isLoading == false) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildServiceHeader(),
                        const SizedBox(height: 20),
                        _buildVisitorInfo(),
                        const SizedBox(height: 20),
                        _buildCheckInDetails(),
                        const SizedBox(height: 20),
                        _buildApartmentManagement(),
                        const SizedBox(height: 20),
                        _buildApartmentsList(),
                        const SizedBox(height: 20),
                        _buildShareCode(),
                        const SizedBox(height: 20),
                        _buildDangerZone(),
                      ],
                    ),
                  ),
                );
              } else if (_isLoading) {
                return const CustomLoader();
              } else {
                return BuildErrorState(onRefresh: _onRefresh);
              }
            },
          );
        },
      )
    );
  }

  Widget _buildServiceHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomCachedNetworkImage(
                imageUrl: gatePassBanner?.serviceLogo,
                size: 60,
                isCircular: true,
                borderWidth: 2,
                errorImage: Icons.business,
                onTap: ()=> CustomFullScreenImageViewer.show(context, gatePassBanner?.serviceLogo, errorImage: Icons.business),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gatePassBanner?.serviceName ?? 'Service Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gatePassBanner?.entryType ?? 'Entry Type',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white.withValues(alpha: 0.8), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${gatePassBanner?.societyName ?? 'Society'} - ${gatePassBanner?.societyBlock ?? 'Block'}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visitor Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomCachedNetworkImage(
                imageUrl: gatePassBanner?.profileImg,
                size: 50,
                isCircular: true,
                borderWidth: 2,
                errorImage: Icons.person,
                onTap: ()=> CustomFullScreenImageViewer.show(context, gatePassBanner?.profileImg, errorImage: Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gatePassBanner?.name ?? 'Visitor Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gatePassBanner?.mobNumber ?? 'Mobile Number',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (gatePassBanner?.gender != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.white.withValues(alpha: 0.6), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Gender: ${gatePassBanner?.gender}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckInDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Check-in Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (gatePassBanner?.checkInCode != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Code: ${gatePassBanner?.checkInCode ?? 'N/A'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (gatePassBanner?.checkInCodeStart != null && gatePassBanner?.checkInCodeExpiry != null)
            Column(
              children: [
                _buildTimeRow('Valid From', gatePassBanner?.checkInCodeStart?.toLocal() ?? DateTime.now()),
                const SizedBox(height: 8),
                _buildTimeRow('Valid Until', gatePassBanner?.checkInCodeExpiry?.toLocal() ?? DateTime.now()),
              ],
            ),
          if (gatePassBanner?.isPreApproved == true)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Pre-approved',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, DateTime dateTime) {
    return Row(
      children: [
        Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.6), size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        Text(
          '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentManagement() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Apartment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter resident email ID',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.white.withValues(alpha: 0.6)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isAddingApartment ? null : () => _onApartmentAdd(_emailController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: _isAddingApartment
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                    ),
                  )
                      : const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApartmentsList() {
    final apartments = gatePassBanner?.gatepassAptDetails?.societyApartments ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Authorized Apartments (${apartments.length})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (apartments.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Center(
                child: Text(
                  'No apartments added yet',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: apartments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final apartment = apartments[index];
                return _buildApartmentCard(apartment);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildApartmentCard(SocietyApartment apartment) {
    final isRemoving = _removingApartmentId == apartment.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.home, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${apartment.societyBlock ?? 'Block'} - ${apartment.apartment ?? 'Apt'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEntryStatusColor(apartment.entryStatus?.status),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        apartment.entryStatus?.status ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${apartment.members?.length ?? 0} members',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: isRemoving ? null : () => _showRemoveDialog(apartment),
            icon: isRemoving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
                : const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildShareCode(){
    return // Check-in Code Section
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code, color: Colors.white70),
            const SizedBox(width: 8),
            const Text(
              'Check-in Code: ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              gatePassBanner?.checkInCode ?? 'N/A',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(
                Icons.share_rounded,
                color: Colors.white,
              ),
              onPressed: () => _shareCheckInCode(context),
            ),
          ],
        ),
      );
  }

  void _shareCheckInCode(BuildContext context) {
    Navigator.pushNamed(context, '/gate-pass-banner-screen', arguments: gatePassBanner);
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isDeleteLoading ? null : _showDeleteServiceDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              label: _isDeleteLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                ),
              )
                  : const Text(
                'Delete Entire Gatepass Service',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEntryStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green.withValues(alpha: 0.8);
      case 'pending':
        return Colors.orange.withValues(alpha: 0.8);
      case 'rejected':
        return Colors.red.withValues(alpha: 0.8);
      default:
        return Colors.grey.withValues(alpha: 0.8);
    }
  }

  void _showRemoveDialog(SocietyApartment apartment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Remove Apartment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to remove ${apartment.societyBlock} - ${apartment.apartment} from this gatepass service?',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onApartmentDelete(apartment.id!);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Remove', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Delete Gatepass Service',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'This action cannot be undone. Are you sure you want to delete this entire gatepass service?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onGatePassDelete();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Service', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}