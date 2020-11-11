//
//  HalfCircularProgressView.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/11.
//

import UIKit

//내가 원하는 타입의 ProgressBar를 구현하기 위해 Custom class 작성.
//참고: medium.com/@imsree/custom-circular-progress-bar-in-ios-using-swift-4-b1a9f7c55da
class HalfCircularProgressView: UIView {    //UIView를 상속
    
    private var circleLayer: CAShapeLayer = CAShapeLayer()  //반원 레이어
    private var progressLayer: CAShapeLayer = CAShapeLayer()    //진행도 레이어
        
    //MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
    }
    
    //m.blog.naver.com/PostView.nhn?blogId=jdub7138&logNo=220379745883&proxyReferer=https:%2F%2Fwww.google.com%2F
    required init?(coder: NSCoder) {    //subclass에서 따라야 하는 required initializer. 위에서 별도로 designated init을 작성했으므로 이것도.
        super.init(coder: coder)        //fail-able initializer이다.
        
        createCircularPath()
    }
    
    //MARK: - Methods
    func createCircularPath() {
        
        let radius: CGFloat = CGFloat(frame.width > frame.height ? frame.height * 2 / 3 : frame.width * 2 / 3)
        
        //베지어 패스를 이용하여 모양을 잡은 뒤 ShapeLayer의 형태로 설정해주기
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: radius, startAngle: -.pi, endAngle: 0, clockwise: true)
        //베지어 곡선을 프레임의 가운데를 기준으로 radius 반지름을 가지고 그린다.
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 23.0
        circleLayer.strokeColor = UIColor.black.cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
//        progressLayer.strokeColor = UIColor.blue.cgColor
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    
    //측정 된 값에 따라 progressBar가 애니메이션과 함께 fill
    func setValueAndProgressAnimation(estimated value: Double) {
        
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")  //어느 선을 따라
        
        circularProgressAnimation.fromValue = 0
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        circularProgressAnimation.speed = 0.2
        
        //ProgressBar가 올라갈 때  그라데이션 형태로 바뀌길 원했으나 잘 작동되지 않아 일단 보류
//        let circularProgressColorAnimation = CABasicAnimation(keyPath: "strokeColor")
//        circularProgressColorAnimation.fromValue = UIColor.blue.cgColor
//        circularProgressColorAnimation.toValue = UIColor.white.cgColor
//        progressLayer.add(circularProgressColorAnimation, forKey: "progressColorAnim")

        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        
    }
    
    
}
