//
//  AboutUsImageCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class AboutUsImageCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK: - Properties

    var pictures : [Pic] = []
    var thisWidth:CGFloat = 0

    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.pageControl.hidesForSinglePage = true
        self.pageControl.numberOfPages = self.pictures.count
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension AboutUsImageCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return self.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        
        let picture = pictures[indexPath.section]

        cell.configure(with: picture)

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        thisWidth = self.collectionView.frame.width

        return CGSize(width: thisWidth, height: self.collectionView.frame.height)
    }
    
}
