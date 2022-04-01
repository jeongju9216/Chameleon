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
        
        setupLoadingUI()
        
        //test code
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.dismissLoading()
        }
    }
    
    //MARK: - Methods
    private func dismissLoading() {
        if let tvc = self.presentingViewController as? UITabBarController,
           let nvc = tvc.selectedViewController as? UINavigationController,
           let pvc = nvc.topViewController as? UploadViewController {
            self.dismiss(animated: true) {
                let chooseFaceVC = ChooseFaceViewController()
                chooseFaceVC.modalPresentationStyle = .fullScreen
                chooseFaceVC.modalTransitionStyle = .crossDissolve

                pvc.navigationController?.pushViewController(chooseFaceVC, animated: true)
            }
        }
    }
    
    //MARK: - Setup
    private func setupLoadingUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupTopAnimationView()
        setupBottomAnimationView()
        setupChameleonImage()
        setupGuideLabel()
    }
    
    private func setupGuideLabel() {
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
    
    private func setupChameleonImage() {
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
    
    private func setupTopAnimationView() {
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
    
    private func setupBottomAnimationView() {
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
