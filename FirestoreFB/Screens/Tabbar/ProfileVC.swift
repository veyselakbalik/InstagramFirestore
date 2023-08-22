//
//  ProfileVC.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 18.08.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - UI Elements
    private let profileImage = UIImageView()
    private let logOutButton = UIButton()
    private let imagePicker = UIImagePickerController()
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addGesture()
    }
    
    // MARK: - Functions
    private func setUpView(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // profile image
        view.addSubview(profileImage)
        profileImage.image = UIImage(systemName: "plus")
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 4
        profileImage.layer.cornerRadius = 20
        profileImage.layer.borderColor = UIColor.systemBlue.cgColor
        profileImage.isUserInteractionEnabled = true
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(140)
        }
        
        //logoutbutton
        view.addSubview(logOutButton)
        logOutButton.configuration = .tinted()
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.tintColor = .red
        logOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        logOutButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(gesture)
    }
    
    
    // MARK: - Actions
    @objc func logOutTapped(){
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        navigationController?.pushViewController(LoginVC(), animated: false)
    }
    
    @objc func imageTapped(){
        //imagepicker
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImage.image = editedImage
        }
        dismiss(animated: true)
        getImage()
        
    }
    func getImage(){
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = self.profileImage.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metadata, error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            // DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference?
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "date" : FieldValue.serverTimestamp()] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    print(error!.localizedDescription)
                                }else {
                                    self.profileImage.image = UIImage(systemName: "plus")
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
            }
            
        }
    }
    
}

