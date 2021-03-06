//
//  DetailBookViewController.swift
//  TTOLC
//
//  Created by Dowon on 9/4/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import AudioToolbox
import MessageUI
import Firebase

class DetailBookViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareButtonImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var buyingButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var ref: DatabaseReference!
    var englishText = ""
    var koreanText = ""
    var spanishText = ""
    var indonesianText = ""
    var chineseText = ""
    
    var passedHorBooks = [HorBooks]()
    var passedIndex = 0
    var passedViewController = ""
    var passedImage3Url = ""
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetUp()
        changableObjects()
    }
    
    private func changableObjects() {
        if passedViewController == "ABOUT US" {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\(passedImage3Url)")
            image.loadImage(from: url!)
            titleLabel.text = "REV.JOHN LEE"
            detailLabel.text = "이은식 목사님"
            buyingButton.setTitle("LEAD PASTOR", for: .normal)
            buyingButton.isEnabled = false
            shareButton.alpha = 0
            shareButtonImage.alpha = 0
    
            // taking description text from server
            ref = Database.database().reference().child("aboutUsDescription").child("ourPastor")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let english = dict["englishText"] as! String
                    self.englishText = english
                    self.descriptionTextView.text = self.englishText

                    let korean = dict["koreanText"] as! String
                    self.koreanText = korean
                    let spanish = dict["spanishText"] as! String
                    self.spanishText = spanish
                    let indonesian = dict["indonesianText"] as! String
                    self.indonesianText = indonesian
                    let chinese = dict["chineseText"] as! String
                    self.chineseText = chinese
                }
            })
        }
       
        else if passedViewController == "HISTORY OF REDEMPTION" {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\(passedImage3Url)")
            image.loadImage(from: url!)
            titleLabel.text = "REV.DR.ABRAHAM PARK"
            detailLabel.text = "박윤식 원로목사님"
            buyingButton.setTitle("AUTHOR", for: .normal)
            buyingButton.isEnabled = false
            shareButton.alpha = 0
            shareButtonImage.alpha = 0
            
            // taking description text from server
            ref = Database.database().reference().child("historyOfRedemptionDescription").child("aboutAuthor")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let english = dict["englishText"] as! String
                    self.englishText = english
                    self.descriptionTextView.text = self.englishText

                    let korean = dict["koreanText"] as! String
                    self.koreanText = korean
                    let spanish = dict["spanishText"] as! String
                    self.spanishText = spanish
                    let indonesian = dict["indonesianText"] as! String
                    self.indonesianText = indonesian
                    let chinese = dict["chineseText"] as! String
                    self.chineseText = chinese
                }
            })
        }
        
        else {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\(passedHorBooks[passedIndex].image2Url)")
            image.loadImage(from: url!)
        
            titleLabel.text = passedHorBooks[passedIndex].bookTitle
            detailLabel.text = passedHorBooks[passedIndex].detailTitle
            descriptionTextView.text = passedHorBooks[passedIndex].description
        }
        
    }
    
    private func layoutSetUp() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: image.frame.size.width / 1.6).isActive = true
        
        
        
        
        if screenSize.height <= screenSize.width * 2{
            print("screen ratio is 16:9 as iphone 8")
            shareButtonImage.frame.size.height = 16
            shareButtonImage.frame.size.width = 17
        }
        // if screen ratio is 21:9
        else if screenSize.height >= screenSize.width * 2{
            print("screen ratio is 21:9 as iphone x")
            shareButtonImage.frame.size.height = 16
            shareButtonImage.frame.size.width = 17
        }
        
        // for better touch response, separate image and button then make button size bigger than image.
        shareButton.center = shareButtonImage.center
        shareButton.frame.size.height = 30
        shareButton.frame.size.width = 30
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        buyingButton.layer.borderWidth = 1
        buyingButton.layer.borderColor = UIColor.black.cgColor
            
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowColor = UIColor.black.cgColor
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        if (passedViewController == "ABOUT US") || (passedViewController == "HISTORY OF REDEMPTION") {
            descriptionTextView.topAnchor.constraint(equalTo: languageSegment.bottomAnchor, constant: 10).isActive = true
        }
        else {
            languageSegment.alpha = 0
            descriptionTextView.topAnchor.constraint(equalTo: languageSegment.topAnchor).isActive = true
        }
        
    }
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            descriptionTextView.text = englishText
        }
        else if sender.selectedSegmentIndex == 1 {
            descriptionTextView.text = koreanText
        }
        else if sender.selectedSegmentIndex == 2 {
            descriptionTextView.text = spanishText
        }
        if sender.selectedSegmentIndex == 3 {
            descriptionTextView.text = indonesianText
        }
        if sender.selectedSegmentIndex == 4 {
            descriptionTextView.text = chineseText
        }
        
        descriptionTextView.alpha = 0
        AudioServicesPlaySystemSound(1519)
        UIView.animate(withDuration: 1.0) {
            self.descriptionTextView.alpha = 1
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
    let items = ["http://horaministries.com/about-the-books/"]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)

    
    AudioServicesPlaySystemSound(1519)
    present(ac, animated: true)
    }
    
    @IBAction func buyButtonClicked(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            buyingButton.shake()
        }
        sendEmail()
        AudioServicesPlaySystemSound(1519)
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info.ttolc@gmail.com"])
            mail.setSubject("Request for Buying \(passedHorBooks[passedIndex].bookTitle)")
            mail.setMessageBody("Hello Tree of life church, ", isHTML: true)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Setup Your Email on Mail App", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = UIColor.black
            present(alert, animated: true, completion: nil)
        }
    }

    private func mailComposeController(controller: MFMailComposeViewController,
                           didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }

}


