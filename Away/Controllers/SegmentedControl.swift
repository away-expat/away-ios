//
//  SegmentedControl.swift
//  Away
//
//  Created by Candice Guitton on 24/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class SegmentedControl: UIView {
    var segmentControlDelegate:CustomSegmentedControlDelegate?
    private var buttonsTitle: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var selectorViewColor = UIColor(named: "AppOrange")
    var selectorPosition: CGFloat?
    
    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        self.buttonsTitle = buttonTitle
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateViews()
    }
    
    func setIndex(index: Int) {
        self.selectorPosition = self.frame.width/CGFloat(self.buttonsTitle.count) * CGFloat(index)
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

    }
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttons.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        if self.selectorPosition != nil {
            selectorView.frame.origin.x = self.selectorPosition!
        }
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonsTitle {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: buttonTitle)?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(10,35,10,35)
            button.addTarget(self, action: #selector(SegmentedControl.buttonAction(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
    }
    @objc func buttonAction(_ sender: UIButton) {
        for (buttonIndex, btn) in  buttons.enumerated() {
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonsTitle.count) * CGFloat(buttonIndex)
                segmentControlDelegate?.changeTab(index: buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                
             }
        }
    }
    private func updateViews() {
        createButtons()
        configSelectorView()
        configStackView()
    }
    
}

protocol CustomSegmentedControlDelegate {
    func changeTab(index: Int)
}
