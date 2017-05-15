//
//  DateStringExtension.swift
//  Mara
//
//  Created by 周际航 on 2017/2/7.
//  Copyright © 2017年 com.maramara. All rights reserved.
//

import Foundation

extension Date {
    var ext_yyyyMMdd: String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: self)
    }
    var ext_yyyyMMddHHmm: String {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd HH:mm"
        return format.string(from: self)
    }
    var ext_HHmmss: String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        return format.string(from: self)
    }
}

