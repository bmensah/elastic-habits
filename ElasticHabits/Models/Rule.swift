//
//  Rule.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import Foundation

enum ConditionType: Codable {
    case lowEnergy
    case workedLate
}

enum Tier: Int, Codable {
    case A = 3
    case B = 2
    case C = 1
}

struct Rule: Codable, Identifiable {
    let id: UUID
    let condition: ConditionType
    let allowedTier: Tier
}

