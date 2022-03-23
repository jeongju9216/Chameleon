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
        
        setUpUI()
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setUpUI() {
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "ButtonBorderColor")?.cgColor
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
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
        menuImage.tintColor = .black
        menuImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        //label
        menuLabel.text = self.name
        menuLabel.font = UIFont.boldSystemFont(ofSize: 16)
        menuLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        return innerStackView
    }
    
    func touchDown() {
        self.backgroundColor = UIColor(named: "MainColor")
        menuImage.tintColor = .white
        menuLabel.textColor = .white
    }
    
    func touchUp() {
        self.backgroundColor = .white
        menuImage.tintColor = .black
        menuLabel.textColor = .black
    }
}
