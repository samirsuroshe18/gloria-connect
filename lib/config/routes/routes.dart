import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_connect/features/admin_profile/screens/admin_edit_profile_screen.dart';
import 'package:gloria_connect/features/admin_profile/screens/admin_members_screen.dart';
import 'package:gloria_connect/features/administration/screens/all_admin_screen.dart';
import 'package:gloria_connect/features/administration/screens/all_guard_screen.dart';
import 'package:gloria_connect/features/administration/screens/all_resident_screen.dart';
import 'package:gloria_connect/features/administration/screens/document_view_screen.dart';
import 'package:gloria_connect/features/administration/screens/manage_resident_screen.dart';
import 'package:gloria_connect/features/approval_screens/screens/delivery_approval_inside.dart';
import 'package:gloria_connect/features/approval_screens/screens/delivery_approval_screen.dart';
import 'package:gloria_connect/features/approval_screens/screens/verification_pending_screen.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/guard_duty/screens/checkout_entry_screen.dart';
import 'package:gloria_connect/features/guard_duty/screens/duty_login_screen.dart';
import 'package:gloria_connect/features/auth/screens/forgot_password_screen.dart';
import 'package:gloria_connect/features/auth/screens/login_screen.dart';
import 'package:gloria_connect/features/auth/screens/pdf_preview_screen.dart';
import 'package:gloria_connect/features/auth/screens/register_screen.dart';
import 'package:gloria_connect/features/auth/screens/splash_screen.dart';
import 'package:gloria_connect/features/check_in/screens/apartment_selection_screen.dart';
import 'package:gloria_connect/features/guard_duty/screens/guard_report.dart';
import 'package:gloria_connect/features/guard_duty/screens/shift_history_screen.dart';
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
import 'package:gloria_connect/features/guard_profile/screens/guard_edit_profile_screen.dart';
import 'package:gloria_connect/features/home/screens/guard_home_screen.dart';
import 'package:gloria_connect/features/home/screens/landing_screen.dart';
import 'package:gloria_connect/features/home/screens/resident_home_screen.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/features/invite_visitors/screens/cab_company_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/delivery_company_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/invite_visitors_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/manual_contacts.dart';
import 'package:gloria_connect/features/invite_visitors/screens/contact_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/invite_guest_screen.dart';
import 'package:gloria_connect/features/administration/screens/guard_approval_screen.dart';
import 'package:gloria_connect/features/administration/screens/resident_approval_screen.dart';
import 'package:gloria_connect/features/auth/screens/complete_profile_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/other_preapprove_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/otp_banner.dart';
import 'package:gloria_connect/features/my_visitors/screens/my_visitors_screen.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/features/notice_board/screens/create_notice_page.dart';
import 'package:gloria_connect/features/notice_board/screens/general_notice_board_page.dart';
import 'package:gloria_connect/features/notice_board/screens/notice_board_page.dart';
import 'package:gloria_connect/features/notice_board/screens/notice_detail_page.dart';
import 'package:gloria_connect/features/resident_profile/screens/resident_members_screen.dart';
import 'package:gloria_connect/features/resident_profile/screens/resident_edit_profile_screen.dart';
import 'package:gloria_connect/features/setting/screens/change_password_screen.dart';
import 'package:gloria_connect/features/setting/screens/complaint_details_screen.dart';
import 'package:gloria_connect/features/setting/screens/complaint_form_screen.dart';
import 'package:gloria_connect/features/setting/screens/complaint_screen.dart';
import 'package:gloria_connect/features/setting/screens/setting_screen.dart';
import 'package:gloria_connect/common_widgets/check_internet_connection.dart';
import 'package:gloria_connect/common_widgets/error_screen.dart';
import 'package:gloria_connect/common_widgets/gradient_color.dart';

class AppRoutes {

  static Route onGenerateRoutes(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
        return _animatedRoute(const SplashScreen(), name: '/');
      case '/login':
        return _animatedRoute(const LoginScreen(), name: '/login');
      case '/duty-login':
        return _animatedRoute(const DutyLoginScreen(), name: '/duty-login');
      case '/register':
        return _animatedRoute(const RegisterScreen(), name: '/register');
      case '/forgot-password':
        return _animatedRoute(const ForgotPasswordScreen(), name: '/forgot-password');
      case '/user-input':
        return _animatedRoute(const CompleteProfileScreen(), name: '/user-input');
      case '/landing-screen':
        return _animatedRoute(const LandingScreen(), name: '/landing-screen');
      case '/visitors-screen':
        return _animatedRoute(const MyVisitorsScreen(), name: '/visitors-screen');
      case '/pre-approve-screen':
        return _animatedRoute(const InviteVisitorsScreen(), name: '/pre-approve-screen');
      case '/resident-approval':
        return _animatedRoute(const ResidentApprovalScreen(), name: '/resident-approval');
      case '/guard-approval':
        return _animatedRoute(const GuardApprovalScreen(), name: '/guard-approval');
      case '/guard-home':
        return _animatedRoute(const GuardHomeScreen(), name: '/guard-home');
      case '/resident-home':
        return _animatedRoute(const ResidentHomeScreen(), name: '/resident-home');
      case '/admin-home':
        return _animatedRoute(const AdminHomeScreen(), name: '/admin-home');
      case '/invite-guest':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(InviteGuestScreen(data: args,), name: '/invite-guest');
        } else {
          return _animatedRoute(const InviteGuestScreen(), name: '/invite-guest');
        }
      case '/add-guest':
        return _animatedRoute(const ManualContacts(), name: '/add-guest');
      case '/contact-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(ContactsScreen(data: args,), name: '/contact-screen');
        } else {
          return _animatedRoute(const ContactsScreen(), name: '/contact-screen');
        }
      case '/mobile-no-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(MobileNoScreen(entryType: args['entryType'], categoryOption: args['categoryOption'],), name: '/mobile-no-screen');
        } else {
          return _animatedRoute(const MobileNoScreen(), name: '/mobile-no-screen');
        }
      case '/block-selection-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(BlockSelectionScreen(entryType: args['entryType'], formData: args, categoryOption: args['categoryOption'],), name: '/block-selection-screen');
        } else {
          return _animatedRoute(const BlockSelectionScreen(), name: '/block-selection-screen');
        }
      case '/apartment-selection-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(ApartmentSelectionScreen(blockName: args['blockName'], entryType: args['entryType'], formData: args['formData'], categoryOption: args['categoryOption']), name: '/apartment-selection-screen');
        } else {
          return _animatedRoute(const ApartmentSelectionScreen(), name: '/apartment-selection-screen');
        }
      case '/view-resident-approval':
        if (args != null && args is VisitorEntries) {
          return _animatedRoute(ViewResidentApproval(data: args,), name: '/view-resident-approval');
        } else {
          return _animatedRoute(const ViewResidentApproval(), name: '/view-resident-approval');
        }
      case '/ask-resident-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(AskingResidentApprovalScreen(deliveryData: args,), name: '/ask-resident-approval');
        } else {
          return _animatedRoute(const AskingResidentApprovalScreen(), name: '/ask-resident-approval');
        }
      case '/delivery-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(DeliveryApprovalProfile(mobNumber: args['mobNumber'],), name: '/delivery-approval-profile');
        } else {
          return _animatedRoute(const DeliveryApprovalProfile(), name: '/delivery-approval-profile');
        }
      case '/delivery-more-option':
        return _animatedRoute(const DeliveryMoreOption(), name: '/delivery-more-option');
      case '/delivery-approval-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(DeliveryApprovalScreen(payload: args,), name: '/delivery-approval-screen');
        } else {
          return _animatedRoute(const DeliveryApprovalScreen(), name: '/delivery-approval-screen');
        }
      case '/delivery-approval-inside':
        if (args != null && args is VisitorEntries) {
          return _animatedRoute(DeliveryApprovalInside(payload: args,), name: '/delivery-approval-inside');
        } else {
          return _animatedRoute(const DeliveryApprovalInside(), name: '/delivery-approval-inside');
        }
      case '/verification-pending-screen':
        return _animatedRoute(const VerificationPendingScreen(), name: '/verification-pending-screen');
      case '/otp-banner':
        if (args != null && args is PreApprovedBanner) {
          return _animatedRoute(OtpBanner(data: args,), name: '/otp-banner');
        } else {
          return _animatedRoute(const OtpBanner(), name: '/otp-banner');
        }
      case '/delivery-company-screen':
        return _animatedRoute(const DeliveryCompanyScreen(), name: '/delivery-company-screen');
      case '/cab-company-screen':
        return _animatedRoute(const CabCompanyScreen(), name: '/cab-company-screen');
      case '/other-services-screen':
        return _animatedRoute(const OtherPreapproveScreen(), name: '/other-services-screen');
      case '/cab-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(CabApprovalProfile(mobNumber: args['mobNumber'],), name: '/cab-approval-profile');
        } else {
          return _animatedRoute(const CabApprovalProfile(), name: '/cab-approval-profile');
        }
      case '/guest-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(GuestApprovalProfile(mobNumber: args['mobNumber'],), name: '/guest-approval-profile');
        } else {
          return _animatedRoute(const GuestApprovalProfile(), name: '/guest-approval-profile');
        }
      case '/other-approval-profile':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(OtherApprovalProfile(mobNumber: args['mobNumber'], categoryOption: args['categoryOption']), name: '/other-approval-profile');
        } else {
          return _animatedRoute(const OtherApprovalProfile(), name: '/other-approval-profile');
        }
      case '/cab-more-option':
        return _animatedRoute(const CabMoreOption(), name: '/cab-more-option');
      case '/other-more-option':
        if (args != null && args is bool) {
          return _animatedRoute(OtherMoreOption(isAddService: args,), name: '/other-more-option');
        } else {
          return _animatedRoute(const OtherMoreOption(), name: '/other-more-option');
        }
      case '/ask-cab-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(AskingCabApprovalScreen(deliveryData: args,), name: '/ask-cab-approval');
        } else {
          return _animatedRoute(const AskingCabApprovalScreen(), name: '/ask-cab-approval');
        }
      case '/ask-other-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(AskingOtherApprovalScreen(deliveryData: args,), name: '/ask-other-approval');
        } else {
          return _animatedRoute(const AskingOtherApprovalScreen(), name: '/ask-other-approval');
        }
      case '/ask-guest-approval':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(AskingGuestApprovalScreen(deliveryData: args,), name: '/ask-guest-approval');
        } else {
          return _animatedRoute(const AskingGuestApprovalScreen(), name: '/ask-guest-approval');
        }
      case '/edit-profile-screen':
        if (args != null && args is GetUserModel) {
          return _animatedRoute(GuardEditProfileScreen(data: args,), name: '/edit-profile-screen');
        } else {
          return _animatedRoute(const GuardEditProfileScreen(), name: '/edit-profile-screen');
        }
      case '/admin-edit-profile-screen':
        if (args != null && args is GetUserModel) {
          return _animatedRoute(AdminEditProfileScreen(data: args,), name: '/admin-edit-profile-screen');
        } else {
          return _animatedRoute(const AdminEditProfileScreen(), name: '/admin-edit-profile-screen');
        }
      case '/resident-edit-profile-screen':
        if (args != null && args is GetUserModel) {
          return _animatedRoute(ResidentEditProfileScreen(data: args,), name: '/resident-edit-profile-screen');
        } else {
          return _animatedRoute(const ResidentEditProfileScreen(), name: '/resident-edit-profile-screen');
        }
      case '/change-password':
        return _animatedRoute(const ChangePasswordScreen(), name: '/change-password');
      case '/setting-screen':
        if (args != null && args is GetUserModel) {
          return _animatedRoute(SettingScreen(data: args,), name: '/setting-screen');
        } else {
          return _animatedRoute(const SettingScreen(), name: '/setting-screen');
        }
      case '/checkout-history-screen':
        return _animatedRoute(const CheckoutHistoryScreen(), name: '/checkout-history-screen');
      case '/apartment-member-screen':
        return _animatedRoute(const ApartmentMembersScreen(), name: '/apartment-member-screen');
      case '/admin-member-screen':
        return _animatedRoute(const AdminMembersScreen(), name: '/admin-member-screen');
      case '/all-resident-screen':
        return _animatedRoute(const AllResidentScreen(), name: '/all-resident-screen');
      case '/all-guard-screen':
        return _animatedRoute(const AllGuardScreen(), name: '/all-guard-screen');
      case '/all-admin-screen':
        return _animatedRoute(const AllAdminScreen(), name: '/all-admin-screen');
      case '/manage-resident-screen':
        return _animatedRoute(const ManageResidentScreen(), name: '/manage-resident-screen');
      case '/add-service-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(AddNewServiceScreen(formData: args,), name: '/add-service-screen');
        } else {
          return _animatedRoute(const AddNewServiceScreen(), name: '/add-service-screen');
        }
      case '/gate-pass-list-screen':
        return _animatedRoute(const GatePassListScreen(), name: '/gate-pass-list-screen');
      case '/gate-pass-banner-screen':
        if (args != null && args is GatePassBanner) {
          return _animatedRoute(GatePassBannerScreen(data: args), name: '/gate-pass-banner-screen');
        } else {
          return _animatedRoute(const GatePassBannerScreen(), name: '/gate-pass-banner-screen');
        }
      case '/document-view-screen':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(DocumentViewScreen(documentUrl: args['documentUrl'], title: args['title'], isTenantAgreement: args['isTenantAgreement'], startDate: args['startDate'], endDate: args['endDate'],), name: '/document-view-screen');
        }else{
          return _animatedRoute(const DocumentViewScreen(), name: '/document-view-screen');
        }
      case '/complaint-screen':
        if (args != null && args is bool) {
          return _animatedRoute(ComplaintScreen(isAdmin: args,), name: '/complaint-screen');
        }else if (args != null && args is GetUserModel) {
          return _animatedRoute(ComplaintScreen(data: args,), name: '/complaint-screen');
        }else{
          return _animatedRoute(const ComplaintScreen(), name: '/complaint-screen');
        }
      case '/complaint-form-screen':
        return _animatedRoute(const ComplaintFormScreen(), name: '/complaint-form-screen');
      case '/complaint-details-screen':
        return _animatedRoute(ComplaintDetailsScreen(data: args as Map<String, dynamic>), name: '/complaint-details-screen');
      case '/notice-board-screen':
        return _animatedRoute(const NoticeBoardPage(), name: '/notice-board-screen');
      case '/notice-board-details-screen':
        if (args != null && args is Notice) {
          return _animatedRoute(NoticeDetailPage(notice: args), name: '/notice-board-details-screen');
        }else{
          return _animatedRoute(NoticeDetailPage(notice: Notice(/* default values */)), name: '/notice-board-details-screen');
        }
      case '/create-notice-board-screen':
        return _animatedRoute(const CreateNoticePage(), name: '/create-notice-board-screen');
      case '/general-notice-board-screen':
        return _animatedRoute(const GeneralNoticeBoardPage(), name: '/general-notice-board-screen');
      case '/pdf-preview-screen':
        return _animatedRoute(PdfPreviewScreen(file: args as File), name: '/pdf-preview-screen');
      case '/check-internet':
        return _animatedRoute(const CheckInternetConnection(), name: '/check-internet');
      case '/error':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(
              ErrorScreen(
                errorType: args['errorType'] ?? 'unknown',
                message: args['message'] ?? 'An error occurred',
                showLoginOption: args['showLoginOption'] ?? false,
                showRetryOption: args['showRetryOption'] ?? false,
                onRetry: args['onRetry'],
              ),
              name: '/error'
          );
        } else {
          // Default error screen if no arguments provided
          return _animatedRoute(
              const ErrorScreen(
                errorType: 'unknown',
                message: 'An unexpected error occurred',
                showLoginOption: true,
                showRetryOption: false,
              ),
              name: '/error'
          );
        }
      case '/guard-report':
        return _animatedRoute(GuardReport(guardId: args as String), name: '/guard-report');
      case '/day-checkout-entry':
        return _animatedRoute(CheckoutEntryScreen(checkinTime: args as DateTime), name: '/day-checkout-entry');
      case '/shift-history-screen':
        return _animatedRoute(ShiftHistoryScreen(guardId: args as String,), name: '/shift-history-screen');
      default:
        return _animatedRoute(const SplashScreen(), name: '/');
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

  // static Route<dynamic> _animatedRoute(Widget page, {String? name}) {
  //   return PageRouteBuilder(
  //     settings: RouteSettings(name: name),
  //     transitionDuration: const Duration(milliseconds: 300),
  //     reverseTransitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //         statusBarColor: Colors.black.withOpacity(0.2), // Apply opacity to the color
  //         statusBarIconBrightness: Brightness.light, // Adjust for visibility
  //       ));
  //       return page;
  //     },
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(1.0, 0.0); // Slide from right
  //       const end = Offset.zero;
  //       const curve = Curves.easeInOut;
  //
  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //       var offsetAnimation = animation.drive(tween);
  //
  //       return SlideTransition(position: offsetAnimation, child: child);
  //     },
  //   );
  // }

  static Route<dynamic> _animatedRoute(Widget view, {String? name}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name),
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => GradientColor(
        child: Builder(
          builder: (context) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.black.withOpacity(0.2),
              statusBarIconBrightness: Brightness.light,
            ));
            return view;
          },
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

}