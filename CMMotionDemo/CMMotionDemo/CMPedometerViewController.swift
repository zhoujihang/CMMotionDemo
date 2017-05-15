//
//  CMPedometerViewController.swift
//  CMMotionDemo
//
//  Created by 周际航 on 2017/5/9.
//  Copyright © 2017年 com.maramara. All rights reserved.
//

import UIKit
import CoreMotion

class CMPedometerViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView()
    
    fileprivate var pedometer = CMPedometer()
    fileprivate var totalSteps: Int = 0
    fileprivate var isStartUpdate: Bool = false
    
    fileprivate var timer: Timer?
    fileprivate var isTimerTaskRun: Bool = false
    
    deinit {
        self.pedometer.stopUpdates()
        "deinit".ext_debugPrint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}
// MARK: - 扩展 UI
private extension CMPedometerViewController {
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
extension CMPedometerViewController: UITableViewDelegate, UITableViewDataSource {
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
            title = "连续监听计步器数据"
        } else if indexPath.row == 1 {
            title = "单次查询 10分钟内总步数"
        } else if indexPath.row == 2 {
            title = "每秒定时查询 <10分钟内总步数>"
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
        }
    }
}

// MARK: - 扩展 点击事件
private extension CMPedometerViewController {
    
    func test0() {
        self.startUpdatePedometer()
    }
    
    func test1() {
        self.queryPedometerData10Mins()
    }
    
    func test2() {
        if self.isTimerTaskRun {
            "停止定时查询".ext_debugPrintAndHint()
            self.removeTimer()
            self.isTimerTaskRun = false
        } else {
            "开始定时查询".ext_debugPrintAndHint()
            self.setupTimer()
            self.isTimerTaskRun = true
        }
    }
}

private extension CMPedometerViewController {
    func startUpdatePedometer() {
        guard !self.isStartUpdate else {
            "停止监听计步器数据".ext_debugPrintAndHint()
            self.pedometer.stopUpdates()
            self.isStartUpdate = false
            return
        }
        self.isStartUpdate = true
        
        guard CMPedometer.isStepCountingAvailable() else {
            "本机不支持计步器".ext_debugPrintAndHint()
            return
        }
        
        "开始监听计步器数据".ext_debugPrintAndHint()
        self.pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                guard error == nil else {
                    "CMPedometer - startUpdate error:\(String(describing: error))".ext_debugPrintAndHint()
                    return
                }
                guard let pedometerData = data else {
                    "CMPedometer - startUpdate data is nil".ext_debugPrintAndHint()
                    return
                }
                
                let steps = pedometerData.numberOfSteps.intValue
                let oldSteps = self?.totalSteps ?? 0
                let temp = steps - oldSteps
                self?.totalSteps = steps
                "new steps: \(temp)".ext_debugPrintAndHint()
            }
        }
    }
    
    func queryPedometerData10Mins() {
        guard CMPedometer.isStepCountingAvailable() else {
            "本机不支持计步器".ext_debugPrintAndHint()
            return
        }
        
        let nowDate = Date()
        let tenMinuteBeforeDate = Date(timeIntervalSinceNow: -3600 * 10)
        self.pedometer.queryPedometerData(from: tenMinuteBeforeDate, to: nowDate) { (data, error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                guard error == nil else {
                    "CMPedometer - queryPedometerData error:\(String(describing: error))".ext_debugPrintAndHint()
                    return
                }
                guard let pedometerData = data else {
                    "CMPedometer - queryPedometerData data is nil".ext_debugPrintAndHint()
                    return
                }
                
                let steps = pedometerData.numberOfSteps.intValue
                "10分钟内步数：\(steps)".ext_debugPrintAndHint()
            }
        }
    }
}

// MARK: - 扩展 定时器任务
private extension CMPedometerViewController {
    func setupTimer() {
        self.removeTimer()
        let timerARC = TimerARC()
        timerARC.updateTimerHandler = { [weak self] in
            self?.timerTask()
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: timerARC, selector: #selector(timerARC.updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
        self.timer?.fire()
    }
    func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil;
    }
    @objc func timerTask() {
        self.queryPedometerData10Mins()
    }
}

