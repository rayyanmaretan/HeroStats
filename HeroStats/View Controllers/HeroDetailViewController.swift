//
//  HeroDetailViewController.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 19/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    @IBOutlet var heroName: UILabel!
    @IBOutlet var baseAttack: UILabel!
    @IBOutlet var baseArmor: UILabel!
    @IBOutlet var moveSpeed: UILabel!
    @IBOutlet var baseHealth: UILabel!
    @IBOutlet var baseMana: UILabel!
    @IBOutlet var primaryAttribute: UILabel!
    @IBOutlet var roles: UILabel!
    
    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var similarHero1: UIImageView!
    @IBOutlet var similarHero2: UIImageView!
    @IBOutlet var similarHero3: UIImageView!
    
    var viewModel: HeroDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.hero?.bind(listener: { [weak self] (hero) in
            self?.heroName.text = hero?.localized_name
            self?.baseAttack.text = "\(hero?.base_attack_min ?? 0) - \(hero?.base_attack_max ?? 0)"
            self?.baseArmor.text = "\(hero?.base_armor ?? 0)"
            self?.moveSpeed.text = "\(hero?.move_speed ?? 0)"
            self?.baseHealth.text = "\(hero?.base_health ?? 0)"
            self?.baseMana.text = "\(hero?.base_mana ?? 0)"
            self?.primaryAttribute.text = hero?.primary_attr
            self?.roles.text = "Roles:\n\(hero?.roles.joined(separator: ", ") ?? "")"
            
            if let url = URL(string: "\(HeroService.BaseURL?.absoluteString ?? "")\(hero?.img ?? "")") {
                self?.heroImage.downloaded(from: url)
            }
            
        })
        
        viewModel?.similarHeroes.bind(listener: { [weak self] (hero) in
            if let url = URL(string: "\(HeroService.BaseURL?.absoluteString ?? "")\(hero?[0].img ?? "")") {
                self?.similarHero1.downloaded(from: url)
            }
            
            if let url = URL(string: "\(HeroService.BaseURL?.absoluteString ?? "")\(hero?[1].img ?? "")") {
                self?.similarHero2.downloaded(from: url)
            }
            
            if let url = URL(string: "\(HeroService.BaseURL?.absoluteString ?? "")\(hero?[2].img ?? "")") {
                self?.similarHero3.downloaded(from: url)
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
