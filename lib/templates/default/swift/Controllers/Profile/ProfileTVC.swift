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
    
    private let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    var profileImageChanged: Bool = false

    var favorites: [Favorite] = []{
        didSet{
            self.noFavoritesView.isHidden = self.favorites.count > 0 ? true : false
            self.favoritesCollectionView.isHidden = self.favorites.count > 0 ? false : true
        }
    }
    
    var noMoreFavorites: [Favorite] = []
    
    var userHistory: [UserHistory] = []{
        didSet{
            self.noTravelsView.isHidden = self.userHistory.count > 0 ? true : false
            self.historyTripsCollectionView.isHidden = self.userHistory.count > 0 ? false : true
        }
    }
    
    private var countries = [Country]()
    
    var user: User?
    
    var phoneCountry = ""
    
    var newNotifications = false{
        didSet{
            self.notificationBadgeView.isHidden = !newNotifications
        }
    }
    
    var notifications = [Notif]()
    
    // MARK: - Life cycle

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

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        setNotificationBadge()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.aboutMeTextView.layoutIfNeeded()
        self.aboutMeTextView.changeBorderColor(newColor: UIColor.white)
    }
    
    // MARK: - Private

    private func setNotificationBadge(){
        
        // TODO: Enable when done
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
   
    private func fetchData() {

        // TODO: change for local or remote user data

        self.profileImageLoading.startAnimating()
        
        self.emailTextField.text = "John"
        self.nameTextField.text = "Doe"
        self.lastnameTextField.text = "johndoe@test.com"
        self.phoneFlagLabel.text = "🇺🇾"
        self.phoneCountry = "Uruguay"
        self.phonePrefix.text = "+598"
        
        self.aboutMeTextView.text = "Add something about yourself!"
        self.aboutMeTextView.textColor = UIColor.lightGray
        
        self.profileImageLoading.stopAnimating()

        self.editProfileImageView.image = Asset.userTestPhoto.image
        
        // TODO: Add favorites and history or something like that if needed

    }
    
    private func setupViews() {
        
        self.notificationImage.image = Asset.notification.image
        
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
    
    // MARK: - TextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {
            textView.text = "Add something about yourself!"
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
    
    /// Function which is triggered when handleTap is called
    @objc func handleNotificationTap(_ sender: UITapGestureRecognizer) {

        guard let vc = self.homeStoryboard.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC else { return }
        self.animateViewBounceAndZoom(viewToAnimate: self.notificationButton)
        vc.delegate = self
        vc.notifications = self.notifications
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setAsRead(value: Bool) {
        // TODO: Enable when done
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
        
        DKImageExtensionController.registerExtension(extensionClass: CustomCamera.self, for: .camera)
        
        pickerController.assetType = .allPhotos
        pickerController.singleSelect = true
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                //Gets a fullscreen image for the asset to show in the CollectionView
                asset.fetchFullScreenImage(completeBlock: { (image, info) in
                    
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

    func validateData() -> Bool{
        if !self.nameTextField.isName(){
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid name", comment: ""), and: "")
            return false
        } 
        if !self.lastnameTextField.isName(){
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid lastname", comment: ""), and: "")
            return false
        }
        if !self.phoneTextField.isPhone() {
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid phone number", comment: ""), and: "")
            return false
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
        
        acp?.setTextColor(ColorConstants.firstGradientColor)
        acp?.pickerBackgroundColor = UIColor.white
        acp?.toolbarBackgroundColor = UIColor.white
        acp?.toolbarButtonsColor = ColorConstants.firstGradientColor
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

            cell.configure(with: history)

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
            let size = (favorites[indexPath.row].name as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)])
            return CGSize(width: size.width + 65, height: 40)
        } else {
            return CGSize(width: 200, height: 100)
        }
    }
    
}

