//
//  MainVC.swift
//  FirestoreFB
//
//  Created by Veysel Akbalık on 18.08.2023.
//

import UIKit

class TabbarVC: UITabBarController {

    // MARK: - UI Elements
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Functions
    private func setUpView(){
        view.backgroundColor = .systemBackground
        //Tab Bar Create
        let feedVC = FeedVC()
        let profileVC = ProfileVC()
        
        let nav1 = UINavigationController(rootViewController: feedVC)
        let nav2 = UINavigationController(rootViewController: profileVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        setViewControllers([nav1,nav2], animated: true)
        
        
        //Style
        self.tabBar.tintColor = .systemMint
        self.tabBar.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        self.tabBarController?.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
        self.tabBar.itemPositioning = .fill
        self.tabBar.unselectedItemTintColor = .systemGray
    }
    
    // MARK: - Actions

}
