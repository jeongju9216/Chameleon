//
//  ChooseFaceCell.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit
import SnapKit

class ChooseFaceCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    var image: UIImage?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupCell()
    }
    
    private func setupCell() {
        setupImageView()
    }
    
    private func setupImageView() {
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
