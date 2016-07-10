//
//  OnBoardViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 6/6/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class OnBoardViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {

    @IBOutlet weak var setupText: UILabel!
    @IBOutlet weak var cgName: UILabel!
    @IBOutlet weak var cgPhoneNumber: UILabel!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    var settings = Settings.sharedInstance
    
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func lookupButtonPressed(sender: AnyObject) {
        if self.cgName.hidden == true{
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            print("Denied")
        case .Authorized:
            //2
            self.displayContactList()
        case .NotDetermined:
            //3
            self.promptForAddressBookRequestAccess()
        }
        }else{
            NSUserDefaults.standardUserDefaults().setObject(cgName.text, forKey: "CareGiverName")
            NSUserDefaults.standardUserDefaults().setObject(cgPhoneNumber.text, forKey: "CareGiverNumber")
//            let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! BMTabBarController
//            self.navigationController?.presentViewController(tabBarVC, animated: true, completion: { 
//                let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
//                appDelegate.window!.rootViewController = tabBarVC
//            })
            self.navigationController?.dismissViewControllerAnimated(true, completion: {
                let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
                let viewController = appDelegate.window!.rootViewController as! BMTabBarController
                viewController.selectedIndex = 0
            })
        }
    }
    
    @IBAction func changeButtonPressed(sender: AnyObject) {
        self.displayContactList()
    }
    
    
    func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    print("Just denied")
                } else {
                    print("Just authorized")
                    self.displayContactList()
                }
            }
        }
    }
    
    func displayContactList(){
        let vc = ABPeoplePickerNavigationController()
        vc.peoplePickerDelegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue()
        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue()
        let unmanagedPhones = ABRecordCopyValue(person, kABPersonPhoneProperty)
        let phones: ABMultiValueRef =
            Unmanaged.fromOpaque(unmanagedPhones.toOpaque()).takeUnretainedValue()
                as NSObject as ABMultiValueRef
        
        let countOfPhones = ABMultiValueGetCount(phones)
        
        //        for index in 0..<countOfPhones{
        let unmanagedPhone = ABMultiValueCopyValueAtIndex(phones, 0)
        let phone: String = Unmanaged.fromOpaque(
            unmanagedPhone.toOpaque()).takeUnretainedValue() as NSObject as! String
        //
        //            print(phone)
        //        }
        self.cgName.text = "\(firstName) \(lastName)"
        self.cgPhoneNumber.text = phone
        self.cgName.hidden = false
        self.cgPhoneNumber.hidden = false
        self.changeButton.hidden = false
        self.lookupButton.setTitle("Done", forState: .Normal)
        settings.careGiverName = self.cgName.text
        settings.careGiverNumber = self.cgPhoneNumber.text
    }

}
