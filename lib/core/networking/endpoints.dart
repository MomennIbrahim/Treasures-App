abstract class EndPoints {
  static const String baseUrl = "https://hr.mnjiz.com";
  static const String login = "/api/auth/login";
  static const String verifyOtp = "/api/auth/verify-otp";
  static const String createPassword = "/api/auth/create-pin";
  static const String getProfile = "/api/auth/user-profile";
  static const String checkPin = "/api/auth/check-pin";
  static const String logout = "/api/auth/logout";
  static const String employeeStatistics =
      "/api/v1/attendance/employeeStatistics";
  static const String checkIn = "/api/v1/attendance/checkInOrOut";
  static const String vacationRequest = "/api/v1/vacation/request";
  static const String vacationTypes = "/api/v1/vacation/types";
  static const String permissionRequest = "/api/v1/permission-requests";
  static const String employeeAssignment = "/api/v1/employee-assignments";
  static const String assignmentTypes = "/api/v1/getAssignmentType";
  static const String myRequests = "/api/v1/requests";
  static const String reports = "/api/v1/attendance/monthly-weeks-report";
  static String cancelRequest({required int id}) =>
      "/api/v1/delete-requests/$id";
  static const String updateProfile = "/api/v1/update-profile";
  static const String changePinCode = "/api/auth/change-pin-code";
  static const String verifyPinCode = "/api/auth/confirm-pin-code";
  static const String ticketTypes = "/api/v1/ticketType";
  static const String sendTicket = "/api/v1/tickets/create";
  static const String tickets = "/api/v1/tickets";
  static String ticketDetails(int id) => "/api/v1/tickets/$id";
  static String replyOnTicket(int id) => "/api/v1/tickets/reply/$id"; 
  static const String forgetPassword = "/api/auth/forgot-password/send-otp";
  static const String verifyForgetPassword =
      "/api/auth/forgot-password/verify-otp";
  static const String myCustodyRequests = "/api/v1/custody-requests/approve";
  static const String custodyRequests = "/api/v1/custody-requests";
  static const String custodyTypes = "/api/v1/custody-requests/custody_type";
  static const String myCustodyRequestsSearch = "/api/v1/custody-requests/search";
  static const String violations = "/api/v1/violations";
  static String requestAppeal(int id) => "/api/v1/violations/$id/appeal";
  static const String alerts = "/api/v1/alerts";
  static const String advances = "/api/v1/advances";
}
