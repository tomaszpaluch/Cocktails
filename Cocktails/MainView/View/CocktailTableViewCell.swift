//
//  CocktailTableViewCell.swift
//  Cocktails
//
//  Created by Tomasz Paluch on 09/05/2022.
//  Copyright © 2022 tomaszpaluch. All rights reserved.
//

import UIKit

class CocktailTableViewCell: UITableViewCell {
    private let thumbnail: UIImageView
    private let nameLabel: UILabel
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        thumbnail = UIImageView()
        nameLabel = UILabel()
        
        thumbnail.contentMode = .scaleAspectFill
        
        nameLabel.font = .systemFont(ofSize: 17)
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(nameLabel)
        
        setupThumbnailConstraints()
        setupNameLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupThumbnailConstraints() {
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnail.topAnchor.constraint(
            equalTo: topAnchor,
            constant: 4
        ).isActive = true
        thumbnail.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -4
        ).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor).isActive = true
        thumbnail.leftAnchor.constraint(
            equalTo: leftAnchor,
            constant: 24
        ).isActive = true
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(
            equalTo: rightAnchor,
            constant: -24
        ).isActive = true
    }
    
    func setup(_ name: String, image: UIImage?) {
        thumbnail.image = image
        nameLabel.text = name
    }
}

