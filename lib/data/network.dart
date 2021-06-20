import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datepicker/persian_datetime.dart';

class NetWorkHelper {
  apiCaller({dynamic params, String route, Function callback}) async {
    final request = await http.post("https://api.scopeiran.com/$route",
        headers: {"content-type": "application/json", 'Charset': 'utf-8'},
        body: jsonEncode(params));
    print("params:");
    print(params);
    print(json.decode(request.body));
    return json.decode(request.body);
  }
}

String numConverter(String string, {bool isDate = true}) {
  const persianNumbers = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"];
  const arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];

  for (int i = 0; i < 10; i++) {
    string = string
        .replaceAll(persianNumbers[i], i.toString())
        .replaceAll(arabicNumbers[i], i.toString());
  }
  if (isDate == false) {
    return string;
  } else {
    print("string:$string");
    PersianDateTime persianDate3 = PersianDateTime(jalaaliDateTime: string);
    string = persianDate3.toGregorian(format: 'YYYY-MM-DD');
  }

  return string;
}

class Routing {
  final ntk = NetWorkHelper();

  userLogin(String mobile) {
    return ntk.apiCaller(params: {'mobile': mobile}, route: "user/Login");
  }

  verify({String mobile, String verifyCode}) {
    return ntk.apiCaller(
        params: {"mobile": mobile, 'verification': verifyCode},
        route: "user/verification/Check");
  }

  getProject({@required String token}) {
    return ntk.apiCaller(params: {'token': token}, route: "project/user/Get");
  }

  getUser({@required String token, int projectId}) async {
    return ntk.apiCaller(
        params: {"token": token, "projectId": projectId}, route: 'user/get');
  }

  getProvierType({@required String token}) {
    return ntk.apiCaller(params: {
      'token': token,
    }, route: "provider/type/Get");
  }

  getProvider({String token}) async {
    return ntk.apiCaller(params: {"token": token}, route: "provider/Get");
  }

  getAddress({double lat, double lng}) async {
    return ntk
        .apiCaller(params: {'lat': lat, 'lng': lng}, route: 'address/Get');
  }

  getAlarm(
      {String token, int projectId, int isRead, int frm, int cnt = 10}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "isRead": isRead,
      "frm": frm,
      "cnt": cnt
    }, route: "alarm/get");
  }

  alarmOffset(String token, int itemId) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId}, route: "alarm/off/set");
  }

  getStorageItemProperty({@required String token, String itemType}) async {
    return ntk.apiCaller(
        params: {'token': token, "itemType": itemType},
        route: 'anbar/item/Property');
  }

  getStorageImportation({String token, int projectId}) async {
    return ntk.apiCaller(
        params: {'token': token, 'projectId': projectId},
        route: "anbar/in/Get");
  }

  getStorageExtraction(
      {@required String token, @required int projectId}) async {
    return ntk.apiCaller(
        params: {'token': token, 'projectId': projectId},
        route: "anbar/out/get");
  }

  getStorageStock({@required String token, @required int projectId}) async {
    return ntk.apiCaller(
        params: {'token': token, 'projectId': projectId},
        route: "anbar/stock/Get");
  }

  anbarItemGet({String token, String itemType}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemType": itemType},
        route: "anbar/item/Get");
  }

  getMaterial(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      "dateOf": numConverter(dateIn)
    }, route: "masaleh/get");
  }

  getStorageImportationByText(
      {String token, String type, String txt, int frm, int cnt}) {
    return ntk.apiCaller(params: {
      "token": token,
      "itemType": "ALL",
      "txt": txt,
      "frm": frm,
      "cnt": cnt
    }, route: "anbar/item/bytext/get");
  }

  getMachine(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      "dateOf": numConverter(dateIn)
    }, route: "tajhizat/get");
  }

  updateExtraction(
      {String token,
      int itemId,
      int stockId,
      String description,
      String amount}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "stockId": stockId,
      "info": description,
      "amount_new": double.parse(numConverter(amount, isDate: false))
    }, route: "anbar/out/update");
  }

  deleteExtraction({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId}, route: "anbar/out/delete");
  }

  storageImport(
      {@required String token,
      @required int projectId,
      int providerId,
      int vahedId,
      int itemId,
      String amount,
      String evacuation,
      List files}) {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'providerId': providerId,
      'itemId': itemId,
      'vahedId': vahedId,
      'amount': amount,
      'evacuation': evacuation,
      'files': files
    }, route: "anbar/in/Add");
  }

  storageExtract(
      {@required String token,
      @required int projectId,
      int itemId,
      String dateIn,
      String info,
      int activityId,
      String amount}) {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'itemId': itemId,
      "info": info,
      'date_in': numConverter(dateIn),
      'amount': double.parse(amount),
    }, route: "anbar/out/add");
  }

  setCurrentProject(@required String token, String phone, int projectId) {
    return ntk.apiCaller(
        params: {'token': token, 'projectId': projectId, 'mobile': phone},
        route: "active/project/update");
  }

  addProvider(
      {@required String token,
      String title,
      String firstName,
      String lastName,
      String tell,
      String mobile,
      int lat,
      int lng,
      String address,
      String cardNumber,
      String shaba,
      int providerTypeId}) {
    return ntk.apiCaller(params: {
      'token': token,
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'tell': tell,
      'mobile': mobile,
      'lat': lat,
      'lng': lng,
      'address': address,
      'cardNumber': cardNumber,
      'shaba': shaba,
      'providerTypeId': providerTypeId
    }, route: "provider/Add");
  }

  getWallet({@required String token, String fromDate, String toDate}) {
    print("fromDate:");
    print(fromDate);
    print("toDate");
    print(toDate);
    return ntk.apiCaller(params: {
      'token': token,
      'toDate': numConverter(toDate),
      'fromDate': numConverter(fromDate),
    }, route: "wallet/Get");
  }

  getPropertyCost({@required String token, @required int projectId}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
    }, route: "cost/Property");
  }

  getKarTable({@required String token, int frm = 0, int cnt = 10}) async {
    return ntk.apiCaller(
        params: {"token": token, "frm": frm, "cnt": cnt},
        route: "kartable/get");
  }

  getKartablebyId({String token, int itemId}) {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId}, route: "kartable/byid/Get");
  }

  addKartable(
      {@required String token,
      String titleOf,
      String msgType,
      int itemId,
      String description,
      int toUser,
      int toRole,
      List file}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "titleOf": titleOf,
      "msgType": msgType,
      "itemId": itemId,
      "description": description,
      "toUser": toUser,
      "toRole": toRole,
      "file": file
    }, route: 'kartable/add');
  }

  addConfirm({String token, int cartableId, int isConfirm, Map responseJson}) {
    return ntk.apiCaller(
      params: {
        "token": token,
        "kartableId": cartableId,
        'isConfirm': isConfirm,
        "responseJSON": responseJson
      },
      route: "kartable/confirm/Add",
    );
  }

  addPay(
      {String token,
      int projectId,
      int activityId,
      int receiverId,
      String amount,
      String description,
      String type}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      'receiverId': receiverId,
      'amount': double.parse(amount),
      'description': description,
      'type': type
    }, route: 'wallet/transaction/Set');
  }

  getAllWBSActivity({@required String token, @required int projectId}) {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
    }, route: "wbs/activity/all/Get");
  }

  getWBS({String token, int wbsId}) {
    return ntk.apiCaller(
        params: {"token": token, "wbsId": wbsId}, route: "wbs/cat/Get");
  }

  getDailyActivity(
      {String token, int projectId, int activityId, String dateIn}) {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      "dateIn": numConverter(dateIn)
    }, route: "daily/works/Get");
  }

  addDailyActivity(
      {String token,
      int projectId,
      int activityId,
      String title,
      String dateIn,
      String description,
      List files}) {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      "title": title,
      "dateIn": numConverter(dateIn),
      "description": description,
      "files": files
    }, route: "daily/works/Add");
  }

  deleteDailyActivity({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/works/delete");
  }

  updateDailyActivity(
      {String token,
      int itemId,
      int projectId,
      int activityId,
      String dateIn,
      String title,
      String description,
      List files}) async {
    return ntk.apiCaller(params: {
      'token': token,
      "projectId": projectId,
      "activityId": activityId,
      "itemId": itemId,
      'title': title,
      'dateIn': numConverter(dateIn),
      'description': description,
      'files': files
    }, route: "daily/works/update");
  }

  getDailyContractor(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      "dateIn": numConverter(dateIn)
    }, route: "daily/contractor/Get");
  }

  getWorkersSkill({String token}) async {
    return ntk.apiCaller(params: {'token': token}, route: 'skills/get');
  }

  deleteDailyContractor({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/contractor/delete");
  }

  addDailyContractor(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String firstName,
      String lastName,
      String title,
      String tell,
      String address,
      int skillId,
      String price,
      String prePay,
      String postPay,
      String payCondition,
      String startDate,
      String endDate,
      List files,
      List workers}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "projectId": projectId,
      "activityId": activityId,
      "dateIn": numConverter(dateIn),
      "firstName": firstName,
      "lastName": lastName,
      "title": title,
      "tell": tell,
      "address": address,
      "skill": skillId,
      "price1": double.parse(numConverter(price, isDate: false)),
      "prepay1": double.parse(numConverter(prePay, isDate: false)),
      "postpay1": double.parse(numConverter(postPay, isDate: false)),
      "pay_condition1": payCondition,
      "date_start1": numConverter(startDate),
      "date_end1": numConverter(endDate),
      "files": files,
      "nirooha1": workers
    }, route: "daily/contractor/Add");
  }

  updateDailyContractor(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String dateIn,
      String firstName,
      String lastName,
      String title,
      String tell,
      String address,
      int skillId,
      String price,
      String prePay,
      String postPay,
      String payCondition,
      String startDate,
      String endDate,
      List files,
      List workers}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "firstName": firstName,
      "lastName": lastName,
      "title": title,
      "tell": tell,
      "address": address,
      "skill": skillId,
      "price1": double.parse(numConverter(price, isDate: false)),
      "prepay1": double.parse(numConverter(prePay, isDate: false)),
      "postpay1": double.parse(numConverter(postPay, isDate: false)),
      "pay_condition1": payCondition,
      "date_start1": numConverter(startDate),
      "date_end1": numConverter(endDate),
      "files": files,
      "nirooha1": workers
    }, route: 'daily/contractor/update');
  }

  getHumenResource({String token, int projectId}) async {
    return ntk.apiCaller(
        params: {"token": token, 'projectId': projectId},
        route: 'human/resource/get');
  }

  getHumenWorkers(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: 'daily/worker/get');
  }

  addHumenResource(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      int humanId,
      String descriptionWork,
      String fromTime,
      String toTime}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      'humanId': humanId,
      'descriptionWork': descriptionWork,
      'timeFor': fromTime,
      'timeTo': toTime
    }, route: 'daily/worker/add');
  }

  updateHumen(
      {String token,
      int itemId,
      int humanId,
      String descriptionWork,
      String timeFor,
      String timeTo}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'itemId': itemId,
      'humanId': humanId,
      'descriptionWork': descriptionWork,
      'timeFor': numConverter(timeFor, isDate: false),
      'timeTo': numConverter(timeTo, isDate: false)
    }, route: 'daily/worker/update');
  }

  deleteHumen({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {'token': token, 'itemId': itemId},
        route: 'daily/worker/delete');
  }

  getAccident(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: 'daily/event/get');
  }

  addAccident(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String enentType,
      String descriptionEvent,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      'enentType': enentType,
      'descriptionEvent': descriptionEvent,
      'file': file,
      'pic': []
    }, route: 'daily/event/add');
  }

  updateAccident(
      {String token,
      int itemId,
      String enentType,
      String descriptionEvent,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'itemId': itemId,
      'enentType': enentType,
      'descriptionEvent': descriptionEvent,
      'file': file,
      'pic': []
    }, route: 'daily/event/update');
  }

  deleteAccident({String token, int itemId}) {
    return ntk.apiCaller(
        params: {'token': token, 'itemId': itemId},
        route: 'daily/event/delete');
  }

  getMedia({String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: 'daily/media/get');
  }

  deleteMedia({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {'token': token, 'itemId': itemId},
        route: 'daily/media/delete');
  }

  updateMedia({String token, int itemId, List file}) async {
    return ntk.apiCaller(
        params: {'token': token, 'itemId': itemId, 'pic': file, 'movie': []},
        route: 'daily/media/update');
  }

  addMedia(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      'pic': file,
      'movie': []
    }, route: 'daily/media/add');
  }

  getProgram(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: 'daily/order/get');
  }

  addProgram(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String titleOf,
      String descriptionOf,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      'titleOf': titleOf,
      'descriptionOf': descriptionOf,
      'file': file
    }, route: "daily/order/add");
  }

  deleteProgram({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {'token': token, 'itemId': itemId},
        route: 'daily/order/delete');
  }

  updateProgram(
      {String token,
      int itemId,
      String titleOf,
      String descriptionOf,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'itemId': itemId,
      'titleOf': titleOf,
      'descriptionOf': descriptionOf,
      'file': file
    }, route: "daily/order/update");
  }

  getSession(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: "daily/session/get");
  }

  deleteSession({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/session/delete");
  }

  updateSession(
      {String token,
      int itemId,
      String titleOf,
      String descriptionOf,
      List sessionItems}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "session_items": sessionItems
    }, route: "daily/session/update");
  }

  addSession(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String titleOf,
      String descriptionOf,
      List sessionItems}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "session_items": sessionItems
    }, route: "daily/session/add");
  }

  getWeather(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: "daily/weather/get");
  }

  deleteWeather({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/weather/delete");
  }

  updateWeather(
      {String token,
      int itemId,
      String weatherType,
      String degreeOf,
      String timeDay}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "weatherType": weatherType,
      "degreeOf": double.parse(numConverter(degreeOf, isDate: false)),
      "timeDay": numConverter(timeDay, isDate: false)
    }, route: "daily/weather/update");
  }

  addWeather(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String weatherType,
      String degreeOf,
      String timeDay}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      "weatherType": weatherType,
      "degreeOf": double.parse(numConverter(degreeOf, isDate: false)),
      "timeDay": numConverter(timeDay, isDate: false)
    }, route: "daily/weather/add");
  }

  getPermit(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: "daily/permit/get");
  }

  deletePermit({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/permit/delete");
  }

  updatePermit(
      {String token,
      int itemId,
      String titleOf,
      String descriptionOf,
      int permitFrom}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "permitFrom": permitFrom
    }, route: "daily/permit/update");
  }

  addPermit(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String titleOf,
      String descriptionOf,
      int permitFrom}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "permitFrom": permitFrom
    }, route: "daily/permit/add");
  }

  getBazdid(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: "daily/bazdid/get");
  }

  deleteBazdid({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/bazdid/delete");
  }

  updateBazdid(
      {String token,
      int itemId,
      String titleOf,
      String descriptionOf,
      String visitor,
      List file}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "visitor": visitor,
      "file": file
    }, route: "daily/bazdid/update");
  }

  addBazdid(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String titleOf,
      String descriptionOf,
      String visitor,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "visitor": visitor,
      "file": file
    }, route: "daily/bazdid/add");
  }

  addEstelam(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      int providerId,
      String descriptionOf,
      // ignore: non_constant_identifier_names
      String estelam_dateFor,
      // ignore: non_constant_identifier_names
      String estelam_amount}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      "providerId": providerId,
      "description": descriptionOf,
      "estelam_dateFor": numConverter(estelam_dateFor),
      "estelam_amount": numConverter(estelam_amount, isDate: false)
    }, route: "daily/estelam/add");
  }

  getEstelam(
      {String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: "daily/estelam/get");
  }

  deleteEstelam({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId},
        route: "daily/estelam/delete");
  }

  updateEstelam(
      {String token,
      int itemId,
      int providerId,
      String descriptionOf,
      // ignore: non_constant_identifier_names
      String estelam_dateFor,
      // ignore: non_constant_identifier_names
      String estelam_amount}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "providerId": providerId,
      "description": descriptionOf,
      "estelam_dateFor": numConverter(estelam_dateFor),
      "estelam_amount": numConverter(estelam_amount, isDate: false)
    }, route: "daily/estelam/update");
  }

  getRent({String token, int projectId, int activityId, String dateIn}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn)
    }, route: "daily/rent/get");
  }

  deleteRent({String token, int itemId}) async {
    return ntk.apiCaller(
        params: {"token": token, "itemId": itemId}, route: "daily/rent/delete");
  }

  updateRent(
      {String token,
      int itemId,
      String titleOf,
      String descriptionOf,
      String dateEnd,
      String dateStart,
      String price,
      List file}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "itemId": itemId,
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "dateStart": dateStart,
      "dateEnd": dateEnd,
      "price": double.parse(numConverter(price, isDate: false)),
      "file": file
    }, route: "daily/rent/update");
  }

  addRent(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String titleOf,
      String price,
      String descriptionOf,
      String dateEnd,
      String dateStart,
      List file}) async {
    return ntk.apiCaller(params: {
      'token': token,
      'projectId': projectId,
      'activityId': activityId,
      'dateIn': numConverter(dateIn),
      "titleOf": titleOf,
      "descriptionOf": descriptionOf,
      "price": double.parse(numConverter(price, isDate: false)),
      "dateStart": numConverter(dateStart.substring(0, 10)) +
          " " +
          dateStart.substring(11),
      "dateEnd":
          numConverter(dateEnd.substring(0, 10)) + " " + dateEnd.substring(11),
      "file": file
    }, route: "daily/rent/add");
  }

  getCheckList({String token, int activityId}) async {
    return ntk.apiCaller(
        params: {"token": token, "activityId": activityId},
        route: "checklist/get");
  }

  upadteChecklist({String token, List items}) async {
    return ntk.apiCaller(
        params: {"token": token, "items": items},
        route: "checklist/check/update");
  }

  getReport(
      {String token,
      String tbl,
      String activityList,
      String fromDate,
      String toDate}) async {
    return ntk.apiCaller(params: {
      "token": token,
      "tbl": tbl,
      "activityList": activityList,
      "fromDate": numConverter(fromDate),
      "toDate": numConverter(toDate)
    }, route: "report/get");
  }
}
