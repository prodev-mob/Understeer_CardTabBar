//
//  BarItemView.swift
//  CardTabbar
//
//  Created by Yusa Dogru on 25.11.2021.
//

import UIKit

// MARK: - BarItemView
class BarItemView: UIView {
    // MARK: - Options
    private enum Options {
        static let minWidth: CGFloat = 65
        static let maxWidth: CGFloat = 110
    }

    // MARK: - Views
    lazy var indicatorView: UIView = .build()
    
    let screenHeight = UIScreen.main.bounds.height
    
    private lazy var labelTitle: UILabel = .build { label in
        if self.screenHeight <= 667 { // iPhone 8 or smaller
            label.font = UIFont(name: "TitilliumWeb-SemiBold", size: 11.50)
        } else if self.screenHeight >= 812 && self.screenHeight < 896 { // iPhone X, iPhone 11 Pro, iPhone 12 Pro
            label.font = UIFont(name: "TitilliumWeb-SemiBold", size: 12)
        } else if self.screenHeight >= 896 { // iPhone 11, iPhone 11 Pro Max, iPhone 12 Pro Max
            label.font = UIFont(name: "TitilliumWeb-SemiBold", size: 12)
        } else {
            label.font = UIFont(name: "TitilliumWeb-SemiBold", size: 11)
        }
        label.textAlignment = .center
    }

    private lazy var viewContainer: UIView = .build()

    // MARK: - Properties
    var widthConstraint: NSLayoutConstraint? = nil
    var titleLeadingConstraint: NSLayoutConstraint? = nil
    var button: BarButton!

    var isSelected: Bool = false {
        didSet {
            indicatorView.alpha = isSelected ? 1 : 0
            widthConstraint?.constant = isSelected ? (self.button.tag == 2 ? 86 : Options.maxWidth) : Options.minWidth
            
            labelTitle.alpha = isSelected ? 1 : 0
            titleLeadingConstraint?.isActive = isSelected
            button.isSelected = isSelected
        }
    }
    
    override var tintColor: UIColor! {
        set { labelTitle.textColor = newValue }
        get { return labelTitle.textColor }
    }
    
    override var backgroundColor: UIColor? {
        set { indicatorView.backgroundColor = newValue }
        get { return indicatorView.backgroundColor }
    }

    // MARK: - Init
    init(item: UITabBarItem) {
        super.init(frame: .zero)
        button = BarButton(forItem: item)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        labelTitle.text = item.title

        clipsToBounds = true
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    func setupConstraint() {
        addSubview(indicatorView)
        addSubview(viewContainer)
        viewContainer.addSubview(labelTitle)
        viewContainer.addSubview(button)
        
        let labelTrailingConstraint: NSLayoutConstraint
           if screenHeight <= 667 { // iPhone 8 or smaller
               labelTrailingConstraint = labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -4)
           } else if screenHeight >= 812 && screenHeight < 896 { // iPhone X, iPhone 11 Pro, iPhone 12 Pro
               labelTrailingConstraint = labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -12)
           } else if screenHeight >= 896 { // iPhone 11, iPhone 11 Pro Max, iPhone 12 Pro Max
               labelTrailingConstraint = labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -12)
           } else {
               labelTrailingConstraint = labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -4)
           }
        
        NSLayoutConstraint.activate([
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),

            indicatorView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            indicatorView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            
            button.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 4),
            button.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -4),
            button.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 4),
            button.heightAnchor.constraint(equalTo: button.widthAnchor),
            
            labelTitle.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            labelTrailingConstraint
        ])
        
        widthConstraint = viewContainer.widthAnchor.constraint(equalToConstant: 44)
        widthConstraint?.isActive = true
        
        if screenHeight <= 667 { // iPhone 8 or smaller
            titleLeadingConstraint = labelTitle.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: -3)
        } else if screenHeight >= 812 && screenHeight < 896 { // iPhone X, iPhone 11 Pro, iPhone 12 Pro
            titleLeadingConstraint = labelTitle.leadingAnchor.constraint(equalTo: button.trailingAnchor)
        } else if screenHeight >= 896 { // iPhone 11, iPhone 11 Pro Max, iPhone 12 Pro Max
            titleLeadingConstraint = labelTitle.leadingAnchor.constraint(equalTo: button.trailingAnchor)
        } else {
            titleLeadingConstraint = labelTitle.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: -3)
        }
        
        titleLeadingConstraint?.isActive = true
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        viewContainer.layer.cornerRadius = viewContainer.bounds.height / 2
        indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
        button.layer.cornerRadius = button.bounds.height / 2
    }
}

// MARK: - BarButton
class BarButton: UIButton {
    // MARK: - Init
    init(forItem item: UITabBarItem) {
        super.init(frame: .zero)
        setImage(item.image, for: .normal)
        setImage(item.selectedImage, for: .selected)
    }

    init(image: UIImage){
        super.init(frame: .zero)
        setImage(image, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
