//
//  SignInWithAppleID.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//
/*
import Foundation
import UIKit
import AuthenticationServices
class AppleSignIn {
 
 var appleIDProvider = ASAuthorizationAppleIDProvider()
     @IBAction func AppleSignIn(_ sender: Any) {
         let authorizationButton = ASAuthorizationAppleIDButton()
         authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
         
     }
     
     @objc func handleAppleIdRequest() {
     let appleIDProvider = ASAuthorizationAppleIDProvider()
     let request = appleIDProvider.createRequest()
     request.requestedScopes = [.fullName, .email]
     let authorizationController = ASAuthorizationController(authorizationRequests: [request])
     authorizationController.delegate = (self as! ASAuthorizationControllerDelegate)
     authorizationController.performRequests()
     }
     
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
         if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
             let userIdentifier = appleIDCredential.user
             let fullName = appleIDCredential.fullName
             let email = appleIDCredential.email
             print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
     }
     
     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
     // Handle error.
     }
     
    if 1 == 1 {
        appleIDProvider.getCredentialState(forUserID: userID) {
        (credentialState, error) in
    switch credentialState {
    case .authorized:
                 // The Apple ID credential is valid.
        break
        case .revoked:
                 // The Apple ID credential is revoked.
        break
        case .notFound:
                 // No credential was found, so show the sign-in UI.
        default:
        break
     
     }
     
     }
     
     }
}
*/
