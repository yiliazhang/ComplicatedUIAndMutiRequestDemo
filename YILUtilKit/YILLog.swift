//
//  YILLog.swift
//  clw
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 Datang. All rights reserved.
//

import UIKit
import SwiftyBeaver

struct YILLog {
    static func info(_ info: String) {
        if SwiftyBeaver.countDestinations() == 0 {
            logConfig()
        }
        SwiftyBeaver.info(info)
    }
    
    static func warning(_ info: String) {
        if SwiftyBeaver.countDestinations() == 0 {
            logConfig()
        }
        SwiftyBeaver.warning(info)
    }
    
    static func error(_ info: String) {
        if SwiftyBeaver.countDestinations() == 0 {
            logConfig()
        }
        SwiftyBeaver.info(info)
    }
    static func verbose(_ info: String) {
        if SwiftyBeaver.countDestinations() == 0 {
            logConfig()
        }
        SwiftyBeaver.error(info)
    }
    static func debug(_ info: String) {
        if SwiftyBeaver.countDestinations() == 0 {
            logConfig()
        }
        SwiftyBeaver.debug(info)
    }
    
    static func logConfig() {
        //控制台输出
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L: $M"  // hour, minute, second, loglevel and message
        console.minLevel = .info // just log .info, .warning & .error
        SwiftyBeaver.addDestination(console) // add to SwiftyBeaver
        //        SwiftyBeaver.info("hhhh")
        //        SwiftyBeaver.error("hhhh")
        //        SwiftyBeaver.warning("hhhh")
        //        SwiftyBeaver.verbose("hhhh")
        //        SwiftyBeaver.debug("hhhh")
        ///*
        //保存到文件
        let file = FileDestination() // get new file destination instance
        // uses standard logging to swiftybeaver.log in the application cache directory
        console.format = "$DHH:mm:ss$d $C$L$c: $M"  // hour, minute, second, colored log level and message
        file.minLevel = .verbose
        SwiftyBeaver.addDestination(file) // add to SwiftyBeaver to use destination
        //*/
    }
}

