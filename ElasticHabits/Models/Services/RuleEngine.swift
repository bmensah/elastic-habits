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
    static func requiredTier(context: DailyContext) -> Tier {
        // If both conditions are active, required tier is C
        if context.lowEnergy && context.workedLate {
            return .C
        }
        
        // If either condition is active, required tier is B
        if context.lowEnergy || context.workedLate {
            return .B
        }
        
        // Default: no conditions active, required tier is A
        return .A
    }
}

