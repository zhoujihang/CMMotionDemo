//
//  TimerARC.swift
//  Mara
//
//  Created by pk on 2016/11/17.
//  Copyright © 2016年 Mara. All rights reserved.
//

import UIKit

/*! @brief
 *  用户解决timer造成的循环引用
 */

//Block
public typealias UpdateTimerHandler = () -> Void

class TimerARC: NSObject {

    var updateTimerHandler: UpdateTimerHandler?

    func updateTimer() {
        self.updateTimerHandler?()
    }
}
