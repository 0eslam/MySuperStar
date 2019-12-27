//  Created by Eslam on 12/24/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

class SuperStarsVC: BaseVC {
   
    var cell_ID = "superstarsCell"
    var results: [Result]? = []
    @IBOutlet weak var superstarsCollectionView: UICollectionView!
    
    override func setupOutlets() {
        superstarsCollectionView.backgroundColor = .black
//      superstarsCollectionView.bounces = false
        superstarsCollectionView.delegate = self
        superstarsCollectionView.dataSource = self
        superstarsCollectionView.register(UINib(nibName: "SuperStarsCell", bundle: nil), forCellWithReuseIdentifier: cell_ID)
        fetchDataResults()
    }
    func fetchDataResults() {
        if Reachability.isConnectedToNetwork() {
        PopularPeopleDataProvider.getPopularPeople { (error, PopularPeople) in
            self.results = PopularPeople?.results
            self.superstarsCollectionView.reloadData()
        }
        } else {
            let alert = UIAlertController(title: "Something went Wrong", message: "No Internet Connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil  )
            
        }
    }
} // End of Class SuperStars

extension SuperStarsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = superstarsCollectionView.dequeueReusableCell(withReuseIdentifier: cell_ID, for: indexPath) as! SuperStarsCell
        cell.superstarsLabel.text = results?[indexPath.row].name ?? "data"
        cell.displayImg(URLString: results?[indexPath.row].profilePath ?? "")
        var knownFor = ""
        for item in self.results?[indexPath.row].knownFor ?? []{
            knownFor += item.title ?? ""
            knownFor = knownFor + ", "
        }
        cell.knownForLabel.text = knownFor
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (superstarsCollectionView.frame.size.width - 30 ) / 2
        let height = CGFloat(230)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
