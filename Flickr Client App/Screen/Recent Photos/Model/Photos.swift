//
//  Photo.swift
//  Flickr Client App
//
//  Created by Ali Görkem Aksöz on 22.10.2022.
//

import Foundation

struct Photos: Codable {
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let photo: [Photo]?
}
