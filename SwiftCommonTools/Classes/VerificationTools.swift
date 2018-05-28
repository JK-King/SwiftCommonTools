//
//  VerificationTools.swift
//  Pods-SwiftCommonTools_Example
//
//  Created by Jiankun Zhang on 2018/5/25.
//

import UIKit

class VerificationTools: NSObject {
    
    /// 校验手机号
    ///
    /// - Parameter mobile: 手机号
    /// - Returns: 布尔值
    class func valiMobile(mobile:String) -> Bool {
        let mobileStr = mobile.replacingOccurrences(of: " ", with: "");
        if mobileStr.count != 11 {
            return false;
        }
        /**
         * 移动号段正则表达式
         */
        let cm_num = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        let cu_num = "^((13[0-2])|(145)|(15[5-6])|(176)|(166)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        let ct_num = "^((173)|(133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        let pred1:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", cm_num);
        let isMatch1:Bool = pred1.evaluate(with: mobile);
        
        let pred2:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", cu_num);
        let isMatch2:Bool = pred2.evaluate(with: mobile);
        
        let pred3:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", ct_num);
        let isMatch3:Bool = pred3.evaluate(with: mobile);
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return true;
        }else{
            return false;
        }
    }
    
    /// 正则匹配用户密码8-20位数字和字母组合
    ///
    /// - Parameter password: 密码
    /// - Returns: 布尔值
    class func checkPassword(password:String) -> Bool {
        if password.count <= 0 {
            return false;
        }
        //8-20位数字和字母组成
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
        let pred:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex);
        return pred.evaluate(with: password);
    }
    
    /// 校验是否是6位数字验证码
    ///
    /// - Parameter number: 验证码
    /// - Returns: 布尔值
    class func checkCodeNumber(number:String) -> Bool {
        let regex = "^[0-9]{6}$";
        let pred:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex);
        return pred.evaluate(with: number);
    }
    
    /// 判断字符串是否含有中文
    ///
    /// - Parameter string: 字符串
    /// - Returns: 布尔值
    class func checkChineseOfString(string:String) -> Bool {
        for character in string {
            if (character >= "\u{4E00}" && character <= "\u{9FA5}") {
                return true;
            }
        }
        return false;
    }
    
    /// 判断身份证号是否合法
    ///
    /// - Parameter identity: 身份证号
    /// - Returns: 布尔值
    class func checkIdentityValid(identity:String) -> Bool {
    
        if identity.count != 18 {
            return false;
        }
        
        let regex:String = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
        let predicate:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex);
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if !predicate.evaluate(with: identity) {
            return false;
        }
        //将前17位加权因子保存在数组里
        let idCardWiArray:Array = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        let idCardYArray:Array = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        var idCardWiSum:Int = 0;
        for i in 0..<17 {
            let subStrIndex:Int = Int(identity.substring(with: Range.init(NSMakeRange(i, 1), in: identity)!))!;
            let idCardWiIndex:Int = Int(idCardWiArray[i])!;
            idCardWiSum += subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        let idCardMod:Int = idCardWiSum%11;
        //得到最后一位身份证号码
        let idCardLast:String = identity.substring(with: Range.init(NSMakeRange(17, 1), in: identity)!);
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if idCardMod == 2 {
            if (idCardLast != "X") || (idCardLast != "x") {
                return false;
            }
        }else {
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if idCardLast != idCardYArray[idCardMod] {
                return false;
            }
        }
        return true;
    }
    
    /// 校验邮箱
    ///
    /// - Parameter email: 邮箱地址
    /// - Returns: 布尔值
    class func checkEmailAdress(email:String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let pred:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex);
        return pred.evaluate(with: email);
    }
    
    /// 校验银行卡
    ///
    /// - Parameter cardNumber: 银行卡号
    /// - Returns: 布尔值
    class func checkBankCard(cardNumber:String) -> Bool {
        if cardNumber.count == 0 {
            return false
        }
        var digitsOnly = ""
        for c in cardNumber {
            if isdigit(Int32(c.hashValue)) == 1 {
                digitsOnly = digitsOnly + ("\(c)")
            }
        }
        var sum: Int = 0;
        var digit: Int = 0;
        var addend: Int = 0;
        var timesTwo = false;
        for cc in digitsOnly.reversed() {
            let zero:Character = "0";
            digit = cc.hashValue-zero.hashValue;
            if timesTwo {
                addend = digit * 2;
                if addend > 9 {
                    addend -= 9;
                }
            }else {
                addend = digit;
            }
            sum += addend;
            timesTwo = !timesTwo;
        }
        let modulus: Int = sum % 10
        return modulus == 0
    }
    
}
