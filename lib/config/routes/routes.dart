import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_connect/features/administration/screens/all_admin_screen.dart';
import 'package:gloria_connect/features/administration/screens/all_guard_screen.dart';
import 'package:gloria_connect/features/administration/screens/all_resident_screen.dart';
import 'package:gloria_connect/features/administration/screens/document_view_screen.dart';
import 'package:gloria_connect/features/administration/screens/manage_resident_screen.dart';
import 'package:gloria_connect/features/approval_screens/screens/delivery_approval_inside.dart';
import 'package:gloria_connect/features/approval_screens/screens/delivery_approval_screen.dart';
import 'package:gloria_connect/features/approval_screens/screens/verification_pending_screen.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/auth/screens/forgot_password_screen.dart';
import 'package:gloria_connect/features/auth/screens/login_screen.dart';
import 'package:gloria_connect/features/auth/screens/pdf_preview_screen.dart';
import 'package:gloria_connect/features/auth/screens/register_screen.dart';
import 'package:gloria_connect/features/auth/screens/splash_screen.dart';
import 'package:gloria_connect/features/check_in/screens/apartment_selection_screen.dart';
import 'package:gloria_connect/features/guard_entry/screens/asking_cab_approval_screen.dart';
import 'package:gloria_connect/features/guard_entry/screens/asking_delivery_approval_screen.dart';
import 'package:gloria_connect/features/check_in/screens/block_selection_screen.dart';
import 'package:gloria_connect/features/guard_entry/screens/asking_guest_approval_screen.dart';
import 'package:gloria_connect/features/guard_entry/screens/asking_other_approval_screen.dart';
import 'package:gloria_connect/features/guard_entry/screens/cab_approval_profile.dart';
import 'package:gloria_connect/features/guard_entry/screens/cab_more_option.dart';
import 'package:gloria_connect/features/guard_entry/screens/delivery_approval_profile.dart';
import 'package:gloria_connect/features/guard_entry/screens/delivery_more_option.dart';
import 'package:gloria_connect/features/check_in/screens/mobile_no_screen.dart';
import 'package:gloria_connect/features/guard_entry/screens/guest_approval_profile.dart';
import 'package:gloria_connect/features/guard_entry/screens/other_approval_profile.dart';
import 'package:gloria_connect/features/guard_entry/screens/other_more_option.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/screens/gate_pass_list_screen.dart';
import 'package:gloria_connect/features/guard_profile/screens/add_new_service_screen.dart';
import 'package:gloria_connect/features/guard_profile/screens/checkout_history_screen.dart';
import 'package:gloria_connect/features/guard_profile/screens/gate_pass_banner_screen.dart';
import 'package:gloria_connect/features/guard_waiting/models/entry.dart';
import 'package:gloria_connect/features/guard_waiting/screens/view_resident_approval.dart';
import 'package:gloria_connect/features/home/screens/admin_home_screen.dart';
import 'package:gloria_connect/features/guard_profile/screens/edit_profile_screen.dart';
import 'package:gloria_connect/features/home/screens/guard_home_screen.dart';
import 'package:gloria_connect/features/home/screens/resident_home_screen.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/features/invite_visitors/screens/cab_company_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/delivery_company_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/manual_contacts.dart';
import 'package:gloria_connect/features/invite_visitors/screens/contact_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/invite_guest_screen.dart';
import 'package:gloria_connect/features/administration/screens/guard_approval_screen.dart';
import 'package:gloria_connect/features/administration/screens/resident_approval_screen.dart';
import 'package:gloria_connect/features/auth/screens/complete_profile_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/other_preapprove_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/otp_banner.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/features/notice_board/screens/create_notice_page.dart';
import 'package:gloria_connect/features/notice_board/screens/general_notice_board_page.dart';
import 'package:gloria_connect/features/notice_board/screens/notice_board_page.dart';
import 'package:gloria_connect/features/notice_board/screens/notice_detail_page.dart';
import 'package:gloria_connect/features/resident_profile/screens/apartment_members_screen.dart';
import 'package:gloria_connect/features/setting/screens/change_password_screen.dart';
import 'package:gloria_connect/features/setting/screens/complaint_details_screen.dart';
import 'package:gloria_connect/features/setting/screens/complaint_form_screen.dart';
import 'package:gloria_connect/features/setting/screens/complaint_screen.dart';
import 'package:gloria_connect/features/setting/screens/setting_screen.dart';
import 'package:gloria_connect/utils/check_internet_connection.dart';
import 'package:gloria_connect/utils/gradient_color.dart';

class AppRoutes {

  static Route onGenerateRoutes(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
        return _materialRoute(const SplashScreen(), name: '/');
      case '/login':
        return _materialRoute(const LoginScreen(), name: '/login');
      case '/register':
        return _materialRoute(const RegisterScreen(), name: '/register');
      case '/forgot-password':
        return _materialRoute(const ForgotPasswordScreen(), name: '/forgot-password');
      case '/user-input':
        return _materialRoute(const CompleteProfileScreen(), name: '/user-input');
      case '/resident-approval':
        return _materialRoute(const ResidentApprovalScreen(), name: '/resident-approval');
      case '/guard-approval':
        return _materialRoute(const GuardApprovalScreen(), name: '/guard-approval');
      case '/guard-home':
        return _materialRoute(const GuardHomeScreen(), name: '/guard-home');
      case '/resident-home':
        return _materialRoute(const ResidentHomeScreen(), name: '/resident-home');
      case '/admin-home':
        return _materialRoute(const AdminHomeScreen(), name: '/admin-home');
      case '/invite-guest':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(InviteGuestScreen(data: args,), name: '/invite-guest');
        } else {
          return _materialRoute(const InviteGuestScreen(), name: '/invite-guest');
        }
      case '/add-guest':
        return _materialRoute(const ManualContacts(), name: '/add-guest');
      case '/contact-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(ContactsScreen(data: args,), name: '/contact-screen');
        } else {
          return _materialRoute(const ContactsScreen(), name: '/contact-screen');
        }
      case '/mobile-no-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(MobileNoScreen(entryType: args['entryType'],), name: '/mobile-no-screen');
        } else {
          return _materialRoute(const MobileNoScreen(), name: '/mobile-no-screen');
        }
      case '/block-selection-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(BlockSelectionScreen(entryType: args['entryType'], formData: args,), name: '/block-selection-screen');
        } else {
          return _materialRoute(const BlockSelectionScreen(), name: '/block-selection-screen');
        }
      case '/apartment-selection-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(ApartmentSelectionScreen(blockName: args['blockName'], entryType: args['entryType'], formData: args['formData'],), name: '/apartment-selection-screen');
        } else {
          return _materialRoute(const ApartmentSelectionScreen(), name: '/apartment-selection-screen');
        }
      case '/view-resident-approval':
        if (args != null && args is Entry) {
          return _materialRoute(ViewResidentApproval(data: args,), name: '/view-resident-approval');
        } else {
          return _materialRoute(const ViewResidentApproval(), name: '/view-resident-approval');
        }
      case '/ask-resident-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(AskingResidentApprovalScreen(deliveryData: args,), name: '/ask-resident-approval');
        } else {
          return _materialRoute(const AskingResidentApprovalScreen(), name: '/ask-resident-approval');
        }
      case '/delivery-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(DeliveryApprovalProfile(mobNumber: args['mobNumber'],), name: '/delivery-approval-profile');
        } else {
          return _materialRoute(const DeliveryApprovalProfile(), name: '/delivery-approval-profile');
        }
      case '/delivery-more-option':
        return _materialRoute(const DeliveryMoreOption(), name: '/delivery-more-option');
      case '/delivery-approval-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(DeliveryApprovalScreen(payload: args,), name: '/delivery-approval-screen');
        } else {
          return _materialRoute(const DeliveryApprovalScreen(), name: '/delivery-approval-screen');
        }
      case '/delivery-approval-inside':
        if (args != null && args is Entry) {
          return _materialRoute(DeliveryApprovalInside(payload: args,), name: '/delivery-approval-inside');
        } else {
          return _materialRoute(const DeliveryApprovalInside(), name: '/delivery-approval-inside');
        }
      case '/verification-pending-screen':
        return _materialRoute(const VerificationPendingScreen(), name: '/verification-pending-screen');
      case '/otp-banner':
        if (args != null && args is PreApprovedBanner) {
          return _materialRoute(OtpBanner(data: args,), name: '/otp-banner');
        } else {
          return _materialRoute(const OtpBanner(), name: '/otp-banner');
        }
      case '/delivery-company-screen':
        return _materialRoute(const DeliveryCompanyScreen(), name: '/delivery-company-screen');
      case '/cab-company-screen':
        return _materialRoute(const CabCompanyScreen(), name: '/cab-company-screen');
      case '/other-services-screen':
        return _materialRoute(const OtherPreapproveScreen(), name: '/other-services-screen');
      case '/cab-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(CabApprovalProfile(mobNumber: args['mobNumber'],), name: '/cab-approval-profile');
        } else {
          return _materialRoute(const CabApprovalProfile(), name: '/cab-approval-profile');
        }
      case '/guest-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(GuestApprovalProfile(mobNumber: args['mobNumber'],), name: '/guest-approval-profile');
        } else {
          return _materialRoute(const GuestApprovalProfile(), name: '/guest-approval-profile');
        }
      case '/other-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(OtherApprovalProfile(mobNumber: args['mobNumber'],), name: '/other-approval-profile');
        } else {
          return _materialRoute(const OtherApprovalProfile(), name: '/other-approval-profile');
        }
      case '/cab-more-option':
        return _materialRoute(const CabMoreOption(), name: '/cab-more-option');
      case '/other-more-option':
        if (args != null && args is bool) {
          return _materialRoute(OtherMoreOption(isAddService: args,), name: '/other-more-option');
        } else {
          return _materialRoute(const OtherMoreOption(), name: '/other-more-option');
        }
      case '/ask-cab-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(AskingCabApprovalScreen(deliveryData: args,), name: '/ask-cab-approval');
        } else {
          return _materialRoute(const AskingCabApprovalScreen(), name: '/ask-cab-approval');
        }
      case '/ask-other-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(AskingOtherApprovalScreen(deliveryData: args,), name: '/ask-other-approval');
        } else {
          return _materialRoute(const AskingOtherApprovalScreen(), name: '/ask-other-approval');
        }
      case '/ask-guest-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(AskingGuestApprovalScreen(deliveryData: args,), name: '/ask-guest-approval');
        } else {
          return _materialRoute(const AskingGuestApprovalScreen(), name: '/ask-guest-approval');
        }
      case '/edit-profile-screen':
        if (args != null && args is GetUserModel) {
          return _materialRoute(EditProfileScreen(data: args,), name: '/edit-profile-screen');
        } else {
          return _materialRoute(const EditProfileScreen(), name: '/edit-profile-screen');
        }
      case '/change-password':
        return _materialRoute(const ChangePasswordScreen(), name: '/change-password');
      case '/setting-screen':
        if (args != null && args is GetUserModel) {
          return _materialRoute(SettingScreen(data: args,), name: '/setting-screen');
        } else {
          return _materialRoute(const SettingScreen(), name: '/setting-screen');
        }
      case '/checkout-history-screen':
        return _materialRoute(const CheckoutHistoryScreen(), name: '/checkout-history-screen');
      case '/apartment-member-screen':
        return _materialRoute(const ApartmentMembersScreen(), name: '/apartment-member-screen');
      case '/all-resident-screen':
        return _materialRoute(const AllResidentScreen(), name: '/all-resident-screen');
      case '/all-guard-screen':
        return _materialRoute(const AllGuardScreen(), name: '/all-guard-screen');
      case '/all-admin-screen':
        return _materialRoute(const AllAdminScreen(), name: '/all-admin-screen');
      case '/manage-resident-screen':
        return _materialRoute(const ManageResidentScreen(), name: '/manage-resident-screen');
      case '/add-service-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(AddNewServiceScreen(formData: args,), name: '/add-service-screen');
        } else {
          return _materialRoute(const AddNewServiceScreen(), name: '/add-service-screen');
        }
      case '/gate-pass-list-screen':
        return _materialRoute(const GatePassListScreen(), name: '/gate-pass-list-screen');
      case '/gate-pass-banner-screen':
        if (args != null && args is GatePassBanner) {
          return _materialRoute(GatePassBannerScreen(data: args), name: '/gate-pass-banner-screen');
        } else {
          return _materialRoute(const GatePassBannerScreen(), name: '/gate-pass-banner-screen');
        }
      case '/document-view-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(DocumentViewScreen(documentUrl: args['documentUrl'], title: args['title'], isTenantAgreement: args['isTenantAgreement'], startDate: args['startDate'], endDate: args['endDate'],), name: '/document-view-screen');
        }else{
          return _materialRoute(const DocumentViewScreen(), name: '/document-view-screen');
        }
      case '/complaint-screen':
        if (args != null && args is bool) {
          return _materialRoute(ComplaintScreen(isAdmin: args,), name: '/complaint-screen');
        }else if (args != null && args is GetUserModel) {
          return _materialRoute(ComplaintScreen(data: args,), name: '/complaint-screen');
        }else{
          return _materialRoute(const ComplaintScreen(), name: '/complaint-screen');
        }
      case '/complaint-form-screen':
        return _materialRoute(const ComplaintFormScreen(), name: '/complaint-form-screen');
      case '/complaint-details-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _materialRoute(ComplaintDetailsScreen(data: args), name: '/complaint-details-screen');
        }else{
          return _materialRoute(const ComplaintDetailsScreen(), name: '/complaint-details-screen');
        }
      case '/notice-board-screen':
        return _materialRoute(const NoticeBoardPage(), name: '/notice-board-screen');
      case '/notice-board-details-screen':
        if (args != null && args is NoticeBoardModel) {
          return _materialRoute(NoticeDetailPage(data: args), name: '/notice-board-details-screen');
        }else{
          return _materialRoute(NoticeDetailPage(data: NoticeBoardModel(/* default values */)), name: '/notice-board-details-screen');
        }
      case '/create-notice-board-screen':
        return _materialRoute(const CreateNoticePage(), name: '/create-notice-board-screen');
      case '/general-notice-board-screen':
        return _materialRoute(const GeneralNoticeBoardPage(), name: '/general-notice-board-screen');
      case '/pdf-preview-screen':
        return _materialRoute(PdfPreviewScreen(file: args as File), name: '/pdf-preview-screen');
      case '/check-internet':
        return _materialRoute(const CheckInternetConnection(), name: '/check-internet');
      default:
        return _materialRoute(const SplashScreen(), name: '/');
    }
  }

  static Route<dynamic> _materialRoute(Widget view, {String? name}) {
    return MaterialPageRoute(
      builder: (_) => GradientColor(child: Builder(
        builder: (context) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.black.withOpacity(0.2), // Apply opacity to the color
            statusBarIconBrightness: Brightness.light, // Adjust for visibility
          ));
          return view;
        }
      )),
      settings: RouteSettings(name: name),
    );
  }

}