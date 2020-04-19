//
//  HeroDetailViewModel.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 19/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import Foundation

class HeroDetailViewModel {
    var hero: Box<HeroStatsData?>? = Box(nil)
    var similarHeroes: Box<[HeroStatsData]?> = Box(nil)
    
    init(_ hero: HeroStatsData) {
        self.hero?.value = hero
    }
}
