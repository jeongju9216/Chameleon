//
//  SelectView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/06/21.
//

import UIKit

final class SelectView: UIView {
    
    //MARK: -
    var faceCollectionView: UICollectionView!
    var emptyGuideLabel: UILabel!
    var convertButton: UIButton!
    var isFacesEmpty: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, isFacesEmpty: Bool) {
        self.init(frame: frame)
        self.isFacesEmpty = isFacesEmpty
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        self.backgroundColor = UIColor.backgroundColor
        
        if isFacesEmpty {
            setupEmptyGuideLabel()
        } else {
            setupFaceCollectionView()
        }
        
        setupConvertButton()
    }
    
    private func setupEmptyGuideLabel() {
        emptyGuideLabel = UILabel()
        emptyGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyGuideLabel.text = "얼굴을 찾을 수 없습니다."
        emptyGuideLabel.numberOfLines = 0
        
        self.addSubview(emptyGuideLabel)
        emptyGuideLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyGuideLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40).isActive = true
    }
    
    private func setupFaceCollectionView() {
        faceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        faceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        faceCollectionView.backgroundColor = .backgroundColor
        faceCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 80, right: 10)
        faceCollectionView.showsVerticalScrollIndicator = false
        faceCollectionView.allowsMultipleSelection = true
        
        self.addSubview(faceCollectionView)
        faceCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        faceCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func setupConvertButton() {
        convertButton = UIButton()
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        
        convertButton.applyMainButtonStyle(title: "변환하기")
        
        let width = min(self.frame.width - 80, 800)
        self.addSubview(convertButton)
        convertButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        convertButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        convertButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        convertButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
