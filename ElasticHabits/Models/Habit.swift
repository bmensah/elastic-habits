//
//  Habit.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    let name: String
    let tierA: String
    let tierB: String
    let tierC: String
    let rules: [Rule]
}


