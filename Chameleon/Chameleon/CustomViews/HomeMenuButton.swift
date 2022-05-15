//
//  HomeMenuButton.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit

class HomeMenuButton: UIButton {
    
    //MARK: - Views
    var menuStackView: UIStackView!
    var menuImage: UIImageView!
    var menuLabel: UILabel!
    
    //MARK: - Properties
    var image: UIImage?
    var name: String = ""
    
    convenience init(imageName: String, name: String) {
        self.init()
        
        self.image = UIImage(named: imageName)
        self.name = name
        
        setupUI()
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
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
        
        menuStackView.isUserInteractionEnabled = false
        
        menuStackView.axis = .vertical
        menuStackView.spacing = 10
        menuStackView.distribution = .fill
        menuStackView.alignment = .center
        
        self.addSubview(menuStackView)
        menuStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
    }
    
    private func setupMenuImageView() {
        menuImage = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
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
}
