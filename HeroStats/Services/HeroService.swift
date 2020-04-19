//
//  HeroService.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 18/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import Foundation

enum HeroServiceError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class HeroService {
    static var BaseURL = URL(string: "https://api.opendota.com")
    typealias HeroStatsCompletion = ([HeroStatsData]?, HeroServiceError?) -> ()
    
    static func getHeroStats(completion: @escaping HeroStatsCompletion) {
        URLSession.shared.dataTask(with: URL(string: "https://api.opendota.com/api/herostats")!) { (data, response, error) in
            guard error == nil else {
              print("Failed request from OpenDota Hero Stats: \(error!.localizedDescription)")
              completion(nil, .failedRequest)
              return
            }
            
            guard let data = data else {
              print("No data returned from OpenDota Hero Stats")
              completion(nil, .noData)
              return
            }
            
            guard let response = response as? HTTPURLResponse else {
              print("Unable to process OpenDota Hero Stats response")
              completion(nil, .invalidResponse)
              return
            }

            guard response.statusCode == 200 else {
              print("Failure response from OpenDota Hero Stats: \(response.statusCode)")
              completion(nil, .failedRequest)
              return
            }
            
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let heroData: [HeroStatsData] = try decoder.decode([HeroStatsData].self, from: data)
                    completion(heroData, nil)
                } catch {
                    print("Unable to decode OpenDota Hero Stats response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
}
