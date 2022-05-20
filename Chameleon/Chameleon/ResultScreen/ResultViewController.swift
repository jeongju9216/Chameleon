//
//  ConversionResultViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

class ResultViewController: BaseViewController {
    
    //MARK: - Views
    private var resultImageView: UIImageView!
    private var resultImage: UIImage?
    
    private var buttonStack: UIStackView!
    private var saveButton: UIButton!
    private var shareButton: UIButton!
    
    private var doneButton: UIButton!
    
    //MARK: - Properties
    private let buttonSize: Int = 24
    var resultImageURL: String = ""
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConversionResultUI()
        loadResultImage()

        doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(clickedSaveButton(sender:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(clickedShareButton(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedSaveButton(sender: UIButton) {
        print("\(#fileID) \(#line)-line, \(#function)")
        
        if let resultImage = resultImage {
            UIImageWriteToSavedPhotosAlbum(resultImage, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
       if let error = error {
           print("saveImage error: \(error)")
           showErrorAlert()
       } else {
           showOneButtonAlert(message: "앨범에 저장 되었습니다.")
       }
    }

    @objc private func clickedShareButton(sender: UIButton) {
        print("\(#fileID) \(#line)-line, \(#function)")
        
        if let resultImage = resultImage {
            let vc = UIActivityViewController(activityItems: [resultImage], applicationActivities: nil)
            vc.excludedActivityTypes = [.saveToCameraRoll]
            present(vc, animated: true)
        }
    }
    
    @objc private func clickedDoneButton(sender: UIButton) {
        let message = "변환된 \(UploadData.shared.uploadTypeString)은 종료 후 즉시 삭제됩니다.\n종료하시겠습니까?"
        
        showTwoButtonAlert(message: message, defaultButtonTitle: "종료하기", defaultAction: { action in
            LoadingIndicator.showLoading()
            HttpService.shared.deleteFiles(completionHandler: { [weak self] result, response in
                LoadingIndicator.hideLoading()
                if result {
                    self?.goBackHome()
                } else {
                    self?.showErrorAlert()
                }
            })
        })
    }
    
    //MARK: - Methods
    private func goBackHome() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - Setup
    private func setupConversionResultUI() {
        setupNavigationBar(title: "\(UploadData.shared.uploadTypeString) 변환 결과")
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .backgroundColor
        
        setupResultView()
        
        setupButtonStackView()
        setupSaveButton()
        setupShareButton()
        
        setupDoneButton()
    }
    
    private func setupResultView() {
        resultImageView = UIImageView()
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        
        resultImageView.backgroundColor = UIColor.backgroundColor
        
        resultImageView.clipsToBounds = true
        resultImageView.layer.borderColor = UIColor.edgeColor.cgColor
        resultImageView.layer.borderWidth = 2
        resultImageView.layer.cornerRadius = 20
        
        view.addSubview(resultImageView)
        resultImageView.widthAnchor.constraint(equalToConstant: min(view.frame.width * 0.8, 600)).isActive = true
        resultImageView.heightAnchor.constraint(equalTo: resultImageView.widthAnchor).isActive = true
        resultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
    }
    
    private func loadResultImage() {
//      URL(string: "https://picsum.photos/800")
        if let url = URL(string: resultImageURL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data) ?? UIImage(named: "ChameleonImage")
                    DispatchQueue.main.async {
                        self?.resultImage = image
                        self?.resultImageView.image = self?.resultImage
                    }
                }
            }
        }
    }
    
    private func setupButtonStackView() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        
        view.addSubview(buttonStack)
        buttonStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupSaveButton() {
        saveButton = UIButton(type: .custom)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(buttonSize))
        saveButton.setImage(UIImage(systemName: "arrow.down.to.line", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        saveButton.tintColor = .mainColor
        saveButton.alignTextBelow()
        
        buttonStack.addArrangedSubview(saveButton)
    }
    
    private func setupShareButton() {
        shareButton = UIButton(type: .custom)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.label, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(buttonSize))
        shareButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.tintColor = .mainColor
        shareButton.alignTextBelow()
        
        buttonStack.addArrangedSubview(shareButton)
    }
    
    private func setupDoneButton() {
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "종료하기")
        
        view.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
