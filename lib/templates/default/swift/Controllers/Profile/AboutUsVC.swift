//
//  AboutUsVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

// TODO: Temp picture struct
struct Pic{
    
    var url = ""
    
    init(url: String) {
        self.url = url
    }
    
}

class AboutUsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Outlets
    
    @IBOutlet var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Properties
    
    var pictures = [Pic]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        // TODO: Add some pictures
        self.pictures.append(Pic(url: "http://detoqueytoque.com/Fotos_Web_new/Home/grupo%20en%20TLG.jpg"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true
        
    }
    private func setup() {
        
        self.gradientView.applyGradient(withColours: [Colors.firstGradientColor, Colors.thirdGradientColor], locations: [0, 0.5])
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let origImage = UIImage(named: "Back")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(tintedImage, for: .normal)
        self.backButton.tintColor = UIColor(red: 107.0/255.0, green: 255.0/255.0, blue: 192.0/255.0, alpha: 1)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutUsImageCell", for: indexPath) as! AboutUsImageCell
            cell.pictures = self.pictures
            cell.pageControl.numberOfPages = self.pictures.count
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
            // TODO: Add description
            cell.descriptionTextView.text = "About us description"
            return cell
        }
    }
}

