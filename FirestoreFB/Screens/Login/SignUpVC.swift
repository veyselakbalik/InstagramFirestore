//
//  SignUpVC.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 18.08.2023.
//

import UIKit
import Firebase
import SnapKit

final class SignUpVC: UIViewController {
    
    // MARK: - UI Elements
    private let signUpLabel = UILabel()
    private let registerEmailTF = UITextField()
    private let registerPasswordTF = UITextField()
    private let registerButton = UIButton()
    private let loginButton = UIButton()
    
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Functions
    private func setUpView(){
        view.backgroundColor = .systemBackground
        
        
        //SignUp Label
        view.addSubview(signUpLabel)
        signUpLabel.text = "Sign Up"
        signUpLabel.textAlignment = .center
        signUpLabel.numberOfLines = 0
        signUpLabel.font = .boldSystemFont(ofSize: 28)
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // EmailTF
        view.addSubview(registerEmailTF)
        registerEmailTF.translatesAutoresizingMaskIntoConstraints = false
        registerEmailTF.placeholder = "E-Mail"
        registerEmailTF.textAlignment = .center
        registerEmailTF.borderStyle = .roundedRect
        registerEmailTF.backgroundColor = .secondarySystemBackground
        registerEmailTF.keyboardType = .emailAddress
        registerEmailTF.snp.makeConstraints { make in
            make.top.equalTo(signUpLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // PasswordTF
        view.addSubview(registerPasswordTF)
        registerPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        registerPasswordTF.placeholder = "Password"
        registerPasswordTF.textAlignment = .center
        registerPasswordTF.borderStyle = .roundedRect
        registerPasswordTF.isSecureTextEntry = true
        registerPasswordTF.backgroundColor = .secondarySystemBackground
        registerPasswordTF.snp.makeConstraints { make in
            make.top.equalTo(registerEmailTF.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // RegisterButton
        view.addSubview(registerButton)
        registerButton.configuration = .filled()
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerPasswordTF.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)        }
        
        // LoginButton
        view.addSubview(loginButton)
        loginButton.configuration = .borderless()
        loginButton.setTitle("Have you registered before?", for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)        }
        
    }
    
    private func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // MARK: - Actions
    @objc func registerTapped(){
        if let mail = registerEmailTF.text?.lowercased(),
           let password = registerPasswordTF.text?.lowercased() {
            Auth.auth().createUser(withEmail: mail, password: password) { authdata, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                } else {
                    self.navigationController?.pushViewController(TabbarVC(), animated: true)
                }
            }
        } 
        
        
    }
    @objc func loginTapped(){
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
}
