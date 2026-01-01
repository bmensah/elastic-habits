//
//  RuleEngine.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//  Day 1 core logic.
//  Determines the minimum acceptable completion tier for a habit
//  based on active daily context and IF-THEN rules.

import Foundation

struct RuleEngine {
    static func requiredTier(habit: Habit, context: DailyContext) -> Tier {
        var requiredTier = Tier.A
        
        for rule in habit.rules {
            let isActive: Bool
            switch rule.condition {
            case .lowEnergy:
                isActive = context.lowEnergy == true
            case .workedLate:
                isActive = context.workedLate == true
            }
            
            if isActive {
                let currentRaw = requiredTier.rawValue
                let allowedRaw = rule.allowedTier.rawValue
                requiredTier = Tier(rawValue: min(currentRaw, allowedRaw)) ?? requiredTier
            }
        }
        
        return requiredTier
    }
}

