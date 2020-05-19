//
//  SearchBar.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/5/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

final class SearchBar: UISearchBar {
    
    lazy private var searchBarTintColor: UIColor = UIColor.white
    
    init(tintColor: UIColor?) {
        
        super.init(frame: .zero)
        
        if let newTintColor = tintColor { searchBarTintColor = newTintColor }
        
        configureSearchBar()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureSearchBar()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureSearchBar()
        
    }
    
    private func configureSearchBar() {
        
        isTranslucent = false
        searchBarStyle = .minimal
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        addShadowAndRoundCorners(shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
        
        searchTextField.font = UIFont(name: "HelveticaNeue-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 19.0))
        searchTextField.textColor = searchBarTintColor
        searchTextField.layer.cornerRadius = .getWidthFitSize(minSize: 11.0, maxSize: 16.0)
        searchTextField.layer.cornerCurve = .continuous
        searchTextField.layer.masksToBounds = true
        searchTextField.leftView?.tintColor = searchBarTintColor
        searchTextField.backgroundColor = .BgGray
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: searchBarTintColor])
        
    }
    
}

