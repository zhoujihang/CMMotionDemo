//
//  CMMotionManagerViewController.swift
//  CMMotionDemo
//
//  Created by 周际航 on 2017/5/9.
//  Copyright © 2017年 com.maramara. All rights reserved.
//

import UIKit
import CoreMotion

class CMMotionManagerViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView()
    
    fileprivate var motionManager = CMMotionManager()
    fileprivate var isUpdateDeviceMotion: Bool = false
    fileprivate var isUpdateAccelerometer: Bool = false
    fileprivate var isUpdateMagnetometer: Bool = false
    fileprivate var isUpdateGyro: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: - 扩展 UI
private extension CMMotionManagerViewController {
    func setup() {
        self.setupView()
        self.setupConstraints()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func setupConstraints() {
        self.tableView.frame = UIScreen.main.bounds
    }
}

// MARK: - 扩展 UITableViewDelegate
extension CMMotionManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .default, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        
        var title = "\(indexPath.section) - \(indexPath.row)"
        
        if indexPath.row == 0 {
            title = "测试传感器可用性"
        } else if indexPath.row == 1 {
            title = "设备动作检测"
        } else if indexPath.row == 2 {
            title = "加速器检测"
        } else if indexPath.row == 3 {
            title = "磁力器检测"
        } else if indexPath.row == 4 {
            title = "陀螺仪检测"
        }
        
        cell.textLabel?.text = title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.test0()
        } else if indexPath.row == 1 {
            self.test1()
        } else if indexPath.row == 2 {
            self.test2()
        } else if indexPath.row == 3 {
            self.test3()
        } else if indexPath.row == 4 {
            self.test4()
        }
    }
}

// MARK: - 扩展 点击事件
private extension CMMotionManagerViewController {
    
    func test0() {
        _ = self.checkAllMotionAvailable()
    }
    
    func test1() {
        self.startDeviceMotionUpdate()
    }
    
    func test2() {
        self.startAccelerometerUpdates()
    }
    
    func test3() {
        self.startMagnetometerUpdates()
    }
    
    func test4() {
        self.startGyroUpdates()
    }
}

private extension CMMotionManagerViewController {
    func checkAllMotionAvailable() -> Bool {
        var flag = true
        if !self.motionManager.isDeviceMotionAvailable {
            "isDeviceMotionAvailable  no".ext_debugPrintAndHint()
            flag = false
        }
        if !self.motionManager.isAccelerometerAvailable {
            "isAccelerometerAvailable  no".ext_debugPrintAndHint()
            flag = false
        }
        if !self.motionManager.isMagnetometerAvailable {
            "isMagnetometerAvailable  no".ext_debugPrintAndHint()
            flag = false
        }
        if !self.motionManager.isGyroAvailable {
            "isGyroAvailable  no".ext_debugPrintAndHint()
            flag = false
        }
        "all motion available".ext_debugPrintAndHint()
        return flag
    }
    
    // 设备动作？
    func startDeviceMotionUpdate() {
        if self.isUpdateDeviceMotion {
            self.isUpdateDeviceMotion = false
            "stop  DeviceMotionUpdates".ext_debugPrintAndHint()
            self.motionManager.stopDeviceMotionUpdates()
        } else {
            self.isUpdateDeviceMotion = true
            "start  DeviceMotionUpdates".ext_debugPrintAndHint()
            self.motionManager.deviceMotionUpdateInterval = 3
            self.motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue.main) { (motion, error) in
                guard error == nil else {
                    "startDeviceMotionUpdates  error:\(String(describing: error))".ext_debugPrintAndHint()
                    return
                }
                guard let _motion = motion else {
                    "startDeviceMotionUpdates  motion is nil".ext_debugPrintAndHint()
                    return
                }
                
                let attitude = _motion.attitude
                let rotationRate = _motion.rotationRate
                let gravity = _motion.gravity
                let userAcceleration = _motion.userAcceleration
                let magneticField = _motion.magneticField
                "\(attitude)  \(rotationRate)  \(gravity)  \(userAcceleration)  \(magneticField)".ext_debugPrintAndHint()
            }
        }
        
    }
    
    // 加速器
    func startAccelerometerUpdates() {
        if self.isUpdateAccelerometer {
            self.isUpdateAccelerometer = false
            "stop  AccelerometerUpdates".ext_debugPrintAndHint()
            self.motionManager.stopAccelerometerUpdates()
        } else {
            self.isUpdateAccelerometer = true
            "start  AccelerometerUpdates".ext_debugPrintAndHint()
            self.motionManager.accelerometerUpdateInterval = 3
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (meterData, error) in
                guard error == nil else {
                    "startAccelerometerUpdates  error:\(String(describing: error))".ext_debugPrintAndHint()
                    return
                }
                guard let data = meterData else {
                    "startAccelerometerUpdates  meterData is nil".ext_debugPrintAndHint()
                    return
                }
                
                let acceleration = data.acceleration
                "\(acceleration)".ext_debugPrintAndHint()
            }
        }
        
    }
    
    // 磁力器
    func startMagnetometerUpdates() {
        if self.isUpdateMagnetometer {
            self.isUpdateMagnetometer = false
            "stop  MagnetometerUpdates".ext_debugPrintAndHint()
            self.motionManager.stopMagnetometerUpdates()
        } else {
            self.isUpdateMagnetometer = true
            "start  MagnetometerUpdates".ext_debugPrintAndHint()
            self.motionManager.magnetometerUpdateInterval = 3
            self.motionManager.startMagnetometerUpdates(to: OperationQueue.main) { (meterData, error) in
                guard error == nil else {
                    "startMagnetometerUpdates  error:\(String(describing: error))".ext_debugPrintAndHint()
                    return
                }
                guard let data = meterData else {
                    "startMagnetometerUpdates  meterData is nil".ext_debugPrintAndHint()
                    return
                }
                
                let magneticField = data.magneticField
                "\(magneticField)".ext_debugPrintAndHint()
            }
        }
    }
    
    // 陀螺仪
    func startGyroUpdates() {
        if self.isUpdateGyro {
            self.isUpdateGyro = false
            "stop  GyroUpdates".ext_debugPrintAndHint()
            self.motionManager.stopGyroUpdates()
        } else {
            self.isUpdateGyro = true
            "start  GyroUpdates".ext_debugPrintAndHint()
            self.motionManager.gyroUpdateInterval = 3
            self.motionManager.startGyroUpdates(to: OperationQueue.main) { (gyroData, error) in
                guard error == nil else {
                    "startGyroUpdates  error:\(String(describing: error))".ext_debugPrintAndHint()
                    return
                }
                guard let data = gyroData else {
                    "startGyroUpdates  gyroData is nil".ext_debugPrintAndHint()
                    return
                }
                
                let rotationRate = data.rotationRate
                "\(rotationRate)".ext_debugPrintAndHint()
            }
        }
    }
}
