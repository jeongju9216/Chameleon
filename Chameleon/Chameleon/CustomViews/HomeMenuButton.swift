//
//  HomeMenuButton.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit

class HomeMenuButton: UIButton {
    
    var image: UIImage?
    var name: String = ""
    
    let menuImage = UIImageView()
    let menuLabel = UILabel()
    
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
        self.backgroundColor = UIColor().buttonColor()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor().buttonBorderColor().cgColor
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor().edgeColor().cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        
        let innerView = innerStackView()
        self.addSubview(innerView)
        innerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
        
        innerView.isUserInteractionEnabled = false
    }
    
    private func innerStackView() -> UIStackView {
        let innerStackView = UIStackView(arrangedSubviews: [menuImage, menuLabel])

        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.axis = .vertical
        innerStackView.spacing = 15
        innerStackView.distribution = .fill
        innerStackView.alignment = .center
        
        //image
        menuImage.image = image?.withRenderingMode(.alwaysTemplate)
        menuImage.tintColor = .white
        menuImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        //label
        menuLabel.text = self.name
        menuLabel.textColor = .white
        menuLabel.font = UIFont.boldSystemFont(ofSize: 16)
        menuLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        return innerStackView
    }
    
    func touchDown() {
        self.backgroundColor = UIColor().buttonClickColor()
        menuImage.tintColor = .lightGray
        menuLabel.textColor = .lightGray
    }
    
    func touchUp() {
        self.backgroundColor = UIColor().buttonColor()
        menuImage.tintColor = .white
        menuLabel.textColor = .white
    }
}
