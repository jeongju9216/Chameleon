//
//  ChooseFaceCell.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

class SelectCell: UICollectionViewCell {
    var imageView: UIImageView!
    var image: UIImage?
    
    var checkImageView: UIImageView!
    var checkImage: UIImage?
    var noneCheckImage: UIImage?
    
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected)
        }
    }
    
    private let size = 28
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupCell()
    }
    
    //MARK: - Methods
    func setSelected(_ selected: Bool) {
        if selected {
            setSelectedStyle()
        } else {
            setDeselectedStyle()
        }
    }
    
    func setSelectedStyle() {
        checkImageView.image = checkImage
        
        checkImageView.tintColor = .mainColor
        checkImageView.alpha = 1
        checkImageView.layer.borderColor = UIColor.mainColor.cgColor
        checkImageView.backgroundColor = .white
        
        contentView.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    func setDeselectedStyle() {
        checkImageView.image = noneCheckImage
        
        checkImageView.tintColor = .black
        checkImageView.alpha = 0.5
        checkImageView.layer.borderColor = UIColor.darkGray.cgColor
        
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    //MARK: - Setup
    private func setupCell() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.5
        
        setupImageView()
        setupImages()
        setupCheckImageView()
        
        setSelectedStyle()
    }

    private func setupImages() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(size))
        noneCheckImage = UIImage(systemName: "circle.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate)
        checkImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate)
    }
    
    private func setupCheckImageView() {
        checkImageView = UIImageView()
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        checkImageView.image = noneCheckImage
        checkImageView.clipsToBounds = true
        checkImageView.layer.cornerRadius = CGFloat(size) / 2.0
        checkImageView.layer.borderWidth = 2
                        
        contentView.addSubview(checkImageView)
        checkImageView.widthAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
        checkImageView.heightAnchor.constraint(equalTo: checkImageView.widthAnchor).isActive = true
        checkImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        checkImageView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        contentView.addSubview(imageView)
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    func setupImage(_ image: UIImage?) {
        imageView.image = image
    }
}
