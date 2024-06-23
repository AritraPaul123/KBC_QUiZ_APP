
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB{
  final uidkey="uidkey";
  final logkey="logkey";
  final namekey="namekey";
  static final moneykey="moneykey";
  final levelkey="levelkey";
  static final rankkey="rankkey";
  final proURLkey="proURLkey";
  static final audkey="AudKey";
  static final fkey="FiftyKey";
  static final jkey="JokerKey";
  static final expkey="ExpertKey";
   Future<bool> saveUserID(String uid) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setString(uidkey, uid);
  }
  Future<String?> getUserID() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getString(uidkey);
  }
  Future<bool> saveLoginData(bool logdata) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setBool(logkey, logdata);
  }
  Future<bool?> getLoginData() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getBool(logkey);
  }
  Future<bool?> saveUserName(String username) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setString(namekey,username);
  }
  Future<String?> getUserName() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getString(namekey);
  }
  Future<bool?> saveLevel(String level) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setString(levelkey,level);
  }
  Future<String?> getLevel() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getString(levelkey);
  }
  static Future<bool?> saveRank(String rank) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setString(rankkey,rank);
  }
  static Future<String?> getRank() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getString(rankkey);
  }
  static Future<bool?> saveMoney(String money) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setString(moneykey,money);
  }
  static Future<String?> getMoney() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getString(moneykey);
  }
  Future<bool?> saveProURL(String proURL) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setString(proURLkey,proURL);
  }
  Future<String?> getProURL() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getString(proURLkey);
  }
  static Future<bool?> saveAud(bool Aud) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setBool(audkey,Aud);
  }
  static Future<bool?> getAud() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getBool(audkey);
  }
  static Future<bool?> save50(bool f50) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setBool(fkey,f50);
  }
  static Future<bool?> get50() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getBool(fkey);
  }
  static Future<bool?> savejoker(bool joker) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setBool(jkey,joker);
  }
  static Future<bool?> getjoker() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getBool(jkey);
  }
  static Future<bool?> saveexpert(bool exp) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.setBool(expkey,exp);
  }
  static Future<bool?> getexpert() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return await preferences.getBool(expkey);
  }

}