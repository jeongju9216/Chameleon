//
//  ChooseFaceViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit
import SnapKit

class ChooseFaceViewController: BaseViewController {
    
    //MARK: - Views
    var faceCollectionView: UICollectionView!
    
    let convertButton: UIButton = UIButton()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChooseFaceUI()
        
        registerCollectionView()
        collectionViewDelegate()
    }
        
    //MARK: - Methods
    private func setupChooseFaceUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar(title: "바꾸지 않을 얼굴 선택")
        
        setupFaceCollectionView()
        setupUploadButton()
    }
    
    private func setupFaceCollectionView() {
        faceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        faceCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)
        
        view.addSubview(faceCollectionView)
        faceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(10)
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func registerCollectionView() {
        faceCollectionView.register(ChooseFaceCell.classForCoder(), forCellWithReuseIdentifier: "faceCellIdentifier")
    }
    
    private func collectionViewDelegate() {
        faceCollectionView.delegate = self
        faceCollectionView.dataSource = self
    }
    
    private func setupUploadButton() {
        convertButton.applyMainButtonStyle(title: "변환하기")
        
        view.addSubview(convertButton)
        convertButton.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}

extension ChooseFaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (faceCollectionView.frame.size.width / 3.05).rounded(.down) - 5
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = faceCollectionView.dequeueReusableCell(withReuseIdentifier: "faceCellIdentifier", for: indexPath) as! ChooseFaceCell
        //todo: input cell data
        
        return cell
    }
}
