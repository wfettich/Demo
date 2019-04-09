//
//  TagsCollectionViewCell.swift
//  TravelLive
//
//  Created by Catalin-Andrei BORA on 3/15/18.
//  Copyright © 2018 digitalPomelo. All rights reserved.
//
import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundRoundedView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagMaxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagMinWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelDeleteWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelDeleteTag: UILabel!
    @IBOutlet weak var buttonDeleteTag: UIButton!
    
    var originalWidthForDeleteLabel:CGFloat = 0
    
    var forceShowDeleteButton: Bool = false
    var forceDoNotShowDeleteButton: Bool = false
    var tagSelectable: Bool?
    
    var clearMethod: ((_ tagData: Tag) -> ())?
    var selectMethod: ((_ tagData: Tag) -> ())?    
    
    var tagData: Tag? {
        didSet {
            
            guard tagData != nil else {return}
            
            self.tagLabel.text = tagData!.name
            self.updateTagSelectionDisplay()
            
            isAccessibilityElement = true
            
            accessibilityLabel = tagData?.name
            accessibilityIdentifier = tagData?.value
            accessibilityValue = tagData?.value
            accessibilityTraits.insert(.button)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundRoundedView.layer.cornerRadius = 4.0
        backgroundRoundedView.clipsToBounds = true
        
        originalWidthForDeleteLabel = labelDeleteTag.bounds.size.width
        
        backgroundRoundedView.layer.borderWidth = 1
        backgroundRoundedView.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func leftTagButtonPressed(_ sender: UIButton) {
        if let localSelectMethod = selectMethod, let localTagData = tagData {
            localSelectMethod(localTagData)
        }
    }
    
    @IBAction func rightTagButtonPressed(_ sender: Any) {
        if let localClearMethod = clearMethod, let localTagData = tagData {
            localClearMethod(localTagData)
        }
    }
    
    private func updateTagSelectionDisplay() {
        
        if tagData!.selected {
            backgroundRoundedView.backgroundColor = UIColor.black
            tagLabel.textColor = UIColor.white
            accessibilityTraits.insert(.selected)
        } else {
            backgroundRoundedView.backgroundColor = UIColor.white
            tagLabel.textColor = UIColor.black
            accessibilityTraits.remove(.selected)
        }
        
        updateConstants()
    }
    
    func updateConstants()
    {
        if forceDoNotShowDeleteButton
        {
            labelDeleteWidthConstraint.constant = 0
        }
        else if forceShowDeleteButton || tagData!.optional
        {
            labelDeleteWidthConstraint.constant =  originalWidthForDeleteLabel            
        }
        else
        {
            labelDeleteWidthConstraint.constant = 0
        }
        
        setNeedsUpdateConstraints()
    }
    
}
