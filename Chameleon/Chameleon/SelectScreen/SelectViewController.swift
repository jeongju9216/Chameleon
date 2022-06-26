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
    var faceImages: [UIImage?] = [] //얼굴 이미지 list
    var selectedIndex: [Bool] = [] //선택한 얼굴 이미지 index list
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "바꿀 얼굴 선택")

        print("faceImages count: \(faceImages.count)")
        
        if faceImages.isEmpty {
            selectView.convertButton.isHidden = true
        } else {
            setupFaceCollectionView()
            
            selectView.convertButton.addTarget(self, action: #selector(clickedCovertButton(sender:)), for: .touchUpInside)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        selectView = SelectView(frame: self.view.frame, isFacesEmpty: faceImages.isEmpty)
        self.view = selectView
    }
        
    //MARK: - Actions
    //변환하기 버튼을 눌렀을 때 실행
    @objc private func clickedCovertButton(sender: UIButton) {
        var indexArray: [String] = [] //선택한 face index
        //filter + map을 쓰면 2배 속도가 걸리므로 for 한 번으로 처리
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
            if result { //result가 true라면 변환 화면으로 이동
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
    private func setupFaceCollectionView() {
        selectView.faceCollectionView.register(SelectCell.classForCoder(), forCellWithReuseIdentifier: "faceCellIdentifier")
        selectView.faceCollectionView.delegate = self
        selectView.faceCollectionView.dataSource = self
        
        selectedIndex = Array(repeating: true, count: faceImages.count)
        //모두 선택한 것 처리
        for (i, _) in selectedIndex.enumerated() {
            selectView.faceCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .init())
        }
    }
}

extension SelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interval: CGFloat = 10
        let count = floor(UIScreen.main.bounds.width / 120)
        let size = floor((UIScreen.main.bounds.width - interval * 4) / count) //상하좌우 interval씩 => interval * 4
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
    
    //선택한 경우 selectedIndex에 true
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex[indexPath.row].toggle()
        print("select: \(indexPath.row)")
    }
    
    //선택 해제한 경우 selectedIndex에 true
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndex[indexPath.row].toggle()
        print("select: \(indexPath.row)")
    }
}
