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
    var resultImage: UIImage? //결과 이미지
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "\(UploadData.shared.uploadTypeString) 변환 결과")
        navigationItem.hidesBackButton = true //뒤로가기 차단

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
        guard let resultImage = resultImage else { return }
        
        //앨범에 저장하기
        UIImageWriteToSavedPhotosAlbum(resultImage, self,
                                       #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
       if let error = error { //에러 방생시 error Alert
           print("saveImage error: \(error)")
           showErrorAlert()
       } else { //저장 완료 시 Alert
           showOneButtonAlert(message: "앨범에 저장 되었습니다.")
       }
    }

    @objc private func clickedShareButton(sender: UIButton) {
        print("\(#fileID) \(#line)-line, \(#function)")
        guard let resultImage = resultImage else { return }
        
        let shareVC = UIActivityViewController(activityItems: [resultImage], applicationActivities: nil)
        //ipad 대응
        shareVC.popoverPresentationController?.sourceView = sender
        shareVC.popoverPresentationController?.sourceRect = sender.frame
        
        present(shareVC, animated: true)
    }
    
    //종료하기 버튼
    @objc private func clickedDoneButton(sender: UIButton) {
        let message = "변환된 \(UploadData.shared.uploadTypeString)은 종료 후 즉시 삭제됩니다.\n종료하시겠습니까?"
        
        //종료하기 Alert
        showTwoButtonAlert(message: message, defaultButtonTitle: "종료하기", defaultAction: { [weak self] _ in
            //확인 누를 시 홈으로 이동
            self?.goBackHome()
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
