//
//  BasicViewController.swift
//  Diff
//
//  Created by Евгений Березенцев on 04.05.2022.
//

import UIKit

enum Section: CaseIterable {
    case main
}

enum Layout {
    case line
    case high
}

class BasicViewController: UICollectionViewController {
    
    let searchController = UISearchController()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section,String>!
    
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Section,String> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredItems)
        return snapshot
    }
    
    var layout: [Layout: UICollectionViewLayout] = [:]
    var activeLayout: Layout = .line
    
    
    private let items = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California",
        "Colorado", "Connecticut", "Delaware", "Florida",
        "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
        "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
        "Massachusetts", "Michigan", "Minnesota", "Mississippi",
        "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
        "New Jersey", "New Mexico", "New York", "North Carolina",
        "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
        "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
        "Texas", "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    private var filteredItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        filteredItems = items

        //Searchbar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        // DataSource
        createDataSource()
        //Layout
        layout[.line] = generateLineLayout()
        layout[.high] = generateSquareLayout()
        if let layout = layout[activeLayout] {
            collectionView.collectionViewLayout = layout
        }
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BasicCell
            cell.cellLabel.text = itemIdentifier
            cell.layer.cornerRadius = 10
            return cell
        })
        dataSource.apply(filteredItemsSnapshot)
       
    }
    
//    private func createSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section,String>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(filteredItems)
//        dataSource.apply(snapshot)
//    }

    
    private func generateLineLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        
        let section = NSCollectionLayoutSection(group: group)
    

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func generateSquareLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        
        let section = NSCollectionLayoutSection(group: group)
    

        return UICollectionViewCompositionalLayout(section: section)
    }

    @IBAction func switchLayout(_ sender: UIBarButtonItem) {
        switch activeLayout {
        case .line:
            activeLayout = .high
            collectionView.setCollectionViewLayout(generateSquareLayout(), animated: true)
        case .high:
            activeLayout = .line
            collectionView.setCollectionViewLayout(generateLineLayout(), animated: true)
        }
    }
    

}

extension BasicViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchName = searchController.searchBar.text, searchName.isEmpty == false {
            filteredItems = items.filter({ item in
                item.localizedCaseInsensitiveContains(searchName)
            })
        } else {
            filteredItems = items
        }
//        createSnapshot()
        dataSource.apply(filteredItemsSnapshot)
    }
}
