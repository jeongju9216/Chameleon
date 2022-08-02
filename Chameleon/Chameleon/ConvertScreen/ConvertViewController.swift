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
    private var resultURL: String? //결과 이미지 url
    private var isDone: Bool { time >= 100 } //완료 했는가?
    private var time: Int = 0, firstStandTime: Int = 0 //time: 진행률, firstStandTime: 처음에 빠르게 올라가는 기준 진행률
    private var inTimer: Int = 0 //진행률 증가 변수
    private var timer: Timer? //진행률 타이머
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "얼굴 변환 중")
        
        convertView.doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
        
        firstStandTime = Int.random(in: 10...20) //처음에 빠르게 올라가는 기준 진행률을 10~20%로 설정
        
        //타이머 설정. 타이머 진행률을 progress바에 보여줌
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(progressConvert(sender:)),
                                     userInfo: nil, repeats: true)
    }
    
    override func loadView() {
        super.loadView()
        
        convertView = ConvertView(frame: self.view.frame)
        self.view = convertView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Disappear 되면 timer 정지
        timer?.invalidate()
    }
    
    //MARK: - Actions
    //완료 버튼을 눌렀을 때
    @objc private func clickedDoneButton(sender: UIButton) {
        if let resultURL = resultURL { //결과 url을 서버에서 받아왔을 때
            LoadingIndicator.showLoading() //result image load동안 loading
            
            Task { //결과 image load는 비동기로 실행
                guard let url = URL(string: resultURL),
                      let data = try? Data(contentsOf: url),
                      let resultImage = UIImage(data: data) else {
                    //결과 image load 실패한 경우
                    LoadingIndicator.hideLoading()
                    self.showErrorAlert()
                    return
                }
                
                //결과 VC로 이동
                DispatchQueue.main.async {
                    LoadingIndicator.hideLoading()
                    
                    let resultVC = ResultViewController()
                    resultVC.modalPresentationStyle = .fullScreen
                    resultVC.resultImage = resultImage //결과 image 설정
                    
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        } else { //결과 url을 받아오는 중일 때
            self.showTwoButtonAlert(message: "얼굴 변환을 중단하시겠습니까?",
                                    defaultButtonTitle: "중단하기", cancelButtonTitle: "이어하기",
                                    defaultAction: { _ in
                //중단하기를 누른 경우 이전 화면으로 이동
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    //MARK: - Methods
    //resultURL가 생성되었는지 확인 -> 서버에서 받아오면 변환 완료
    //5초 당 1회 실행
    private func downloadResult() {
        Task {
            let (result, response) = await HttpService.shared.getResultFile()
            guard result,
                  let response = response as? Response,
                  let resultURL = response.data else {
                return
            }
            
            self.resultURL = resultURL
        }
    }
    
    //progress 진행률 업데이트
    @objc private func progressConvert(sender: UIProgressView) {
        inTimer += 1
        if let _ = resultURL { //downloadResult()에서 resultURL을 받아온 경우
            //타이머 100%로 올리기
            time += Int.random(in: 10...20)
            
            if time > 100 {
                timer?.invalidate()
                completeConvert() //변환 완료
            }
        } else {
            //10~20%까지는 빠르게 진행률을 올림
            if time < firstStandTime {
                time += Int.random(in: 3...5)
            } else {
                if inTimer % 10 == 0 { //1초에 1~3% 증가
                    time += Int.random(in: 1...3)
                    //아직 완료가 되지 않았는데 99%까지 찼다면 99%로 설정
                    time = min(time, 99)
                }
                
                if inTimer % 50 == 0 { //5초에 한 번씩 result 체크
                    inTimer = 0
                    downloadResult()
                }
            }
        }
        
        //progressView에 진행률 설정
        convertView.setProgressTime(time: time)
    }
    
    //변환 완료 시 UI 설정
    private func completeConvert() {
        convertView.setCompleteText()
        setupNavigationBar(title: "얼굴 변환 완료")
    }
}
