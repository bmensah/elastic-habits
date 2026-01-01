//
//  DailyContext.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import Foundation

struct DailyContext: Codable {
    let lowEnergy: Bool
    let workedLate: Bool
    
    static var `default`: DailyContext {
        DailyContext(lowEnergy: false, workedLate: false)
    }
}

