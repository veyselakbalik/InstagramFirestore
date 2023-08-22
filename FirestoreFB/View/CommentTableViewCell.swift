//
//  CommentTableViewCell.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 21.08.2023.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    let userMailLabel = UILabel()
    let userCommentLabel = UILabel()
    
    
    // MARK: - Properties
    
    static let identifier = "CommentTableViewCell"
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setUpView(){
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(userMailLabel)
        userMailLabel.font = .boldSystemFont(ofSize: 24)
        userMailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(userCommentLabel)
        userCommentLabel.numberOfLines = 3
        userCommentLabel.textAlignment = .center
        userCommentLabel.textColor = .systemGray
        userCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(userMailLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
    }

}
