//
//  CollectionViewCell.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.notoFont(size: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let dotLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "•"
        return label
    }()
    
    let dotLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "•"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupIconStackView()
        setupChevronButton()
        setupVolumeMuteButton()
        setupIconViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(movieDescriptionLabel)
        
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupIconViews() {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            titleLabel, dotLabel1, genreLabel, dotLabel2, ratingLabel
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center // Center-align items
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.spacing = 0 // No spacing between items
        
        contentView.addSubview(horizontalStackView) // Only horizontalStackView is needed
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 0), // Adjust the spacing as needed
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -89),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -104)
        ])

            
        let verticalStackView = UIStackView(arrangedSubviews: [
            movieDescriptionLabel, horizontalStackView
        ])
        verticalStackView.axis = .vertical
        //verticalStackView.alignment = .fill
        verticalStackView.spacing = 4 // Adjust the spacing between cells
        
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 619),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -89),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -104)
        ])
    }

    private func setupVolumeMuteButton() {
        let volumeMuteImage: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "volumeMute")
            return image
        }()
        
        print(contentView.frame.width)
        print(contentView.frame.height)
        
        contentView.addSubview(volumeMuteImage)
        volumeMuteImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            volumeMuteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 329),
            volumeMuteImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 63)
        ])
        
    }
    private func setupChevronButton(){
        let chevronLeft: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "chevronButton")
            return image
        }()
        contentView.addSubview(chevronLeft)
        chevronLeft.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronLeft.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chevronLeft.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 63)
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
            iconStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 522)
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
