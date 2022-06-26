//
//  HomeMenuButton.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit

class HomeMenuButton: UIButton {
    
    //MARK: - Views
    private var menuStackView: UIStackView! //버튼 내부 StackView
    private var menuImage: UIImageView! //버튼 아이콘 이미지, StackView 아이템1
    private var menuLabel: UILabel! //버튼 이름 label, StackView 아이템2
    
    //MARK: - Properties
    private var image: UIImage? //버튼 아이콘 이미지
    var name: String = "" //버튼 이름
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience init(imageName: String, name: String) {
        self.init()
        
        self.image = UIImage(named: imageName)
        self.name = name
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
//    아이콘의 색상도 변경되어야 하기 때문에 touchDown, touchUp을 직접 구현
    func touchDown() {
        self.backgroundColor = UIColor.buttonClickColor
        menuImage.tintColor = .lightGray
        menuLabel.textColor = .lightGray
    }
    
    func touchUp() {
        self.backgroundColor = UIColor.buttonColor
        menuImage.tintColor = .white
        menuLabel.textColor = .white
    }
    
    //MARK: - Setup
    private func setupUI() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor.buttonColor
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.buttonBorderColor.cgColor
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.edgeColor.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        
        setupStackView()
        setupMenuImageView()
        setupMenuLabel()
    }
    
    private func setupStackView() {
        menuStackView = UIStackView()
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        
        menuStackView.isUserInteractionEnabled = false //이벤트 무시
        
        menuStackView.axis = .vertical //vertical stack
        menuStackView.spacing = 10 //아이템 간격 10
        menuStackView.distribution = .fill //공간 꽉 채우기
        menuStackView.alignment = .center //아이템 가운데 정렬
        
        self.addSubview(menuStackView)
        menuStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
    }
    
    private func setupMenuImageView() {
        menuImage = UIImageView(image: image?.withRenderingMode(.alwaysTemplate)) //아이콘 색상 변경을 위해 alwaysTemplate로 Rendering
        menuImage.translatesAutoresizingMaskIntoConstraints = false
        
        menuImage.tintColor = .white
        
        menuStackView.addArrangedSubview(menuImage)
        menuImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        menuImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        menuImage.centerXAnchor.constraint(equalTo: menuStackView.centerXAnchor).isActive = true
    }
    
    private func setupMenuLabel() {
        menuLabel = UILabel()
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        menuLabel.text = self.name
        menuLabel.textColor = .white
        menuLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        menuStackView.addArrangedSubview(menuLabel)
        menuLabel.centerXAnchor.constraint(equalTo: menuStackView.centerXAnchor).isActive = true
    }
}
