//
//  RecentPhotosTableViewController.swift
//  Flickr Client App
//
//  Created by Ali Görkem Aksöz on 18.10.2022.
//

import UIKit

class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var response: PhotosRespose?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var selectedPhoto: Photo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchRecentPhotos()
        
    }
    
    private  func fetchRecentPhotos(){
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=c83cc48c4970beeb72640b9127cc7f98&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosRespose.self, from: data) {
                self.response = response
                
            }
        }.resume()
    }
    private  func searchPhotos(with text: String){
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=c83cc48c4970beeb72640b9127cc7f98&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosRespose.self, from: data) {
                self.response = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
    
    
    private func setupSearchController () {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder  = "Type something here to search"
        navigationItem.searchController = search
    }
    
//    private func fetchImage(with url: String?, competion: @escaping (Data) -> Void){
//        if let urlString = url, let url = URL(string: urlString) {
//            let request = URLRequest(url: url)
//            URLSession.shared.dataTask(with: request){ data, response, error in
//                if let error = error {
//                    debugPrint(error)
//                    return
//                }
//                if let data = data{
//                    competion(data)
//                    /*                    DispatchQueue.main.async {
//                     cell.photoImageView.image = UIImage(data: data)
//                     }photo?.urlZ*/
//                }
//            }.resume()
//        }
//    }
    
    
    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let photo = response?.photos?.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotosTableViewCell
        cell.ownerImageView.backgroundColor = .darkGray
        cell.ownerNameLabel.text = photo?.ownername
        
        NetworkingManager.shared.fetchImage(with: photo?.buddyIconUrl) { data in
            DispatchQueue.main.async {
                cell.ownerImageView.image = UIImage(data: data)
            }
        }
        NetworkingManager.shared.fetchImage(with: photo?.urlZ) { Data in
            DispatchQueue.main.async {
                cell.photoImageView.image = UIImage(data: Data)
            }
        }
    
    cell.titleLabel.text = photo?.title
    return cell
}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedPhoto = response?.photos?.photo?[indexPath.row]
    performSegue(withIdentifier: "detailSegue", sender: nil)
}



//MARK: - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    if let viewController = segue.destination as? PhotoDetailViewController{
        //TODO: - Seçilen fotoğrafı detay ekranına gönder
        viewController.photo = selectedPhoto
    }
}

//MARK: - UISearcResultUpdating
func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else {return}
    if text.count > 2{
        searchPhotos(with: text)
    }
}

}

