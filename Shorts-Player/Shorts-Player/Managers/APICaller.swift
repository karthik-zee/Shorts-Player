//
//  APICaller.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 22/08/23.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    var avcURI: [String] = []
    
    func fetchVideos(){
        let urlString = "https://zshorts-dev.zee5.com/v1/zShorts"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching video URLs:", error?.localizedDescription ?? "")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(ResponseData.self, from: data)
                    
                    // Now you can access the video URLs
                    for asset in responseData.assets {
                        let avcUri = asset.assetDetails.videoUri.avcUri
                        let hevcUri = asset.assetDetails.videoUri.hevcUri
                        self?.avcURI.append(avcUri)
                    }
                    
                    print("Videos array:", self?.avcURI ?? [])
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
}
