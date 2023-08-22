//
//  FeedCollectionViewCell.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 21.08.2023.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let documentIDLabel = UILabel()
    let commentButton = UIButton()
    
    // MARK: - Properties
    
    static let identifier = "FeedCollectionViewCell"
    var buttonTapHandler: (() -> Void)?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setUpView(){
        contentView.backgroundColor = .systemBackground
        
        //imageview
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = (contentView.frame.size.width / 4)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(contentView.bounds.height * 0.5)
            make.width.equalTo(contentView.bounds.width * 0.8)
        }
        
        
        //label
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        
        //commentbutton
        contentView.addSubview(commentButton)
        commentButton.configuration = .borderless()
        
        commentButton.setTitle("Comment", for: .normal)
        commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        commentButton.semanticContentAttribute = .forceRightToLeft
        commentButton.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        commentButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 60
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowOpacity = 5
    }
    
    // MARK: - Actions
    @objc func commentTapped(){
        buttonTapHandler?()
    }
}
