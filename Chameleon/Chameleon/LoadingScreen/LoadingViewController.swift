//
//  LoadingViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/30.
//

import UIKit
import Lottie

class LoadingViewController: BaseViewController {
    
    //MARK: - Views
    var guideLabel: UILabel!
    
    var chameleonImageView: UIImageView!
    var topAnimationView: AnimationView!
    var bottomAnimationView: AnimationView!
    
    //MARK: - Properties
    var guideString: String = ""
    var animationName = UITraitCollection.current.userInterfaceStyle == .light ? "bottomImage-Light" : "bottomImage-Dark"
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingUI()
    }
    
    private func animationLoadingTimer() {
        var count = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            
            self.guideLabel.text = self.guideString + String(repeating: ".", count: count % 3)
            count += 1
        }
        timer.fire()
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
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.text = guideString
        guideLabel.font = UIFont.boldSystemFont(ofSize: 18)
        guideLabel.numberOfLines = 0
        
        animationLoadingTimer()
        
        view.addSubview(guideLabel)
        guideLabel.topAnchor.constraint(equalTo: chameleonImageView.bottomAnchor, constant: 10).isActive = true
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupChameleonImage() {
        chameleonImageView = UIImageView()
        chameleonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let chameleonImage = UIImage(named: "ChameleonImage") {
            chameleonImageView.image = chameleonImage
            chameleonImageView.contentMode = .scaleAspectFill
            chameleonImageView.layer.allowsEdgeAntialiasing = true
            
            view.addSubview(chameleonImageView)
            chameleonImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            chameleonImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            chameleonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chameleonImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        }
        
    }
    
    private func setupTopAnimationView() {
        topAnimationView = .init(name: animationName)
        topAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        topAnimationView.transform = .init(rotationAngle: .pi)
        
        topAnimationView.contentMode = .scaleToFill
        topAnimationView.loopMode = .loop
        topAnimationView.animationSpeed = 0.5
        topAnimationView.backgroundBehavior = .pauseAndRestore
        topAnimationView.play()
        
        view.addSubview(topAnimationView)
        topAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topAnimationView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        topAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topAnimationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
    }
    
    private func setupBottomAnimationView() {
        bottomAnimationView = .init(name: animationName)
        bottomAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomAnimationView.contentMode = .scaleToFill
        bottomAnimationView.loopMode = .loop
        bottomAnimationView.animationSpeed = 1.2
        bottomAnimationView.backgroundBehavior = .pauseAndRestore
        bottomAnimationView.play()
        
        view.addSubview(bottomAnimationView)
        bottomAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomAnimationView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        bottomAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
    }
}
