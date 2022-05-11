//
//  ChooseFaceViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

class ChooseFaceViewController: BaseViewController {
    
    //MARK: - Views
    private var faceCollectionView: UICollectionView!
    
    private var convertButton: UIButton!
    
    //MARK: - Properties
    var faceImages: [FaceImage] = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<10 {
            faceImages.append(FaceImage(url: "", name: "", gender: "", percent: 90))
        }
        
        setupChooseFaceUI()
        
        faceCollectionView.register(ChooseFaceCell.classForCoder(), forCellWithReuseIdentifier: "faceCellIdentifier")
        faceCollectionView.delegate = self
        faceCollectionView.dataSource = self
        
        convertButton.addTarget(self, action: #selector(clickedCovertButton(sender:)), for: .touchUpInside)
    }
        
    //MARK: - Actions
    @objc private func clickedCovertButton(sender: UIButton) {
        let convertVC = ConvertViewController()
        convertVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(convertVC, animated: true)
    }
    
    //MARK: - Setup
    private func setupChooseFaceUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar(title: "바꾸지 않을 얼굴 선택")
        
        setupFaceCollectionView()
        setupConvertButton()
    }
    
    private func setupFaceCollectionView() {
        faceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        faceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        faceCollectionView.backgroundColor = .backgroundColor
        faceCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 80, right: 10)
        faceCollectionView.showsVerticalScrollIndicator = false
        faceCollectionView.allowsMultipleSelection = true
        
        view.addSubview(faceCollectionView)
        faceCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        faceCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    private func setupConvertButton() {
        convertButton = UIButton()
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        
        convertButton.applyMainButtonStyle(title: "변환하기")
        
        view.addSubview(convertButton)
        convertButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        convertButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        convertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}

extension ChooseFaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interval: CGFloat = 10
        let count = floor(UIScreen.main.bounds.width / 120)
        let size = floor((UIScreen.main.bounds.width - interval * 4) / count)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ChooseFaceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faceImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = faceCollectionView.dequeueReusableCell(withReuseIdentifier: "faceCellIdentifier", for: indexPath) as! ChooseFaceCell
        
        cell.setupImage(url: faceImages[indexPath.item].url)
        
        return cell
    }
}
