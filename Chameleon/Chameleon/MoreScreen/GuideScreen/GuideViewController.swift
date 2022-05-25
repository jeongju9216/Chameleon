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
    private let titleText: String = "카멜레온의 페이크 얼굴로\n타인의 초상권을 지켜주세요"
    private let guideText: String = "원하는 사진을 선택하세요.\n|\n" +
                                    "업로드 버튼을 누르세요.\n|\n" +
                                    "바꾸고 싶은 얼굴을 선택하세요.\n|\n" +
                                    "변환이 완료되면\n결과 보기 버튼을 눌러\n결과를 확인하세요.\n|\n" +
                                    "결과를 저장하고\n다른 사람에게 공유하세요."
    
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
        
        let fontSize: CGFloat = 20
        titleLabel.attributedText = createAttributedString(string: titleText, fontSize: fontSize, lineheight: 1.2)
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
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
        
        let fontSize: CGFloat = 18
        guideLabel.attributedText = createAttributedString(string: guideText, fontSize: fontSize, lineheight: 1.5)
        guideLabel.font = .systemFont(ofSize: fontSize)
        guideLabel.numberOfLines = 0
        guideLabel.lineBreakMode = .byCharWrapping
        
        view.addSubview(guideLabel)
        guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        guideLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func createAttributedString(string: String, fontSize: CGFloat, lineheight: Double) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()

        let lineheight = fontSize * lineheight
        style.minimumLineHeight = lineheight
        style.maximumLineHeight = lineheight
        style.alignment = .center

        let attributedString = NSMutableAttributedString(string: string, attributes: [.paragraphStyle: style])
        let accentText: [String] = ["카멜레온", "페이크 얼굴", "업로드", "결과 보기"]
        for text in accentText {
            let range = (string as NSString).range(of: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.mainColor, range: range)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range)
        }
        
        return attributedString
    }
}
