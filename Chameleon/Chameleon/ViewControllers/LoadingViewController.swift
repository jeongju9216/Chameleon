//
//  LoadingViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/30.
//

import UIKit
import SnapKit
import Lottie

class LoadingViewController: BaseViewController {

    //MARK: - Views
    let guideLabel: UILabel = UILabel()
    
    let chameleonImageView: UIImageView = UIImageView()
    lazy var topAnimationView: AnimationView = {
        UITraitCollection.current.userInterfaceStyle == .light ? .init(name: "bottomImage-Light")
                                                               : .init(name: "bottomImage-Dark")
    }()
    lazy var bottomAnimationView: AnimationView = {
        UITraitCollection.current.userInterfaceStyle == .light ? .init(name: "bottomImage-Light")
                                                               : .init(name: "bottomImage-Dark")
    }()
    
    //MARK: - Properties
    var guideString: String = ""
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoadingUI()
        
        //test code
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Methods
    private func setUpLoadingUI() {
        view.backgroundColor = UIColor().backgroundColor()
        
        setUpTopAnimationView()
        setUpBottomAnimationView()
        setUpChameleonImage()
        setUpGuideLabel()
    }
    
    private func setUpGuideLabel() {
        guideLabel.text = guideString
        guideLabel.font = UIFont.boldSystemFont(ofSize: 32)
        guideLabel.numberOfLines = 0
        
        var count = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.guideLabel.text = self.guideString + String(repeating: ".", count: count % 3)
            count += 1
        }
        timer.fire()
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(chameleonImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpChameleonImage() {
        if let chameleonImage = UIImage(named: "ChameleonImage") {
            chameleonImageView.image = chameleonImage
            chameleonImageView.contentMode = .scaleAspectFill
            chameleonImageView.layer.allowsEdgeAntialiasing = true
            
            view.addSubview(chameleonImageView)
            chameleonImageView.snp.makeConstraints { make in
                make.width.height.equalTo(70)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-40)
            }
        }
        
    }
    
    private func setUpTopAnimationView() {
        topAnimationView.transform = .init(rotationAngle: .pi)
        
        topAnimationView.contentMode = .scaleAspectFill
        topAnimationView.loopMode = .loop
        topAnimationView.animationSpeed = 0.5
        topAnimationView.backgroundBehavior = .pauseAndRestore
        topAnimationView.play()
        
        view.addSubview(topAnimationView)
        topAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(130)
            make.top.equalTo(view.snp.top).offset(-20)
        }
    }
    
    private func setUpBottomAnimationView() {
        bottomAnimationView.contentMode = .scaleAspectFill
        bottomAnimationView.loopMode = .loop
        bottomAnimationView.animationSpeed = 1.2
        bottomAnimationView.backgroundBehavior = .pauseAndRestore
        bottomAnimationView.play()
        
        view.addSubview(bottomAnimationView)
        bottomAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(130)
            make.bottom.equalTo(view.snp.bottom).offset(20)
        }
    }
}
