//
//  FeedVC.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 18.08.2023.
//

import UIKit
import SnapKit
import Firebase
import SDWebImage

class FeedVC: UIViewController {
    
    // MARK: - UI Elements
    
    var collectionView : UICollectionView!
    
    // MARK: - Properties
    
    var userArray = [String]()
    var documentIDArray = [String]()
    var imageArray = [String]()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getDataFromFirestore()
    }
    
    
    
    // MARK: - Functions
    private func setUpView(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        
        
        //collectionview
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        
    }
    
    private func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else {
                if snapshot?.isEmpty != true {
                    self.userArray.removeAll()
                    self.imageArray.removeAll()
                    self.documentIDArray.removeAll()
                    
                    for document in snapshot!.documents {
                        
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        if let postedBy = document.get("postedBy") as? String {
                            self.userArray.append(postedBy)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.imageArray.append(imageUrl)
                            
                        }
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    // MARK: - Actions
    
    
}


extension FeedVC: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
        cell.titleLabel.text = userArray[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: imageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArray[indexPath.row]
        func passID(completion: @escaping (_ data: String) -> Void) {
                completion(documentIDArray[indexPath.row])
            }
        cell.buttonTapHandler = { [weak self] in
            let commentVC = CommentVC()
            commentVC.modalPresentationStyle = .fullScreen
            passID { data in
                commentVC.docID.text = data
                self?.navigationController?.pushViewController(commentVC, animated: true)
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width) * 0.8
        return CGSize(width: width, height: width * 1.2)
    }
    
}

