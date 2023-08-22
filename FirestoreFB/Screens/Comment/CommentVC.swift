//
//  CommentVC.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 21.08.2023.
//

import UIKit
import Firebase

class CommentVC: UIViewController {
    
    // MARK: - UI Elements
    let commentTF = UITextField()
    let tableView = UITableView()
    let commentButton = UIButton()
    let docID = UILabel()
    // MARK: - Properties
    var postedByArray = [String]()
    var commentPostArray = [String]()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addGesture()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getComments()
    }
    
    // MARK: - Functions
    private func setUpView(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Comments"
        
        //tableview
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsFocus = false
        tableView.allowsSelection = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        //commentTF
        view.addSubview(commentTF)
        commentTF.borderStyle = .roundedRect
        commentTF.placeholder = "Comment"
        commentTF.textAlignment = .center
        commentTF.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-50)
        }
        
        //commentButton
        view.addSubview(commentButton)
        commentButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        commentButton.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        commentButton.configuration = .borderless()
        commentButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(commentTF.snp.right)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    func addGesture(){
        commentTF.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func getComments(){
        let firestore = Firestore.firestore()
        
        if let docID = docID.text {
            firestore.collection("Posts").document(docID).collection("Comments").getDocuments { docs, error in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                }else {
                    if docs?.isEmpty != true {
                        self.postedByArray.removeAll()
                        self.commentPostArray.removeAll()
                        
                        for document in docs!.documents {
                            
                            if let postedBy = document.get("postedBy") as? String {
                                self.postedByArray.append(postedBy)
                            }
                            if let commentPost = document.get("commentPost") as? String {
                                self.commentPostArray.append(commentPost)
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    
    // MARK: - Actions
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func commentTapped(){
        let firestore = Firestore.firestore()
        
        if let docID = docID.text {
            let commentPost = ["commentPost" : commentTF.text ?? "", "postedBy": Auth.auth().currentUser!.email!] as [String : Any]
            firestore.collection("Posts").document(docID).collection("Comments").addDocument(data: commentPost) { error in
                if error != nil {
                    print(error!.localizedDescription)
                }else {
                    self.getComments()
                    self.tableView.reloadData()
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension CommentVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentPostArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.userMailLabel.text = postedByArray[indexPath.row]
        cell.userCommentLabel.text = commentPostArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}
