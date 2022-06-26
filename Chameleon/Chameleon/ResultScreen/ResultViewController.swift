//
//  ConversionResultViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

class ResultViewController: BaseViewController {
    
    //MARK: - Views
    private var resultView: ResultView!
    
    //MARK: - Properties
    var resultImage: UIImage?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "\(UploadData.shared.uploadTypeString) 변환 결과")
        navigationItem.hidesBackButton = true

        loadResultImage()

        resultView.doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
        resultView.saveButton.addTarget(self, action: #selector(clickedSaveButton(sender:)), for: .touchUpInside)
        resultView.shareButton.addTarget(self, action: #selector(clickedShareButton(sender:)), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        
        resultView = ResultView(frame: self.view.frame)
        self.view = resultView
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
        guard let resultImage = resultImage else {
            print("resultImage is nil")
            return
        }
        
        let shareVC = UIActivityViewController(activityItems: [resultImage], applicationActivities: nil)
        //ipad
        shareVC.popoverPresentationController?.sourceView = sender
        shareVC.popoverPresentationController?.sourceRect = sender.frame
        
        present(shareVC, animated: true)
    }
    
    @objc private func clickedDoneButton(sender: UIButton) {
        let message = "변환된 \(UploadData.shared.uploadTypeString)은 종료 후 즉시 삭제됩니다.\n종료하시겠습니까?"
        
        showTwoButtonAlert(message: message, defaultButtonTitle: "종료하기", defaultAction: { action in
            HttpService.shared.deleteFiles(completionHandler: { [weak self] result, response in
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
    
    private func loadResultImage() {
        resultView.resultImageView.image = self.resultImage
    }
}
