import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

Dio _dio = Dio();

// COMMON STRINGS
String _dbPushUser = 'dataapi_full';
String _dbPushPassword = 'Jerifx1000!';

String _base64authPush = base64.encode(utf8.encode(_dbPushUser + ':' + _dbPushPassword));
String _basicAuthHeaderPush = 'Basic ' + _base64authPush;

String _dbReadUser = 'dataapi_readonly';
String _dbReadPassword = 'jerifx!';

String _base64authRead = base64.encode(utf8.encode(_dbReadUser + ':' + _dbReadPassword));
String _basicAuthHeaderRead = 'Basic ' + _base64authRead;

// DATABASE URL
String _urlMain = 'https://7m4tq0frmc.execute-api.us-east-1.amazonaws.com/api/fmi/data/v1/databases/';
String _databaseName = 'MyEmployeesCRM-v01';

// LAYOUTS
String _webappSalesContactLayout = '/layouts/WebappSalesContacts';
String _webappCMLayout = '/layouts/webappCM';
String _webappNamesLayout = '/layouts/webappNames';
String _webappSalesOrders = '/layouts/webappSalesOrders';
String _webappLog = '/layouts/webapp_log';
String _webappOrderItems = '/layouts/webappOrderitems';

// SESSION URL
String _tokenUrl = _urlMain + _databaseName + '/sessions';

// SPECIFIC FIND URLS
String _webappSalesContactFindUrl = _urlMain + _databaseName + _webappSalesContactLayout + '/_find';
String _webappCMFindUrl = _urlMain + _databaseName + _webappCMLayout + '/_find';
String _webappNamesFindUrl = _urlMain + _databaseName + _webappNamesLayout + '/_find';
String _webappOrderItemsFindUrl = _urlMain + _databaseName + _webappOrderItems + '/_find';

// SPECIFIC WRITE URLS
String _webappNamesWriteUrl = _urlMain + _databaseName + _webappNamesLayout + '/records';
String _webappSalesContactWriteUrl = _urlMain + _databaseName + _webappSalesContactLayout + '/records';
String _webappLogWriteUrl = _urlMain + _databaseName + _webappLog + '/records';

// SPECIFIC SCRIPT URLS
String _webappSalesOrderRunScript = _urlMain + _databaseName + _webappSalesContactLayout + '/script/webapp_submitNamesWorkorder';
String _webappPasswordRecoveryScript = _urlMain + _databaseName + _webappSalesContactLayout + '/script/webapp_sendPassword';
String _webappSendEmailScript = _urlMain + _databaseName + _webappSalesOrders + '/script/webapp_sendEmail';


class Database {

  Future getOnline() async {
    var url = Uri.parse('https://cors-anywhere.herokuapp.com/https://example.com/whatsit/create');
    var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }

// CHECK INTERNET CONNECTION
  Future <bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      }
    } on SocketException catch (_) {
//    print('not connected');
      return false;
    }
//  print('connected');
    return true;

  }

  // GET TOKEN
  Future <String> getToken() async {
    String _token = '';

    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers["authorization"] = _basicAuthHeaderRead;

    // GET TOKEN
    var tokenResponse = await _dio.post(_tokenUrl);
    _token = tokenResponse.data['response']['token'].toString();

    return _token;
  }

// GET PUSH TOKEN
  Future <String> getPushToken() async {
    String _token = '';

    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers["authorization"] = _basicAuthHeaderPush;

    // GET TOKEN
    var tokenResponse = await _dio.post(_tokenUrl);
    _token = tokenResponse.data['response']['token'].toString();

    return _token;
  }

  void getHttp() async {
    try {
      var response = await _dio.get('http://www.google.com');
      print(response);
    } catch (e) {
      print(e);
    }
  }

// CHECK ACCOUNT FOR FM LOGIN
//   Future <String> checkLoginStatus(String username, String password) async {
//     String _quotedUsername = '"' + username + '"';
//     String quotedPassword = '"' + password + '"';
//
//     try {
//       final String _newToken = await getToken();
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newToken;
//
//       try {
//         await _dio.post(_webappSalesContactFindUrl,
//             data: {"query": [{"username": "=$_quotedUsername", "password": "=$quotedPassword"}]}
//         );
//
//         try{
//           await _dio.post(_webappSalesContactFindUrl,
//               data: {"query": [{"username": "=$_quotedUsername", "password": "=$quotedPassword", "Status": "=Active"}]}
//           );
//
//           try{
//             await _dio.post(_webappSalesContactFindUrl,
//                 data: {"query": [{"username": "=$_quotedUsername", "password": "=$quotedPassword", "Sales_CustomerMaster::status": "=Active"}]}
//             );
//
//           } catch(e){
//
//             try{
//               await _dio.post(_webappSalesContactFindUrl,
//                   data: {"query": [{"username": "=$_quotedUsername", "password": "=$quotedPassword", "Sales_CustomerMaster::status": "=Special"}]}
//               );
//
//             } catch(e) {
//
//               try{
//                 await _dio.post(_webappSalesContactFindUrl,
//                     data: {"query": [{"username": "=$_quotedUsername", "password": "=$quotedPassword", "Sales_CustomerMaster::status": "=Qtr"}]}
//                 );
//
//               } catch(e){
//
//
//                 log(e.toString());
//                 return 'Account Not Active';
//
//               }
//             }
//           }
//         } catch(e){
//           return 'Account Not Active';
//         }
//       } catch (e) {
//         log(e.toString());
//         return 'Account Credentials Not Correct';
//       }
//     } catch (e) {
//
//       return 'Get Token Failure';
//     }
//
//     return 'Ready';
//   }
//
//
// // GET USERDATA FROM FILEMAKER AND MAKE LIST OF LOCATIONS
//   Future <List<FmUserData>> getFmData(String username, String password) async {
//
//     final List <FmUserData> _fmUserDataList = [];
//     late Response _user;
//     final String _quotedUsername = '"' + username + '"';
//     final String quotedPassword = '"' + password + '"';
//
//     final String _newToken = await getToken();
//
//     //GET USER DATA BASED ON USERNAME AND PASSWORD
//     _dio.options.headers['content-Type'] = 'application/json';
//     _dio.options.headers["authorization"] = 'Bearer ' + _newToken;
//
//     try {
//       _user = await _dio.post(_webappSalesContactFindUrl,
//
//           data: {"query": [{"username": "=$_quotedUsername", "password": "=$quotedPassword"}]}
//       );
//
//       // GET MULTIPLE RECORDS
//       dynamic _userJsonList = _user.data['response']['data'];
//       for (var _data in _userJsonList){
//         _fmUserDataList.add(FmUserData.fromJson(_data));
//       }
//
//     } catch (e) {
//       log(e.toString());
//       print('error getting FM User Data');
//     }
//
//     // RETURN MULTIPLE RECORDS
//     return _fmUserDataList;
//   }
//
// // GET PAST WINNER LIST FOR WINNER HOME
//   Future<List<MonthlyWinner>> getNames(String fkCustomerMaster) async {
//     List<MonthlyWinner> _namesList = <MonthlyWinner>[];
//
//     final String _newToken = await getToken();
//
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newToken;
//
//       Response namesResponse = await _dio.post(
//           _webappCMFindUrl,
//           data: {"query": [{"__pk_customerMaster": "=$fkCustomerMaster"}]}
//       );
//
//       if (namesResponse.statusCode == 200) {
//         dynamic namesJson = namesResponse.data['response']['data'][0]['portalData']['Names_Portal'];
//         for (var namesJson in namesJson) {
//           _namesList.add( MonthlyWinner.fromJson(namesJson) );
//         }
//       }
//     } catch (e){
//       print('error getting names list');
//
//     }
//     return _namesList;
//   }
//
// // CHECK FOR ANY TITLES FOR THIS USER
//   Future <List<AwardTitlesAvailable>> checkForActiveAwardTitles(String fkCustomerMaster, String company) async {
//
//     List<AwardTitlesAvailable> awardTitlesAvailable = <AwardTitlesAvailable>[];
//     dynamic activeProgramsJson;
//     Response fkCustomerMasterResponse;
//
//     final String _newToken = await getToken();
//
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newToken;
//
//       fkCustomerMasterResponse = await _dio.post(
//           _webappCMFindUrl,
//           data: {"query": [{"__pk_customermaster": "=$fkCustomerMaster"}]}
//       );
//
//       activeProgramsJson = fkCustomerMasterResponse.data['response']['data'][0]['portalData']['TItles_Portal'];
//
//       for (var list in activeProgramsJson) {
//         awardTitlesAvailable.add(AwardTitlesAvailable.fromJson(list, company));
//       }
//     } catch(e) {
//
//
//       awardTitlesAvailable = [];
//       print('error getting award titles in dash');
//       log(e.toString());
//       return awardTitlesAvailable;
//
//     }
//
//     return awardTitlesAvailable;
//   }
//
//
// // CHECK NUMBER OF PLAQUES USED
//   Future checkNumberOfPlaquesUsed(String token, String orderPk, String month, String namePlateSize) async {
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + token;
//
//       Response response = await _dio.post(_webappNamesFindUrl,
//           data: {"query":[{"_fk_order": "=$orderPk", "month": "=$month", "nameplateSize": "=$namePlateSize"}]}
//       );
//
//       return response.data['response']['data'].length;
//
//     } catch (e) {
//
//       // print('did not find any plaques used for $orderPk');
//       return 0;
//
//     }
//
//     // return _numberUsed;
//   }
// // CHECK ACRYLICS USED
//   Future checkAcrylics(String token, String orderPk, String month, String pkTitle) async {
//
//     try {
//       // USE FK ORDER AND MONTH TO FIND NUMBER OF TITLES LEFT
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + token;
//
//       await _dio.post(_webappNamesFindUrl,
//           data: {"query":[{"_fk_order": "=$orderPk", "month": "=$month", "title": "$pkTitle"}]}
//       );
//
//       return false;
//
//     } catch (e) {
//
//       return true;
//
//     }
//   }
//
//
//
// // SEND PERPETUAL WINNERS
//   Future <void> sendPerpetualNames(String username, String password, String month, String winnerName, String titleName, String titleId, String nameplateSize,String  orderPK, String contactUUID) async {
//
//     String quotedUsername = '"' + username + '"';
//     String quotedPassword = '"' + password + '"';
//
//     final String _newPushToken = await getPushToken();
//
//     //GET USER DATA BASED ON USERNAME AND PASSWORD
//     _dio.options.headers['content-Type'] = 'application/json';
//     _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//     dynamic fkCustomerMaster = '';
//     int code = 0;
//     late Response fkResponse;
//
//     try {
//       fkResponse = await _dio.post(_webappSalesContactFindUrl,
//           data: {"query": [{"username": "=$quotedUsername", "password": "=$quotedPassword"}]}
//       );
//       code = fkResponse.statusCode!;
//     } catch (e) {
//       print('no found user in sending names');
//     }
//
//     if(code == 200){
//       fkCustomerMaster = fkResponse.data['response']['data'][0]['fieldData']['_fk_CustomerMaster'];
//     }
//
//     try{
//       await _dio.post(_webappNamesWriteUrl,
//           data: {
//             "fieldData":
//             {
//               "_fk_customerMaster": fkCustomerMaster,
//               "_fk_order": orderPK,
//               "name": winnerName,
//               "::title": titleName,
//               "title": titleId,
//               "nameplateSize": nameplateSize,
//               "month": month,
//             }
//           }
//       );
//     } catch(e) {
//
//       print(e);
//       print('error sending name to get recordId');
//
//     }
//
//   }
//
// // SEND MONTHLY PLAQUE WINNERS
//   Future <void> sendMonthlyPlaqueWinners(String pushToken, String fkCustomerMaster, String month, String winnerName, String titleName, String titleId, String nameplateSize,String  orderPK, String contactUUID) async {
//     final String _newPushToken = await getPushToken();
//
//     try{
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//
//       await _dio.post(_webappNamesWriteUrl,
//           data: {
//             "fieldData":
//             {
//               "_fk_customerMaster": fkCustomerMaster,
//               "_fk_order": orderPK,
//               "name": winnerName,
//               "::title": titleName,
//               "title": titleId,
//               "nameplateSize": nameplateSize,
//               "month": month,
//             }
//           }
//       );
//     } catch(e) {
//
//       log(e.toString());
//       print('error sending monthly winner to get recordId');
//
//     }
//
//   }
//
// // SEND QUARTERLY WINNERS
//   Future <void> sendQuarterlyNames(String username, String password, String contactUUID, String month, String winnerName, String titleName, String titleId, String nameplateSize, String orderPK) async {
//
//     String quotedUsername = '"' + username + '"';
//     String quotedPassword = '"' + password + '"';
//
//     final String _newPushToken = await getPushToken();
//
//     //GET USER DATA BASED ON USERNAME AND PASSWORD
//     _dio.options.headers['content-Type'] = 'application/json';
//     _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//     dynamic fkCustomerMaster = '';
//     int code = 0;
//     late Response fkResponse;
//
//     try {
//       fkResponse = await _dio.post(_webappSalesContactFindUrl,
//           data: {"query": [{"username": "=$quotedUsername", "password": "=$quotedPassword"}]}
//       );
//       code = fkResponse.statusCode!;
//     } catch (e) {
//       print('no found user in sending names');
//     }
//
//     if(code == 200){
//       fkCustomerMaster = fkResponse.data['response']['data'][0]['fieldData']['_fk_CustomerMaster'];
//     }
//
//     Response addRecordResponse = await _dio.post(_webappNamesWriteUrl,
//         data: {
//           "fieldData":
//           {
//             "_fk_customerMaster": fkCustomerMaster,
//             "_fk_order": orderPK,
//             "name": winnerName,
//             "::title": titleName,
//             "title": titleId,
//             "nameplateSize": nameplateSize,
//             "month": month,
//             "product_type": "Quarterly",
//           }
//         }
//     );
//
//     print(addRecordResponse);
//
//   }
//
// // SEND WORKORDER TO PRODUCTION
//   Future <void> createWorkOrder(String orderPk) async {
//
//     late Response runScriptResponse;
//     final String _newPushToken = await getPushToken();
//
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//       runScriptResponse = await _dio.get(_webappSalesOrderRunScript,
//           queryParameters: {
//             "script.param": orderPk
//           }
//       );
//
//     } catch (e){
//       print(e);
//       print('error running script for work order');
//     }
//
//     print(runScriptResponse.toString() + ' response from work order script');
//   }
//
//
//
// // GET TRACKING INFORMATION FOR PAST WINNERS
//   Future <String> getTrackingInfo(String token, String orderNumber) async {
//     String trackingNumber = 'Not Shipped Yet';
//     late Response response;
//
//     //GET USER DATA BASED ON USERNAME AND PASSWORD
//     _dio.options.headers['content-Type'] = 'application/json';
//     _dio.options.headers["authorization"] = 'Bearer ' + token;
//
//     try {
//       response = await _dio.post(_webappOrderItemsFindUrl,
//           data: {"query": [{"Sales_Orders::Order Number": "=$orderNumber"}]}
//       );
//
//       trackingNumber = response.data['response']['data'][0]['fieldData']['Sales_Orders_Shipments::trackingNumber'];
//
//     } catch (e) {
//       // log(e.toString());
//       return trackingNumber;
//     }
//
//     return trackingNumber;
//   }
//
// // GET FKCM BEFORE CHANGING PASSWORD
//   Future <bool> checkDatabasePassword(String username, String password) async {
//
//     String quotedUsername = '"' + username + '"';
//     String quotedPassword = '"' + password + '"';
//
//     final String _newToken = await getToken();
//
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newToken;
//
//       await _dio.post(_webappSalesContactFindUrl,
//
//           data: {"query": [{"username": "=$quotedUsername", "password": "=$quotedPassword"}]}
//       );
//
//     } catch (e) {
//       return false;
//     }
//
//     return true;
//
//   }
//
// // CHANGE DATABASE PASSWORD
//   Future <bool> databasePasswordChange(String username, String password, String newPassword) async {
//
//     String quotedUsername = '"' + username + '"';
//     String quotedPassword = '"' + password + '"';
//     String quotedNewPassword = '"' + newPassword + '"';
//
//     late Response fkResponse;
//     late Response recordResponse;
//
//     List recordIdList = [];
//     List records = [];
//     List contactUuidList = [];
//     List contactUuids = [];
//
//     final String _newPushToken = await getPushToken();
//
//     //GET USER DATA BASED ON USERNAME AND PASSWORD
//     _dio.options.headers['content-Type'] = 'application/json';
//     _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//     try {
//       fkResponse = await _dio.post(_webappSalesContactFindUrl,
//           data: {"query": [{"username": "=$quotedUsername", "password": "=$quotedPassword", "Status": "=Active"}]}
//       );
//
//       // GET ALL PK ID NUMBERS TO ADD TRANSACTIONS TO ALL
//       contactUuidList = fkResponse.data['response']['data'];
//
//       for(var list in contactUuidList){
//         String eachContact = list['fieldData']['__pk_ID_Contacts'];
//         contactUuids.add(eachContact);
//       }
//
//     } catch (e) {
//
//       print(e.toString());
//       print('error getting Customer UUID');
//     }
//
//     for(var item in contactUuids){
//       // UPDATE SCORE ON
//       try {
//         recordResponse = await _dio.post(_webappSalesContactFindUrl,
//             data: {"query": [{"__pk_ID_Contacts": "=$item"}]}
//         );
//
//       } catch (e) {
//         print('no found user in changing password');
//       }
//
//       recordIdList = recordResponse.data['response']['data'];
//
//       for(var data in recordIdList){
//         String record = data['recordId'];
//         records.add(record);
//       }
//     }
//
//     try{
//       for(var eachRecord in records){
//         await _dio.patch(_webappSalesContactWriteUrl + '/' + eachRecord,
//             data: {
//               "fieldData":
//               {
//                 "password": quotedNewPassword,
//               }
//             }
//         );
//
//       }
//     } catch(e){
//       log(e.toString());
//     }
//     return true;
//   }
//
// // LOG LOCAL NOTIFICATIONS AND LOGIN TIME TO DATABASE
//   Future <void> uploadNotificationsAndLoginTime(String username, String password, String notificationBool) async {
//     String _quotedUsername = '"' + username + '"';
//     String _quotedPassword = '"' + password + '"';
//
//     late Response _fkResponse;
//     late Response _recordResponse;
//     final String _newPushToken = await getPushToken();
//
//     List _recordIdList = [];
//     List _records = [];
//     List _contactUuidList = [];
//     List _contactUuids = [];
//
//     // ADJUST SO ALL LAST LOGGED IN TIMES ARE EASTER TIMEZONE
//     DateTime now = DateTime.now();
//     int timeZoneAdjuster = DateTime.now().timeZoneOffset.inHours;
//     String adjusted = DateFormat('M/d/yyyy hh:mm a').format(DateTime(now.year, now.month, now.day, now.hour+timeZoneAdjuster+4, now.minute, now.second));
//
//     try {
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//       _fkResponse = await _dio.post(_webappSalesContactFindUrl,
//
//           data: {"query": [{"username": "=$_quotedUsername", "password": "=$_quotedPassword", "Status": "=Active"}]}
//       );
//
//       // GET ALL PK ID NUMBERS TO ADD TRANSACTIONS TO ALL
//       _contactUuidList = _fkResponse.data['response']['data'];
//
//       for(var _list in _contactUuidList){
//         String _eachContact = _list['fieldData']['__pk_ID_Contacts'];
//         _contactUuids.add(_eachContact);
//       }
//
//     } catch (e) {
//
//       print(e.toString());
//       print('error getting PK ID from Sales Contact Screen');
//     }
//
//     // GET RECORD NUMBERS FROM EACH PK ID NUMBER
//     for(var item in _contactUuids){
//       try {
//         //GET USER DATA BASED ON USERNAME AND PASSWORD
//         _dio.options.headers['content-Type'] = 'application/json';
//         _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//         _recordResponse = await _dio.post(_webappSalesContactFindUrl,
//             data: {"query": [{"__pk_ID_Contacts": "=$item"}]}
//         );
//
//       } catch (e) {
//         print('no found user in updating last logged in time');
//       }
//
//       _recordIdList = _recordResponse.data['response']['data'];
//
//       for(var data in _recordIdList){
//         String record = data['recordId'];
//         _records.add(record);
//       }
//     }
//
//     try{
//       for(var eachRecord in _records){
//         //GET USER DATA BASED ON USERNAME AND PASSWORD
//         _dio.options.headers['content-Type'] = 'application/json';
//         _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//         await _dio.patch(_webappSalesContactWriteUrl + '/' + eachRecord,
//             data: {
//               "fieldData":
//               {
//                 "appLocalNotifcationsTurnedOn": notificationBool,
//                 "last_login": adjusted,
//               }
//             }
//         );
//       }
//     } catch(e){
//
//       log(e.toString());
//       print('error logging notification and last login');
//     }
//
//   }
//
// // WRITE TO TRANSACTIONS LAYOUT FOR UPLOADING A PHOTO
//   Future <bool> updateNamesStatus(String namesStatus, String namesCurrentTo, String fKCustomerMaster, String pushToken) async {
//     Response fkResponse;
//     var record;
//     final String _newPushToken = await getPushToken();
//
//     //GET USER DATA BASED ON USERNAME AND PASSWORD
//     _dio.options.headers['content-Type'] = 'application/json';
//     _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//     try {
//       fkResponse = await _dio.post(_webappSalesContactFindUrl,
//           data: {"query": [{"_fk_CustomerMaster": "=$fKCustomerMaster"}]}
//       );
//
//       // GET ALL PK ID NUMBERS TO ADD TRANSACTIONS TO ALL
//       record = fkResponse.data['response']['data'][0]['recordId'];
//
//     } catch (e) {
//
//       print(e.toString());
//       print('error record number');
//       return false;
//     }
//
//     try{
//       Response response = await _dio.patch(_webappSalesContactWriteUrl + '/' + record,
//           data: {
//             "fieldData":
//             {
//               "Sales_CustomerMaster::namesStatus": '$namesStatus',
//               "Sales_CustomerMaster::namesCurrentTo": '$namesCurrentTo',
//             }
//           }
//       );
//
//       print(response.data);
//
//     } catch(e){
//       log(e.toString());
//       return false;
//     }
//     return true;
//   }
//
//
//
// // SEND EMAIL TO CLIENT WITH PASSWORD IN IT
//   Future <String> sendPasswordRecoveryEmail(String email) async {
//
//     late Response cmidResponse;
//     late Response runScriptResponse;
//     String _quotedUserName = '"' + email + '"';
//     final String _newPushToken = await getPushToken();
//
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//       cmidResponse = await _dio.post(_webappSalesContactFindUrl,
//           data: {"query": [{"username": "=$_quotedUserName"}]}
//       );
//
//       String fkCustomerMaster = cmidResponse.data['response']['data'][0]['fieldData']['_fk_CustomerMaster'];
//
//       var json = {
//         "cmid": fkCustomerMaster,
//         "email": email
//       };
//
//       var encodedJson = jsonEncode(json);
//
//       try {
//         runScriptResponse = await _dio.get(_webappPasswordRecoveryScript,
//             queryParameters: {
//               "script.param": encodedJson,
//             }
//         );
//
//         print(runScriptResponse);
//
//       } catch (e){
//
//         print(e);
//         print('error running script for password recovery');
//         return 'Error';
//
//       }
//
//     } catch(e){
//       return 'No user found';
//     }
//
//     return 'Password Sent';
//
//   }
//
// // SEND EMAIL WITH INCOMING CONTENT
//   Future <String> sendEmail(String email, String subject, String message) async {
//
//     late Response runScriptResponse;
//
//     var jsonData = {
//       "email": email,
//       "subject": subject,
//       "message": message,
//     };
//
//     var encodedJson = jsonEncode(jsonData);
//
//     final String _newPushToken = await getPushToken();
//
//     try {
//
//       //GET USER DATA BASED ON USERNAME AND PASSWORD
//       _dio.options.headers['content-Type'] = 'application/json';
//       _dio.options.headers["authorization"] = 'Bearer ' + _newPushToken;
//
//       runScriptResponse = await _dio.get(_webappSendEmailScript,
//           queryParameters: {
//             "script.param": encodedJson,
//           }
//       );
//
//
//     } catch (e){
//
//       print(e);
//       print('error running script for sending an email');
//       return 'Error';
//
//     }
//
//     return runScriptResponse.data.toString();
//   }


}








