//
//  CollectionViewCell.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupIconStackView()
        setupVolumeMuteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupVolumeMuteButton() {
        let volumeMuteImage: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "volumeMute")
            return image
        }()
        
        contentView.addSubview(volumeMuteImage)
        volumeMuteImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            volumeMuteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 329),
            volumeMuteImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 63)
        ])
        
    }
    
    private func setupIconStackView() {
        let iconStackView = UIStackView(arrangedSubviews: [watchStackView, myListStackView, shareStackView])
        iconStackView.axis = .vertical
        iconStackView.alignment = .center
        iconStackView.spacing = 10
        
        contentView.addSubview(iconStackView)
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 318),
            iconStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 475)
        ])
    }
    
    private var watchStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [watchImage, watchLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }
    
    private var myListStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [myListImage, myListLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }
    
    private var shareStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [shareImage, shareLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }
    
    private var watchImage: UIImageView {
        let image = UIImageView(image: UIImage(named: "watch"))
        return image
    }
    
    private var myListImage: UIImageView {
        let image = UIImageView(image: UIImage(named: "addToPlaylist"))
        return image
    }
    
    private var shareImage: UIImageView {
        let image = UIImageView(image: UIImage(named: "iosShare"))
        return image
    }
    
    private var watchLabel: UILabel {
        let label = UILabel()
        label.text = "Watch"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private var myListLabel: UILabel {
        let label = UILabel()
        label.text = "My List"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private var shareLabel: UILabel {
        let label = UILabel()
        label.text = "Share"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
}
