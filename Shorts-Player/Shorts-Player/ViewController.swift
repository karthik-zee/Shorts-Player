//
//  ViewController.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit

struct VideoModel {
    let caption: String
}

let customColor = UIColor(red: 15/255.0, green: 6/255.0, blue: 23/255.0, alpha: 1.0)

class ViewController: UIViewController {
    
    var currentlyPlayingCell: CollectionViewCell?
    
    private var currentlyPlayingCellIndex: Int?
    
    var assets: [Asset] = [Asset]()
    
    private var topBar:UIView = {
        let view = UIView()
        view.backgroundColor = customColor
        return view
    }()
    
    private var bottomBar:UIView = {
        let view = UIView()
        view.backgroundColor = customColor
        return view
    }()
    
    
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
        setupBottomBar()
        setupCollectionView()

        APICaller.shared.fetchVideos { [weak self] items in
            // Use the avcURI array in your view controller
            DispatchQueue.main.async {
                // Here, you can update your UI or perform any other operations with avcURI
                print("Fetched avcURI:", items)
                
                self?.assets = items
                print(self?.assets)
                self?.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("videos array after 2 seconds:", self?.assets)
                }
            }
        }
        print("videos array - after api call - ",self.assets)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    private func setupTopBar(){
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBottomBar(){
        view.addSubview(bottomBar)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBar.heightAnchor.constraint(equalToConstant: 50),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {

//        view.backgroundColor = .red
        
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.backgroundColor = .red
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        if indexPath.row != currentlyPlayingCellIndex {
            cell.stopVideoPlayback()
        }
        print("from cellforitemat func-",indexPath.row)
        cell.configure(with: assets[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? CollectionViewCell {
            videoCell.avPlayer?.pause()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? CollectionViewCell {
            videoCell.avPlayer?.play()
        }
    }
}
