//
//  ChooseFaceCell.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

class SelectCell: UICollectionViewCell {
    
    //MARK: - Views
    private var imageView: UIImageView! //얼굴 imageView
    private var image: UIImage? //얼굴 이미지
    private var checkImageView: UIImageView! //체크표시 imageView
    private var checkImage: UIImage? //선택 이미지
    private var noneCheckImage: UIImage? //해제 이미지
    
    //MARK: - Properties
    private let size = 28
    override var isSelected: Bool { //선택되었는가
        didSet { //isSelected가 바뀌면 setSelected() 실행
            setSelected(isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    //MARK: - Methods
    func setupImage(_ image: UIImage?) {
        imageView.image = image
    }

    //selected에 따라 cell style 적용
    private func setSelected(_ selected: Bool) {
        if selected {
            setSelectedStyle()
        } else {
            setDeselectedStyle()
        }
    }
    
    //선택되었을 때 cell style
    private func setSelectedStyle() {
        checkImageView.image = checkImage
        
        checkImageView.tintColor = .mainColor
        checkImageView.alpha = 1
        checkImageView.layer.borderColor = UIColor.mainColor.cgColor
        checkImageView.backgroundColor = .white
        
        contentView.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    //선택 해제되었을 때 cell style
    private func setDeselectedStyle() {
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
        //사이즈에 맞추기 위해 imageConfig 설정
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(size))
        noneCheckImage = UIImage(systemName: "circle.fill", withConfiguration: imageConfig)
        checkImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
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
}
