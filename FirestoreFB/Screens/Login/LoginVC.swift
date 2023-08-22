//
//  ViewController.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 18.08.2023.
//

import UIKit
import Firebase
import SnapKit

class LoginVC: UIViewController {

    // MARK: - UI Elements
    private let loginLabel = UILabel()
    private let loginMailTF = UITextField()
    private let loginPasswordTF = UITextField()
    private let loginButton = UIButton()
    private let signUpButton = UIButton()
    private let forgotButton = UIButton()
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        if let tabBarController = self.tabBarController{
            tabBarController.tabBar.isHidden = true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUser()
    }
    // MARK: - Functions
    private func setUpView(){
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
    
        //Login Label
        view.addSubview(loginLabel)
        loginLabel.text = "Login"
        loginLabel.textAlignment = .center
        loginLabel.numberOfLines = 0
        loginLabel.font = .boldSystemFont(ofSize: 28)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // LoginTF
        view.addSubview(loginMailTF)
        loginMailTF.translatesAutoresizingMaskIntoConstraints = false
        loginMailTF.placeholder = "E-Mail"
        loginMailTF.textAlignment = .center
        loginMailTF.borderStyle = .roundedRect
        loginMailTF.backgroundColor = .secondarySystemBackground
        loginMailTF.keyboardType = .emailAddress
        loginMailTF.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // LoginPasswordTF
        view.addSubview(loginPasswordTF)
        loginPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        loginPasswordTF.placeholder = "Password"
        loginPasswordTF.textAlignment = .center
        loginPasswordTF.isSecureTextEntry = true
        loginPasswordTF.borderStyle = .roundedRect
        loginPasswordTF.backgroundColor = .secondarySystemBackground
        loginPasswordTF.snp.makeConstraints { make in
            make.top.equalTo(loginMailTF.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        // LoginButton
        view.addSubview(loginButton)
        loginButton.configuration = .filled()
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(loginPasswordTF.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)        }
        
        // Signup
        view.addSubview(signUpButton)
        signUpButton.configuration = .tinted()
        signUpButton.setTitle("Sign up with new account", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)        }
        
        // forgot button
        view.addSubview(forgotButton)
        forgotButton.configuration = .borderless()
        forgotButton.setTitle("Forgot Password", for: .normal)
        forgotButton.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)
        forgotButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)        }
    }
    
    private func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func checkUser(){
        if Auth.auth().currentUser != nil {
            self.navigationController?.pushViewController(TabbarVC(), animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func loginTapped(){
        if let mail = loginMailTF.text?.lowercased(),
           let pass = loginPasswordTF.text?.lowercased() {
            Auth.auth().signIn(withEmail: mail, password: pass) { authdata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    self.navigationController?.pushViewController(TabbarVC(), animated: true)
                }
            }
        }
    }
    
    @objc func signUpTapped(){
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func forgotTapped(){
        if let mail = loginMailTF.text?.lowercased() {
            Auth.auth().sendPasswordReset(withEmail: mail) { error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    self.makeAlert(title: "Password Reset", message: "Check your mail!")
                }
            }
        }
    }

}

