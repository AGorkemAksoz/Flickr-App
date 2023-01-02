//
//  NetworkingManager.swift
//  Flickr Client App
//
//  Created by Ali Görkem Aksöz on 24.10.2022.
//

import Foundation

class NetworkingManager{
    
    static let shared = NetworkingManager()
    
    func fetchImage(with url: String?, competion: @escaping (Data) -> Void){
        if let urlString = url, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data{
                    competion(data)
                    /*                    DispatchQueue.main.async {
                     cell.photoImageView.image = UIImage(data: data)
                     }photo?.urlZ*/
                }
            }.resume()
        }
    }
}
