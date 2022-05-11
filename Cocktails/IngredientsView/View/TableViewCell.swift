//
//  TableViewCell.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    private let checkLabel: UILabel!
    private let categoryNameLabel: UILabel!
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        checkLabel = UILabel()
        categoryNameLabel = UILabel()
        
        checkLabel.text = "✓"
        checkLabel.font = .systemFont(ofSize: 17)
        checkLabel.textColor = .black
        
        categoryNameLabel.font = .systemFont(ofSize: 17)
        categoryNameLabel.textColor = .black
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.addSubview(checkLabel)
        contentView.addSubview(categoryNameLabel)
        
        setupCheckLabelConstraints()
        setupCategoryNameLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCheckLabelConstraints() {
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        checkLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkLabel.leftAnchor.constraint(
            equalTo: leftAnchor,
            constant: 24
        ).isActive = true
    }
    
    private func setupCategoryNameLabelConstraints() {
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoryNameLabel.rightAnchor.constraint(
            equalTo: rightAnchor,
            constant: -24
        ).isActive = true
    }
    
    func setup(_ name: String, isCurrent: Bool) {
        categoryNameLabel.text = name
        checkLabel.isHidden = !isCurrent
    }
}

