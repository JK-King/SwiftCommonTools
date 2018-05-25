//
//  VerificationTools.swift
//  Pods-SwiftCommonTools_Example
//
//  Created by Jiankun Zhang on 2018/5/25.
//

import UIKit

class VerificationTools: NSObject {
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
        let cu_num = "^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
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
}
