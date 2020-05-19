//
//  Workspace.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/21/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

class Workspace: UICollectionViewCell {
    
    var workspaceName: String!
    
    var workspaceLabel: UILabel!
    
    var current: Bool!
    
    override init(frame: CGRect){
    super.init(frame: frame)
    workspaceName = String()
    current = Bool()
    workspaceLabel = UILabel(frame: CGRect.zero)
        
    workspaceLabel.text = ""
    workspaceLabel.textColor = UIColor.AnalCream
            
        contentView.addSubview(workspaceLabel)
        workspaceLabel.translatesAutoresizingMaskIntoConstraints = false
        workspaceLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        workspaceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        workspaceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        workspaceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
