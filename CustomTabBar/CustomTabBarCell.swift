//
//  CustomTabBarCell.swift
//  CustomTabBar
//
//  Created by 고정근 on 2022/05/05.
//

import Foundation
import UIKit

class CustomTabBarCell: UICollectionViewCell {
    
    static let identifier = "CustomTabBarCell"
    
    private let tabTitle: UILabel = {
        let title = UILabel()
        title.text = "title"
        
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
//        backgroundColor = .yellow
        contentView.addSubview(tabTitle)
        tabTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tabTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.tabTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            ])
        
        
    }
    
    func updateUI(title: String){
        print(title)
        tabTitle.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
