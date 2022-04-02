//
//  ChooseFaceCell.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit
import SnapKit

class ChooseFaceCell: UICollectionViewCell {
    var imageView: UIImageView!
    var image: UIImage?
    
    var checkImageView: UIImageView!
    var checkImage: UIImage?
    var noneCheckImage: UIImage?
    
    private let size = 28
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setClickStyle()
            } else {
                setNoneClickStyle()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupCell()
    }
    
    //MARK: - Methods
    private func setClickStyle() {
        checkImageView.image = checkImage
        
        checkImageView.tintColor = .mainColor
        checkImageView.alpha = 1
        checkImageView.layer.borderColor = UIColor.mainColor.cgColor
        
        contentView.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    private func setNoneClickStyle() {
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
        
        setNoneClickStyle()
    }

    private func setupImages() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(size))
        noneCheckImage = UIImage(systemName: "circle.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate)
        checkImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate)
    }
    
    private func setupCheckImageView() {
        checkImageView = UIImageView()
        
        checkImageView.image = noneCheckImage
        checkImageView.clipsToBounds = true
        checkImageView.layer.cornerRadius = 14
        checkImageView.layer.borderWidth = 2
                        
        contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints({ make in
            make.width.height.equalTo(size)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(contentView.safeAreaLayoutGuide).offset(-10)
        })
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    func setupImage() {
        imageView.image = image
    }
    
}
