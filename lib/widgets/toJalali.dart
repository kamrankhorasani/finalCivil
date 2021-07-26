import 'package:persian_datepicker/persian_datetime.dart';

converttoJalali(String gregorianDate) {
  PersianDateTime persianDate;
  persianDate = PersianDateTime.fromGregorian(gregorianDateTime: gregorianDate);
  return persianDate.toJalaali();
}
