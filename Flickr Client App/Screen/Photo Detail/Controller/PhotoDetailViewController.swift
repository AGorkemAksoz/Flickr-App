//
//  PhotoDetailViewController.swift
//  Flickr Client App
//
//  Created by Ali Görkem Aksöz on 19.10.2022.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var photo:Photo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        ownerImageView.backgroundColor = .darkGray
        imageView.backgroundColor = .darkGray
        
        descriptionLable.text = "Descriptpion Label Descriptpion LableDescriptpion LableDescriptpion LableDescriptpion LableDescriptpion Lable"
        
        
        ownerLabel.text = photo?.ownername
        
        NetworkingManager.shared.fetchImage(with: photo?.buddyIconUrl) { data in
            DispatchQueue.main.async {
                self.ownerImageView.image = UIImage(data: data)
            }
        }
        NetworkingManager.shared.fetchImage(with: photo?.urlZ) { Data in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: Data)
            }
        }
        imageView.backgroundColor = .white
        title = photo?.title
        
        descriptionLable.text = photo?.photoDescription?.content
    }
    
}
