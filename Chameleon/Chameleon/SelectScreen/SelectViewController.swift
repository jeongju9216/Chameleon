//
//  ChooseFaceViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

class SelectViewController: BaseViewController {
    
    //MARK: - Views
    private var faceCollectionView: UICollectionView!
    private var emptyGuideLabel: UILabel!
    
    private var convertButton: UIButton!
    
    //MARK: - Properties
    var faceImages: [UIImage?] = []
    var selectedIndex: [Bool] = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChooseFaceUI()
        
        print("faceImages count: \(faceImages.count)")
        
        if let faceCollectionView = faceCollectionView {
            faceCollectionView.register(SelectCell.classForCoder(), forCellWithReuseIdentifier: "faceCellIdentifier")
            faceCollectionView.delegate = self
            faceCollectionView.dataSource = self
            
            selectedIndex = Array(repeating: true, count: faceImages.count)
            print("selectedIndex count: \(selectedIndex.count)")
            for (i, _) in selectedIndex.enumerated() {
                faceCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .init())
            }
            
            convertButton.addTarget(self, action: #selector(clickedCovertButton(sender:)), for: .touchUpInside)
        } else {
            convertButton.isHidden = true
        }
    }
        
    //MARK: - Actions
    @objc private func clickedCovertButton(sender: UIButton) {
        var indexArray: [String] = []
        for (i, isSelected) in selectedIndex.enumerated() {
            if isSelected {
                indexArray.append(String(format: "%03d", i))
            }
        }
        
        print("indexArray: \(indexArray) / count: \(indexArray.count)")
        let jsonData = ["faces": indexArray, "mode": UploadData.shared.convertType] as [String : Any]
        print("sendFaces jsonData: \(jsonData)")
        
        LoadingIndicator.showLoading()
        HttpService.shared.sendCheckedFaces(params: jsonData) { [weak self] (result, response) in
            LoadingIndicator.hideLoading()
            if result {
                DispatchQueue.main.async {
                    let convertVC = ConvertViewController()
                    convertVC.modalPresentationStyle = .fullScreen
                    self?.navigationController?.pushViewController(convertVC, animated: true)
                }
            } else {
                self?.showErrorAlert()
            }
        }
    }
    
    //MARK: - Setup
    private func setupChooseFaceUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar(title: "바꿀 얼굴 선택")
        
        if faceImages.isEmpty {
            setupEmptyGuideLabel()
        } else {
            setupFaceCollectionView()
        }
        
        setupConvertButton()
    }
    
    private func setupEmptyGuideLabel() {
        emptyGuideLabel = UILabel()
        emptyGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyGuideLabel.text = "얼굴을 찾을 수 없습니다."
        emptyGuideLabel.numberOfLines = 0
        
        view.addSubview(emptyGuideLabel)
        emptyGuideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyGuideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
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
        
        let width = min(view.frame.width - 80, 800)
        view.addSubview(convertButton)
        convertButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        convertButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        convertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}

extension SelectViewController: UICollectionViewDelegateFlowLayout {
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

extension SelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faceImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = faceCollectionView.dequeueReusableCell(withReuseIdentifier: "faceCellIdentifier", for: indexPath) as! SelectCell
        
        cell.setupImage(faceImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex[indexPath.row].toggle()
        print("select: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndex[indexPath.row].toggle()
        print("select: \(indexPath.row)")
    }
}
