//
//  SearchResultTableViewCell.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 07/04/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    public static let identifier = "SearchResultTableViewCell"
    
    
    let imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let descLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.width.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalToSuperview().offset(-10)
        }
        descLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    public func configure(with viewModel: NewsViewModel)
    {
        imgView.sd_setImage(with: URL(string: viewModel.imgUrl ?? ""), placeholderImage: UIImage(named: "no_data"))
        titleLabel.text = viewModel.title
        descLabel.text = viewModel.content
    }
}
