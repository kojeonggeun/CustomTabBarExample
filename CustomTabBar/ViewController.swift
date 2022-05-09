//
//  ViewController.swift
//  CustomTabBar
//
//  Created by 고정근 on 2022/05/05.
//

import UIKit

class ViewController: UIViewController {
    private let customTabBar: UICollectionView = {
        let tabbarLayout = UICollectionViewFlowLayout()
        tabbarLayout.scrollDirection = .vertical
        tabbarLayout.sectionInset = .zero
        
        let tv = UICollectionView(frame: .zero, collectionViewLayout: tabbarLayout)

        return tv
    }()
    
    private let customCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return cv
    }()
    
    private let indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = .red
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
     }()
    
    
    private let searchBar: UISearchBar = UISearchBar()
    
    lazy var indicatorViewLeading: NSLayoutConstraint = {
        return indicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
    }()
    
//    MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initConstraint()
        
        API.search(keyword: "D").get(completion: { result in
            switch result{
            case .success(let data):
                print(data.body.list)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func initView(){
    
        customTabBar.delegate = self
        customTabBar.dataSource = self
        customTabBar.backgroundColor = .green
        
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
        customCollectionView.backgroundColor = .orange
        
        searchBar.delegate = self
        
        self.view.addSubview(customTabBar)
        self.view.addSubview(customCollectionView)
        self.view.addSubview(searchBar)
        self.view.addSubview(indicatorView)
        
        customTabBar.register(CustomTabBarCell.self, forCellWithReuseIdentifier: CustomTabBarCell.identifier)
        customCollectionView.register(CustomTabBarCell.self, forCellWithReuseIdentifier: CustomTabBarCell.identifier)
    }
    
    func initConstraint(){
        
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            self.customTabBar.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor,constant: 5),
            self.customTabBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.customTabBar.heightAnchor.constraint(equalToConstant: 100),
            
            
            self.indicatorView.topAnchor.constraint(equalTo: self.customTabBar.bottomAnchor),
            self.indicatorViewLeading,
            self.indicatorView.widthAnchor.constraint(equalToConstant: (view.frame.width / 4) - 10),
            self.indicatorView.heightAnchor.constraint(equalToConstant: 5),
            
            self.customCollectionView.topAnchor.constraint(equalTo: self.indicatorView.bottomAnchor,constant: 5),
            self.customCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.customCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.customCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
        ])
        
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == customTabBar {
            return 4
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomTabBarCell.identifier, for: indexPath) as? CustomTabBarCell else { return UICollectionViewCell() }
        
        cell.updateUI(title: "\(indexPath.row)번째")
        return cell
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewWidth = (view.frame.width / 4)
        let leadingDistance = viewWidth * CGFloat(indexPath.row)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
          self?.indicatorViewLeading.constant = leadingDistance
          self?.view.layoutIfNeeded()
        })
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (collectionView.bounds.width <= 0 || collectionView.bounds.height <= 0) {
               return CGSize(width: 0, height: 0)
           }

        if collectionView == customTabBar {
            let collectionViewWidth = collectionView.bounds.width //셀의 넓이
            let collectionViewHeight = collectionView.bounds.height //셀의 높이
            let cellWidth = (collectionViewWidth - 30)/4 //셀 넓이는 한 줄당 4개니까 (전체 크기 - 여백 값) 나누기 4
            let cellHeight = (collectionViewHeight - 10) // 셀 높이는 2개의 줄로 할 예정이니 (전체 높이 - 여백 값) 나누기 2
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            return UICollectionViewFlowLayout.automaticSize
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == customTabBar {
            return 5 // 셀 행 간격
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == customTabBar {
            return 10 // 셀 열 간격
        } else {
            return 0
        }
    }
}
extension ViewController: UISearchBarDelegate {
    
    
}
