//
//  GridViewCell.swift
//  MOSP
//
//  Created by apple on 2017/11/18.
//

import UIKit
import SnapKit
import IGListKit
import Kingfisher
class GridCell: UICollectionViewCell {
    typealias ItemType = GridItem
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// backgroundImageView
    lazy var backgroundImageView = { () -> UIImageView in
        let imageView = UIImageView()
        return imageView

    }()

    /// iconImageView
     lazy var iconImageView = { () -> UIImageView in
        let imageView = UIImageView()
        return imageView
    }()

    lazy var label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textAlignment = .center
        view.textColor = .gray
        view.font = .boldSystemFont(ofSize: 14)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-10)
            make.width.height.equalTo(26)
        }

        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.edges.equalTo(contentView)
        }

        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.left.right.equalTo(contentView)
        }
    }

    func config(_ model: ItemType?) {
        guard let model = model else {
            return
        }
        if !model.backgroundImageURL.isEmpty,
            let url = URL(string: model.backgroundImageURL) {
            backgroundImageView.kf.setImage(with: url, placeholder: UIImage(named: "spaceship.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            if !model.backgroundImageName.isEmpty {
                backgroundImageView.image = UIImage(named: model.backgroundImageName)
            } else {
                backgroundImageView.image = nil
            }
        }
        if !model.imageName.isEmpty {
            iconImageView.image = UIImage(named: model.imageName)
        } else {
            iconImageView.image = nil
        }
        label.text = model.title
    }
}

extension GridCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
//        guard let viewModel = viewModel as? String else { return }
//        label.text = viewModel
    }
}
