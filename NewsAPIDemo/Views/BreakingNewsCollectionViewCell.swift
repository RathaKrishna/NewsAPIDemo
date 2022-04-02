//
//  BreakingNewsCollectionViewCell.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/4/2.
//

import UIKit

class BreakingNewsCollectionViewCell: UICollectionViewCell {
    public static let identifier = "BreakingNewsCollectionViewCell"
    
    let imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3
        return label
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0, alpha: 0.6)
        view.layer.masksToBounds = true
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgView)
        contentView.addSubview(bgView)
        bgView.addSubview(titleLabel)
//        contentView.addSubview(descLabel)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = contentView.bounds
        
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(contentView.height/2)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(10)
        }
//        descLabel.snp.makeConstraints { make in
//            make.left.right.equalTo(titleLabel)
//            make.top.equalTo(titleLabel.snp.bottom)
//            make.bottom.equalToSuperview().offset(-5)
//        }
    }
    
    public func configure(with viewModel: NewsViewModel) {
        imgView.sd_setImage(with: URL(string: viewModel.imgUrl ?? ""))
        titleLabel.text = viewModel.title
//        descLabel.text = viewModel.content
    }
    
}
