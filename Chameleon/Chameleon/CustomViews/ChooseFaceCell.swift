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
        imageView.image = UIImage(named: "SampleFaceImage")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
}
