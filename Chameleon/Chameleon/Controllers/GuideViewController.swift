//
//  GuideViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/12.
//

import UIKit

class GuideViewController: BaseViewController {

    //MARK: - Views
    private var closeButton: UIButton!
    private var logoImageView: UIImageView!
    private var titleLabel: UILabel!
    private var guideLabel: UILabel!
    
    //MARK: - Properties
    private let guideText: String = "원하는 사진을 선택하세요.\n|\n" +
                                    "업로드 버튼을 누르세요.\n|\n" +
                                    "변환하지 않을 얼굴을 선택하세요.\n|\n" +
                                    "변환이 완료되면 \"결과 보기\" 버튼이 나옵니다.\n버튼을 눌러 결과를 확인하세요.\n|\n" +
                                    "사진을 저장하고\n다른 사람에게 공유하세요."
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGuideUI()
        
        closeButton.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Methods
    private func setupGuideUI() {
        view.backgroundColor = .backgroundColor
        
        setupCloseButton()
        setupLogoImageView()
        setupTitleLabel()
        setupGuideLabel()
    }
    
    private func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.label, for: .normal)
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.image = UIImage(named: "LogoImage")
        logoImageView.contentMode = .scaleAspectFit
        
        view.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "사진 속 얼굴을 세상에 존재하지 않는\n페이크 얼굴로 바꿔 보세요"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.numberOfLines = 0
        guideLabel.lineBreakMode = .byCharWrapping
        
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = 18
        let lineheight = fontSize * 1.5  //font size * multiple
        style.minimumLineHeight = lineheight
        style.maximumLineHeight = lineheight
        style.alignment = .center

        guideLabel.attributedText = NSAttributedString(
          string: guideText,
          attributes: [
            .paragraphStyle: style
          ])
        guideLabel.font = .systemFont(ofSize: fontSize)
        
        view.addSubview(guideLabel)
        guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        guideLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
}
