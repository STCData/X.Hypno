//
//  LogInit.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import Foundation
import Puppy

func LogInit() {
    let console = ConsoleLogger("stc.data.console")
//    let syslog = SystemLogger("stc.data.syslog")

    let term = TermLogger("stc.data.term")
    var puppy = Puppy()
    puppy.add(console)
    puppy.add(term)
//    puppy.add(syslog)

    LoggingSystem.bootstrap {
        var handler = PuppyLogHandler(label: $0, puppy: puppy)
        // Set the logging level.
        handler.logLevel = .info
        return handler
    }

    let log = LogLabels.general.makeLogger()

    log.trace("TRACE message log init") // Will be logged.
    log.debug("DEBUG message log init") // Will be logged.
}
