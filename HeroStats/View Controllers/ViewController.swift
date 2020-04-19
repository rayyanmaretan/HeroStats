//
//  ViewController.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 17/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel = HeroViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.heroStats.bind { [weak self] (data) in
            self?.collectionView.reloadData()
        }
        
        viewModel.roles.bind { [weak self]  _ in
            self?.tableView.reloadData()
        }
        
        viewModel.heroesBySelectedRole.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHeroDetail" {
            if let destination = segue.destination as? HeroDetailViewController {
                viewModel.prepareForShowHeroDetail(destination)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel.roles.value?.count, count > 0 { return count + 1 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == viewModel.roles.value?.count {
            cell.categoryLabel.text = "All"
        }
        else {
            guard let role = viewModel.roles.value?[indexPath.row] else { return UITableViewCell() }
            cell.categoryLabel.text = role
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRoleId.value = indexPath.row
        viewModel.selectRoleCategory(indexPath.row)
        
        if indexPath.row == viewModel.roles.value?.count {
            self.title = "All"
        }
        else {
            self.title = viewModel.roles.value?[indexPath.row]
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.heroesBySelectedRole.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as? HeroCell else {
            return UICollectionViewCell()
        }
        
        cell.heroName.text = viewModel.heroesBySelectedRole.value?[indexPath.row].localized_name
        cell.heroImage.image = nil
        if let img = viewModel.heroesBySelectedRole.value?[indexPath.row].img {
            if let url = URL(string: "\(HeroService.BaseURL?.absoluteString ?? "")\(img)") {
                cell.heroImage.downloaded(from: url)
            }
            else {
                cell.heroImage.image = nil
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 60) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedHeroId = indexPath.row
        self.performSegue(withIdentifier: "showHeroDetail", sender: nil)
    }
}
