//
//  NewCell.swift
//  RSSFeed
//
//  Created by Nikolay Petrov on 31/07/2023.
//

import UIKit

class NewCell: UITableViewCell {
    enum Reuse {
        static let identifier = "cell"
    }
    
    private let cellImage = UIImageView()
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpImage()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImage() {
        addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        ])
    }
    
    private func setUpLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 5)
        ])
    }
    
    func updateImage(_ image: UIImage) {
        cellImage.image = image
    }
    
    func updateTitle(_ title: String) {
        label.text = title
    }
}
