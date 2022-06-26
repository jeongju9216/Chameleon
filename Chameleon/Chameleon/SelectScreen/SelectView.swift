//
//  SelectView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/06/21.
//

import UIKit

final class SelectView: UIView {
    
    //MARK: - View
    var faceCollectionView: UICollectionView! //얼굴 리스트 collectionView
    var emptyGuideLabel: UILabel! //faceImages가 비어있을 때 안내 문구 label
    var convertButton: UIButton! //변환하기 버튼
    var isFacesEmpty: Bool = true //faceImages가 비어있는가
    
    //MARK: - Init
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
            setupEmptyGuideLabel() //faceImages가 empty라면 안내 문구 보여줌
        } else {
            setupFaceCollectionView() //faceImages가 non-empty라면 collectionView 생성
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
        faceCollectionView.showsVerticalScrollIndicator = false //indicator 숨기기
        faceCollectionView.allowsMultipleSelection = true //다중 선택 설정
        
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
