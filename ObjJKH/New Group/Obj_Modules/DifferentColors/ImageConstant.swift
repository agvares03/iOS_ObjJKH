//
//  ImageConstant.swift
//  ObjJKH
//
//  Created by Роман Тузин on 11.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

struct myImages {
    // notice
    #if isMupRCMytishi
        static let notice_image = UIImage(named: "notice_Mup")
    #else
        static let notice_image = UIImage(named: "notice")
    #endif
    
    // application
    #if isMupRCMytishi
        static let application_image = UIImage(named: "application_Mup")
    #else
        static let application_image = UIImage(named: "application")
    #endif
    
    // poll
    #if isMupRCMytishi
        static let poll_image = UIImage(named: "poll_Mup")
    #else
        static let poll_image = UIImage(named: "poll")
    #endif
    
    // meters
    #if isMupRCMytishi
        static let meters_image = UIImage(named: "meters_Mup")
    #else
        static let meters_image = UIImage(named: "meters")
    #endif
    
    // saldo
    #if isMupRCMytishi
        static let saldo_image = UIImage(named: "application_Mup")
    #else
        static let saldo_image = UIImage(named: "application")
    #endif
    
    // payment
    #if isMupRCMytishi
        static let payment_image = UIImage(named: "payment_Mup")
    #else
        static let payment_image = UIImage(named: "payment")
    #endif
    
    // webs_img
    #if isMupRCMytishi
        static let webs_image = UIImage(named: "application_Mup")
    #else
        static let webs_image = UIImage(named: "application")
    #endif
    
    // exit_img
    #if isMupRCMytishi
        static let exit_image = UIImage(named: "application_Mup")
    #else
        static let exit_image = UIImage(named: "application")
    #endif
    
    // person
    #if isMupRCMytishi
        static let person_image = UIImage(named: "person_Mup")
    #else
        static let person_image = UIImage(named: "person")
    #endif
    
    // lock
    #if isMupRCMytishi
        static let lock_image = UIImage(named: "lock_Mup")
    #else
        static let lock_image = UIImage(named: "lock")
    #endif
    
    // phone
    #if isMupRCMytishi
        static let phone_image = UIImage(named: "phone_Mup")
    #else
        static let phone_image = UIImage(named: "phone")
    #endif
    
}
