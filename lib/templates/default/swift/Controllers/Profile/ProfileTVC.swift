//
//  ProfileVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import DKImagePickerController
import ActionSheetPicker_3_0
import Kingfisher
import NVActivityIndicatorView

struct Favorite {
    var name: String = ""
}

struct UserHistory{
    var name: String = ""
    var thumbnailUrl: String = ""
}

class ProfileTVC: UITableViewController, UITextFieldDelegate, NotificationReadProtocol, UITextViewDelegate {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var editProfileImageButton: UIButton! {
        didSet {
            editProfileImageButton.imageView?.contentMode = .scaleAspectFit
            editProfileImageButton.layer.cornerRadius = editProfileImageButton.frame.size.height/2
            editProfileImageButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var editProfileImageView: UIImageView! {
        didSet {
            editProfileImageView.layer.cornerRadius = editProfileImageView.frame.size.height/2
            editProfileImageView.layer.masksToBounds = true
            editProfileImageView.layer.borderWidth = 1.0
            editProfileImageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var profileImageLoading: NVActivityIndicatorView!
    
    @IBOutlet weak var phonePrefix: UILabel!
    
    @IBOutlet weak var phoneFlagImage: UIImageView!
    
    @IBOutlet weak var phoneFlagLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UnderlinedWithIconTextField!
    
    @IBOutlet weak var lastnameTextField: UnderlinedWithIconTextField!
    
    @IBOutlet weak var emailTextField: UnderlinedWithIconTextField!
    
    @IBOutlet weak var phoneTextField: UnderlinedWithIconTextField!
    
    @IBOutlet weak var aboutMeTextView: UnderlinedTextView!
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    @IBOutlet weak var historyTripsCollectionView: UICollectionView!
    
    @IBOutlet weak var saveChangesButton: LoadingButton!
    
    @IBOutlet weak var logoutButton: LoadingButton!
    
    @IBOutlet weak var noFavoritesView: UIView!{
        didSet {
            noFavoritesView.layer.cornerRadius = noFavoritesView.frame.size.height/2
            noFavoritesView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var noTravelsView: UIView!
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var notificationButton: UIButton!{
        didSet{
            notificationButton.layer.shadowColor = UIColor.black.cgColor
            notificationButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            notificationButton.layer.masksToBounds = false
            notificationButton.layer.shadowRadius = 1.0
            notificationButton.layer.shadowOpacity = 0.5
            notificationButton.layer.cornerRadius = notificationButton.frame.width / 2
        }
    }
    
    @IBOutlet weak var noTravelsMessageView: UIView!{
        didSet{
            noTravelsMessageView.layer.borderWidth = 1.0
            noTravelsMessageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var notificationsTapView: UIView!
    
    @IBOutlet weak var notificationBadgeView: UIView!{
        didSet{
            self.notificationBadgeView.layer.shadowColor = UIColor.black.cgColor
            self.notificationBadgeView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.notificationBadgeView.layer.shadowRadius = 1.0
            self.notificationBadgeView.layer.shadowOpacity = 0.5
            self.notificationBadgeView.layer.masksToBounds = false
            self.notificationBadgeView.layer.cornerRadius = self.notificationBadgeView.frame.height/2
            self.notificationBadgeView.layer.borderColor = UIColor.white.cgColor
            self.notificationBadgeView.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var notificationBadgeCountLabel: UILabel!
    
    // MARK: - Properties
    
    let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    var profileImageChanged: Bool = false

    var favorites: [Favorite] = []{
        didSet{
            if self.favorites.count > 0{
                self.noFavoritesView.isHidden = true
                self.favoritesCollectionView.isHidden = false
            } else {
                self.noFavoritesView.isHidden = false
                self.favoritesCollectionView.isHidden = true
            }
        }
    }
    
    var noMoreFavorites: [Favorite] = []
    
    var userHistory: [UserHistory] = []{
        didSet{
            if self.userHistory.count > 0{
                self.noTravelsView.isHidden = true
                self.historyTripsCollectionView.isHidden = false
            } else {
                self.noTravelsView.isHidden = false
                self.historyTripsCollectionView.isHidden = true
            }
        }
    }
    
    private var countries = [Country]()
    
    var user: User?
    
    var phoneCountry = ""
    
    var newNotifications = false{
        didSet{
            if newNotifications{
                self.notificationBadgeView.isHidden = false
            } else {
                self.notificationBadgeView.isHidden = true
            }
        }
    }
    
    var notifications = [Notif]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.setupViews()
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleNotificationTap(_:)))
        
        self.notificationsTapView.addGestureRecognizer(tap)
        
        aboutMeTextView.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated(_:)), name: Notification.Name("FavoritesUpdated"), object: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.updateFavourites()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        setNotificationBadge()
        
    }
    
    func setNotificationBadge(){
        // TODO: enable when done
//        APIManager.sharedInstance.getNotifications(){
//            result, notifications in
//            self.notifications = notifications.sorted(by: {$0.createdDate.compare($1.createdDate) == .orderedDescending})
//            let unreadNotif = notifications.filter({!$0.read})
//            if unreadNotif.count == 0{
//                self.notificationBadgeView.isHidden = true
//            } else {
//                self.notificationBadgeView.isHidden = false
//                if unreadNotif.count <= 99{
//                    self.notificationBadgeCountLabel.text = "\(unreadNotif.count)"
//                } else {
//                    self.notificationBadgeCountLabel.text = "99+"
//                }
//            }
//        }
    }
   
    
    func fetchData() {
        self.profileImageLoading.startAnimating()
        
        self.emailTextField.text = "John"
        self.nameTextField.text = "Doe"
        self.lastnameTextField.text = "johndoe@test.com"
        self.phoneFlagLabel.text = "🇺🇾"
        self.phoneCountry = "Uruguay"
        self.phonePrefix.text = "+598"
        
        self.aboutMeTextView.text = NSLocalizedString("Add something about yourself!", comment: "")
        self.aboutMeTextView.textColor = UIColor.lightGray
        
        self.profileImageLoading.stopAnimating()
        self.editProfileImageView.image = Asset.userTestPhoto.image
        
        // TODO: Add favorites and history

    }
    
    func setupViews() {
        
        self.notificationImage.image = UIImage(named: "notification")
        
        self.logoutButton.layoutIfNeeded()
        self.logoutButton.layer.cornerRadius = self.logoutButton.frame.height/7
        self.logoutButton.layer.masksToBounds = true
        self.logoutButton.layer.borderWidth = 1
        self.logoutButton.layer.borderColor = UIColor.white.cgColor
        self.logoutButton.activityIndicatorColor = UIColor.white
        
        self.saveChangesButton.layoutIfNeeded()
        self.saveChangesButton.layer.cornerRadius = self.saveChangesButton.frame.height/7
        self.saveChangesButton.layer.masksToBounds = true
        self.saveChangesButton.activityIndicatorColor = UIColor.white
        
        self.nameTextField.underlined(color: UIColor.white, width: 1.0)
        self.lastnameTextField.underlined(color: UIColor.white, width: 1.0)
        self.emailTextField.underlined(color: UIColor.white, width: 1.0)
        self.phoneTextField.underlined(color: UIColor.white, width: 1.0)
        
        self.nameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.emailTextField.delegate = self
        
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self

        historyTripsCollectionView.delegate = self
        historyTripsCollectionView.dataSource = self
        historyTripsCollectionView.isMultipleTouchEnabled = false
        historyTripsCollectionView.allowsSelection = false
        let destNib = UINib(nibName: "DestinationCellView", bundle: nil)
        historyTripsCollectionView.register(destNib, forCellWithReuseIdentifier: "DestinationCellView")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.aboutMeTextView.layoutIfNeeded()
        self.aboutMeTextView.changeBorderColor(newColor: UIColor.white)
    }
    
    // MARK: - TextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Add something about yourself!", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1
        
        // Try to find next responder
        let nextResponder=textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    // MARK: - Actions
    
    // function which is triggered when handleTap is called
    @objc func handleNotificationTap(_ sender: UITapGestureRecognizer) {
        self.animateViewBounceAndZoom(viewToAnimate: self.notificationButton)
        guard let vc = self.homeStoryboard.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC else { return }
        vc.delegate = self
        vc.notifications = self.notifications
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setAsRead(value: Bool) {
        // TODO: enable when done
//        if value {
//            APIManager.sharedInstance.readNotifications(){
//                result in
//                if result == .success {
//                    self.setNotificationBadge()
//                }
//            }
//
//        }
    }
    
    @IBAction func handleEditProfileImageButton(_ sender: Any) {
        
        let pickerController = DKImagePickerController()
        pickerController.UIDelegate = CustomUIDelegate()
        pickerController.assetType = .allPhotos
        pickerController.singleSelect = true
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                //Gets a fullscreen image for the asset to show in the CollectionView
                asset.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                    
                    self.profileImageChanged = true
                    self.editProfileImageView.image = image
                    
                })
            }
        }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveDataTapped(_ sender: UIButton) {
        if self.validateData(){
            // TODO
        
        }
    }
    
//    func updateProfileImage(name:String,lastname:String,aboutMe:String,phoneCountry:String,phone:String){
//        let filename = "profile.jpg"
//
//        var localsFileToUpload = [Int:[String]]()
//
//        if !FilesManager.sharedInstance.removeMedia(filename: filename) {
//            print("Error deleting provider profile image file")
//        }
//        let keyPath = "users/\(self.user?.id ?? "")/profile.jpg"
//
//
//        if FilesManager.sharedInstance.saveMedia(UIImageJPEGRepresentation(self.editProfileImageView.image!, 0.8)!, filename: filename) {
//
//
//            let thumbnailKeyPath = "users/\(self.user?.id ?? "")/profile-thumbnail.jpg"
//            let thumbnailFilename = "profile-thumbnail.jpg"
//            let thumbnailImage = self.editProfileImageView.image?.resize(targetSize: CGSize(width: 200, height: 200))
//
//            if !FilesManager.sharedInstance.removeMedia(filename: thumbnailFilename) {
//                print("Error deleting provider profile thumbnail file")
//            }
//
//
//            if FilesManager.sharedInstance.saveMedia(UIImageJPEGRepresentation(thumbnailImage!, 0.8)!, filename: thumbnailFilename) {
//
//                localsFileToUpload[0] = [thumbnailFilename, thumbnailKeyPath]
//                localsFileToUpload[1] = [filename, keyPath]
//
//                for file in localsFileToUpload{
//                    S3Manager.sharedInstance.uploadToS3(url: URL(fileURLWithPath: FilesManager.sharedInstance.fileInDocumentsDirectory(file.value[0])), name: file.value[1], completeBlock:  { (success: Bool) -> Void in
//                    })
//                }
//
//                UserRepository.sharedInstance.updateLoggedUser(name: name, lastname: lastname, aboutMe: aboutMe, phoneCountry: phoneCountry, phone: phone, favorites: self.favorites, noMoreFavDest: noMoreFavorites, picture:keyPath, thumbnailPicture: thumbnailKeyPath) { result in
//                    if result == .success {
//                        self.noMoreFavorites.removeAll(keepingCapacity: false)
//                        APIHelper.sharedInstance.showSuccesMessage(with: NSLocalizedString("Saved!", comment: ""), and: NSLocalizedString("Your data has been updated.", comment: ""))
//                    } else {
//                        APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Save error.", comment: ""), and: NSLocalizedString("Please try again.", comment: ""))
//                    }
//                }
//            }
//
//        }
//    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidName(_ testStr:String) -> Bool {
        let nameRegEx = "[A-Za-z\\s]+"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    func isValidPhone(_ testStr:String) -> Bool {
        let phoneRegEx = "[0-9]*"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: testStr)
    }
    
    func validateData() -> Bool{
        if let name = self.nameTextField.text, let lastname = self.lastnameTextField.text, let phone = self.phoneTextField.text {
            if !isValidName(name){
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid name", comment: ""), and: "")
                return false
            } else if !isValidName(lastname){
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid lastname", comment: ""), and: "")
                return false
            } else if !isValidPhone(phone.trimmingCharacters(in: .whitespacesAndNewlines)) {
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid phone number", comment: ""), and: "")
                return false
            }
        }
        return true
    }
    
    @IBAction func selectCountryTapped(_ sender: UIButton) {
        if self.countries.isEmpty {
            // TODO: Set countries
        } else {
            self.addActionSheetPicker(sender)
        }
    }
    
    func addActionSheetPicker(_ sender: UIButton){
        let prevCountryValue = self.phonePrefix.text
        let prevPhoneCountryValue = self.phoneCountry
        let acp = ActionSheetStringPicker(title: "", rows: self.countries.map{$0.name}, initialSelection: 0, doneBlock: {
            picker, values, indexes in
            
            self.phonePrefix.text = self.countries[values].dial_code
            self.phoneCountry = self.countries[values].name
            self.phoneFlagLabel.text = self.countries[values].flag
            return
        }, cancel: {
            ActionStringCancelBlock in
            self.phonePrefix.text = prevCountryValue
            self.phoneCountry = prevPhoneCountryValue
            return }, origin: sender)
        
        acp?.setTextColor(Colors.firstGradientColor)
        acp?.pickerBackgroundColor = UIColor.white
        acp?.toolbarBackgroundColor = UIColor.white
        acp?.toolbarButtonsColor = Colors.firstGradientColor
        acp?.show()
    }
    
    @IBAction func handleLogoutButton(_ sender: UIButton) {
        
        // TODO: logout remote action
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
        
    }
    
    @IBAction func aboutUsTapped(_ sender: UIButton) {
        guard let vc = self.homeStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as? AboutUsVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleFavoritesUpdated(_ notification: Foundation.Notification) {
        //TODO: Get favorites again
    
    }
    
}

open class CustomUIDelegate: DKImagePickerControllerDefaultUIDelegate {
    
    open override func imagePickerControllerCreateCamera(_ imagePickerController: DKImagePickerController) -> UIViewController {
        
        let picker = CustomCamera()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }
    
}

extension ProfileTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favoritesCollectionView {
            return favorites.count
        } else {
            return userHistory.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == favoritesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionCell", for: indexPath) as! FavoriteCollectionCell
            
            let favorite = favorites[indexPath.row]
            cell.destinationLabel.text = favorite.name
            cell.removeButton.addTarget(self, action: #selector(handleRemoveButton(_:)), for: .touchUpInside)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCellView", for: indexPath) as! DestinationCell
            
            let history = userHistory[indexPath.row]
            cell.destinationLabel.text = history.name.capitalized
            cell.destinationBackgroundImage.kf.indicatorType = .activity
            cell.destinationBackgroundImage.kf.setImage(with: URL(string: history.thumbnailUrl), options: [.transition(.fade(0.2))])
//            for dest in travelGroup.destinations {
//            cell.cityLabel.text = "\(cell.cityLabel.text!)\(travelGroup.destinations[0].destination?.city ?? ""), "
//            }
//            cell.cityLabel.text?.removeLast(2)
            return cell
        }
    }
    
    @objc func handleRemoveButton(_ sender: UIButton) {
        let touchPoint = sender.convert(CGPoint.zero, to: self.favoritesCollectionView)
        if let clickedIndexPath = self.favoritesCollectionView.indexPathForItem(at: touchPoint) {
            self.noMoreFavorites.append(favorites[clickedIndexPath.row])
            let removeDest = self.favorites.remove(at: clickedIndexPath.row)
            self.noMoreFavorites.append(removeDest)
            self.favoritesCollectionView.deleteItems(at: [clickedIndexPath])
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == favoritesCollectionView {
            let size = (favorites[indexPath.row].name as NSString).size(withAttributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0)])
            return CGSize(width: size.width + 65, height: 40)
        } else {
            return CGSize(width: 200, height: 100)
        }
    }
    
}

