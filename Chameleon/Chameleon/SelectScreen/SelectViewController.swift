//
//  ChooseFaceViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

class SelectViewController: BaseViewController {
    
    //MARK: - Views
    private var selectView: SelectView!
    
    //MARK: - Properties
    var faceImages: [UIImage?] = []
    var selectedIndex: [Bool] = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "바꿀 얼굴 선택")

        print("faceImages count: \(faceImages.count)")
        
        if let faceCollectionView = selectView.faceCollectionView {
            faceCollectionView.register(SelectCell.classForCoder(), forCellWithReuseIdentifier: "faceCellIdentifier")
            faceCollectionView.delegate = self
            faceCollectionView.dataSource = self
            
            selectedIndex = Array(repeating: true, count: faceImages.count)
            print("selectedIndex count: \(selectedIndex.count)")
            for (i, _) in selectedIndex.enumerated() {
                faceCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .init())
            }
            
            selectView.convertButton.addTarget(self, action: #selector(clickedCovertButton(sender:)), for: .touchUpInside)
        } else {
            selectView.convertButton.isHidden = true
        }
    }
    
    override func loadView() {
        super.loadView()
        
        selectView = SelectView(frame: self.view.frame, isFacesEmpty: faceImages.isEmpty)
        
        self.view = selectView
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
        let cell = selectView.faceCollectionView.dequeueReusableCell(withReuseIdentifier: "faceCellIdentifier", for: indexPath) as! SelectCell
        
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
