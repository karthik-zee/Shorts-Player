//
//  APICaller.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 22/08/23.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    func fetchVideos(with urlString: String ,completion: @escaping ([Asset]) -> Void) {
      
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching video URLs:", error?.localizedDescription ?? "")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(ResponseData.self, from: data)
                    
                    var videoItems: [Asset] = []
                    
                    for asset in responseData.assets {
                        let item = asset
                        videoItems.append(item)
                    }
                    
                    // Call the completion closure with the avcURI array
                    completion(videoItems)
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
}
