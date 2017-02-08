//
//  ViewController.swift
//  CAEmitterCellLearning
//
//  Created by Hesse Huang on 2017/2/8.
//  Copyright © 2017年 Hesse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func emit(_ sender: UIButton) {
        
        sender.isEnabled = false

        let cell = CAEmitterCell()
        cell.name = "laughing"          // 后面的KVC会用到
        cell.contents = "🍩".cgImage    // 图层内容
        cell.birthRate = 0.0            // 粒子的每秒的产出速率
        cell.lifetime = 10.0            // 显示时长
        cell.velocity = -80             // 速度，向下为负
        cell.velocityRange = -40        // 速度变化区间
        cell.yAcceleration = 45         // y轴上的加速度
        cell.emissionRange = .pi / 8    // 发射角度变化区间

        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 20)
        emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 0)
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.size.width / 2, y: -40)
        emitterLayer.emitterMode = kCAEmitterLayerOutline   // 发射样式，这里指围绕发射器的外轮廓发射
        emitterLayer.emitterShape = kCAEmitterLayerLine     // 发射器的形状，可以是线形、圆形、方形等
        emitterLayer.emitterCells = [cell]                  // 传入粒子对c象
        view.layer.addSublayer(emitterLayer)
        
        // 通过KVC设置birthRate间接控制动画的开始与结束
        callback(in: 0.2) {
            emitterLayer.setValue(5.0, forKeyPath: "emitterCells.laughing.birthRate")
        }
        callback(in: 6.0) { 
            emitterLayer.setValue(0.0, forKeyPath: "emitterCells.laughing.birthRate")
        }
        callback(in: 13.0) { 
            emitterLayer.removeFromSuperlayer()
            sender.isEnabled = true
        }
    }
    
    
}

func callback(in seconds: TimeInterval, operation: @escaping () -> Void) {
    Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in operation() })
}

extension String {
    // 将字符串以CGImage显示
    var cgImage: CGImage? {
        let textAttri: [String: Any]? = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        
        UIGraphicsBeginImageContextWithOptions(self.size(attributes: textAttri), false, 0)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(at: .zero, withAttributes: textAttri)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image?.cgImage
    }
}
