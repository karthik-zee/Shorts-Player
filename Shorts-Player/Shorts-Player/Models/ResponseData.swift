//
//  APIResponse.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 22/08/23.
//

import Foundation

struct Asset: Codable {
    let assetDetails: AssetDetails
}

struct AssetDetails: Codable {
    let id: String
    let title: String
    let description: String
    let duration: Int
    let asset_type: Int
    let videoUri: VideoUri
}

struct VideoUri: Codable {
    let avcUri: String
    let hevcUri: String
}

struct ResponseData: Codable {
    let assets: [Asset]
}
