//
//  GridViewCell.swift
//  MOSP
//
//  Created by apple on 2017/11/18.
//

import UIKit
import SnapKit
class GridCell: UICollectionViewCell {
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

    /// backgroundImageView
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
}
