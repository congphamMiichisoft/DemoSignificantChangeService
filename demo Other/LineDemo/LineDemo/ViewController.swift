//
//  ViewController.swift
//  LineDemo
//
//  Created by Miichi on 5/11/22.
//

import UIKit
import LineSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create Login Button.
           let loginButton = LoginButton()
           loginButton.delegate = self
           
           // Configuration for permissions and presenting.
        loginButton.permissions = [ .profile,]
           loginButton.presentingViewController = self
           
           // Add button to view and layout it.
           view.addSubview(loginButton)
           loginButton.translatesAutoresizingMaskIntoConstraints = false
           loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }


}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
//        hideIndicator()
        print("Login Succeeded.")
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
//        hideIndicator()
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
//        showIndicator()
        print("Login Started.")
    }
}

