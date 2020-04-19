//
//  HeroViewModel.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 18/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import Foundation

class HeroViewModel {
    
    var heroStats: Box<[HeroStatsData]?> = Box(nil)
    var roles: Box<[String]?> = Box(nil)
    var selectedRoleId: Box<Int?> = Box(nil)
    var heroesBySelectedRole: Box<[HeroStatsData]?> = Box(nil)
    var selectedHeroId: Int?
    
    init() {
        self.getHeroStats()
    }
    
    private func getHeroStats() {
        HeroService.getHeroStats(completion: { [weak self] (heroData, response) in
            guard let heroData = heroData else { return }
            
            self?.heroStats.value = heroData
            self?.heroesBySelectedRole.value = heroData
            
            // category by roles
            guard let roles = self?.heroStats.value?.compactMap({ $0.roles }).flatMap({ $0 }) else { return }
            self?.roles.value = Array(Set(roles.map({ $0 })))
            
        })
    }
    
    func selectRoleCategory(_ id: Int) {
        if let count = self.roles.value?.count, self.selectedRoleId.value == count {
            heroesBySelectedRole.value = heroStats.value
        }
        else {
            guard let selectedRoleId = self.selectedRoleId.value else { return }
            guard let role = roles.value?[selectedRoleId] else { return }
            heroesBySelectedRole.value = heroStats.value?.filter({ $0.roles.contains(role)})
        }
    }
    
    func prepareForShowHeroDetail(_ destination: HeroDetailViewController) {
        guard let selectedHeroId = selectedHeroId else { return }
        guard let selectedHero = self.heroesBySelectedRole.value?[selectedHeroId] else { return }
        
        let similarHeroes = self.heroStats.value?.filter({ $0.id != selectedHero.id && selectedHero.primary_attr == $0.primary_attr }).sorted(by: {
            if selectedHero.primary_attr == "agi" {
                if let firstHeroSpeed = $0.move_speed, let secondHeroSpeed = $1.move_speed {
                    return firstHeroSpeed > secondHeroSpeed
                }
            }
            else if selectedHero.primary_attr == "str" {
                if let firstHeroAttack = $0.base_attack_max, let secondHeroAttack = $1.base_attack_max {
                    return firstHeroAttack > secondHeroAttack
                }
            }
            else if selectedHero.primary_attr == "int" {
                if let firstHeroMana = $0.base_mana, let secondHeroMana = $1.base_mana {
                    return firstHeroMana > secondHeroMana
                }
            }
            
            return false
        })
        
        destination.viewModel = HeroDetailViewModel(selectedHero)
        destination.viewModel?.similarHeroes.value = similarHeroes
    }
}
