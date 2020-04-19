//
//  HeroStatsData.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 18/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import Foundation

struct HeroStatsData: Decodable {
    let id: Int
    let name: String
    let localized_name: String
    let primary_attr: String
    let attack_type: String
    let roles: Array<String>
    let img: String
    let icon: String
    let base_health: Int?
    let base_mana: Int?
    let base_armor: Double?
    let base_attack_min: Int?
    let base_attack_max: Int?
    let move_speed: Int?
}
