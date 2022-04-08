//
//  PickerViewController.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 08/04/22.
//

import UIKit

protocol PickerViewControllerDelegate: AnyObject{
    func didOkButtonTapped(selectedName: String, selectedId: String)
}

class PickerViewController: UIViewController {
    
    var selectedId = ""
    var selectedName = ""
    private var viewModels = [SourceViewModel]()
    
    weak var delegate: PickerViewControllerDelegate?
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .systemBackground
        return pv
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let okBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(UIColor.link, for: .normal)
        return btn
    }()
    private let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(bottomView)
        bottomView.addSubview(pickerView)
        bottomView.addSubview(topView)
        topView.addSubview(okBtn)
        topView.addSubview(cancelBtn)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        okBtn.addTarget(self, action: #selector(didOkClicked), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(didCancelClicked), for: .touchUpInside)
    }
    
    @objc func didOkClicked() {
        print("selec \(selectedName)")
        dismiss(animated: true)
        delegate?.didOkButtonTapped(selectedName: selectedName, selectedId: selectedId)
        
    }
    @objc func didCancelClicked() {
        dismiss(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.height/1.5)
        }
        
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.top.equalTo(5)
        }
        
        okBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.height.equalTo(34)
            make.width.equalTo(80)
            make.top.equalTo(5)
        }
    }
    
    public func configure(with items: [SourceViewModel]) {
        self.viewModels = items
        pickerView.reloadAllComponents()
    }
}

extension PickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = self.viewModels[row]
        return model.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        guard let selectedId = self.viewModels[row].url else {
//            return
//        }
//        print("selected id \(selectedId)")
        self.selectedId = self.viewModels[row].url
        self.selectedName = self.viewModels[row].name
    }
    
}
