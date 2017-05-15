//
//  ViewController.swift
//  CMMotionDemo
//
//  Created by 周际航 on 2017/5/9.
//  Copyright © 2017年 com.maramara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: - 扩展 UI
private extension ViewController {
    func setup() {
        self.setupView()
        self.setupConstraints()
    }
    
    func setupView() {
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
            title = "CMPedometer"
        } else if indexPath.row == 1 {
            title = "CMMotionManager"
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
        }
    }
}

// MARK: - 扩展 点击事件
private extension ViewController {
    
    func test0() {
        let vc = CMPedometerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func test1() {
        let vc = CMMotionManagerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

