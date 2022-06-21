//
//  CovertViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

class ConvertViewController: BaseViewController {

    //MARK: - Views
    private var convertView: ConvertView!
    
    //MARK: - Properties
    var resultURL: String?
    var resultImage: UIImage?
    var isDone: Bool { time >= 100 }
    var time: Int = 0, firstStandTime: Int = 0
    var inTimer: Int = 0
    var timer: Timer?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "얼굴 변환 중")
        
        convertView.doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
        
        firstStandTime = Int.random(in: 10...20)
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(progressConvert(sender:)), userInfo: nil, repeats: true)
    }
    
    override func loadView() {
        super.loadView()
        
        convertView = ConvertView(frame: self.view.frame)
        self.view = convertView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    //MARK: - Actions
    @objc private func clickedDoneButton(sender: UIButton) {
        if let resultURL = resultURL {
            LoadingIndicator.showLoading()
            
            DispatchQueue.global().async {
                guard let url = URL(string: resultURL),
                      let data = try? Data(contentsOf: url),
                      let resultImage = UIImage(data: data) else {
                    LoadingIndicator.hideLoading()
                    self.showErrorAlert()
                    return
                }
                
                HttpService.shared.deleteFiles(completionHandler: { _, _ in })

                DispatchQueue.main.async {
                    LoadingIndicator.hideLoading()
                    
                    let resultVC = ResultViewController()
                    resultVC.modalPresentationStyle = .fullScreen
                    resultVC.resultImageURL = resultURL
                    resultVC.resultImage = resultImage
                    
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        } else {
            self.showTwoButtonAlert(message: "얼굴 변환을 중단하시겠습니까?", defaultButtonTitle: "중단하기", cancelButtonTitle: "이어하기", defaultAction: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    //MARK: - Methods
    private func downloadResult() {
        HttpService.shared.getResultFile() { [weak self] (result, response) in
            guard let self = self else { return }
            guard result, let response = response as? Response,
                  let resultURL = response.data else {
                return
            }
            
            self.resultURL = resultURL
        }
    }
    
    @objc private func progressConvert(sender: UIProgressView) {
        inTimer += 1
        if let _ = resultURL {
            time += Int.random(in: 10...20)
            
            if time > 100 {
                timer?.invalidate()
                completeConvert()
            }
        } else {
            if time < firstStandTime {
                time += Int.random(in: 3...5)
            } else {
                if inTimer % 10 == 0 { //5초
                    time += Int.random(in: 1...3)
                    time = min(time, 99)
                }
                
                if inTimer % 50 == 0 {
                    inTimer = 0
                    downloadResult()
                }
            }
        }
        
        convertView.setProgressTime(time: time)
    }
    
    private func errorEvent() {
        self.showErrorAlert()
    }
    
    private func completeConvert() {
        convertView.setCompleteText()
        setupNavigationBar(title: "얼굴 변환 완료")
    }
}
