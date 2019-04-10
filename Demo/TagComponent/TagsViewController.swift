//
//  TagsCollectionView.swift
//  TravelLive
//
//  Created by Catalin-Andrei BORA on 3/15/18.
//  Copyright © 2018 digitalPomelo. All rights reserved.
//

//KTCenterFlowLayout()

import UIKit

protocol TagsCollectionViewDelegate: class {
    func dataSetChanged(_ tagController: TagsViewController, newDataSet: TagViewModelProtocol?)
}

class TagsViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var addNewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var cellInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    private var _allRemovableTags = false
    var allRemovableTags:Bool
    {
        set
        {
            _allRemovableTags = newValue
            _allNonRemovableTags = !_allRemovableTags
        }
        get
        {
            return _allRemovableTags
        }
    }
    private var _allNonRemovableTags = false
    var allNonRemovableTags:Bool
    {
        set
        {
            _allNonRemovableTags = newValue
            _allRemovableTags = !_allNonRemovableTags
        }
        get
        {
            return _allNonRemovableTags
        }
    }
    
    var tags:TagViewModelProtocol = TagViewModel()

    var directionHorizontal = false
    {
        didSet
        {
            setDirection()
        }
    }
    
    private func setDirection()
    {
        if (false == directionHorizontal)
        {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0            
            collectionView!.collectionViewLayout = layout
        }
        else
        {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView!.collectionViewLayout = layout
            showAddNewBar = false
        }
    }
    
    weak var delegate:TagsCollectionViewDelegate?
    
    @IBOutlet weak var textAddNew: UITextField!
    
    @IBOutlet weak var viewAddnew: UIView! 
    
    private var originalAddNewBarHeight:CGFloat = 0
    public var showAddNewBar = true
    {
        didSet
        {
            guard view != nil else {return}
            resizeForAddNewBarChange()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: String(describing: TagsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TagsCollectionViewCell.self))
        
//        layout.estimatedItemSize = CGSize(width:1.0,height:1.0)
            
        setDirection()
        
        tags.delegate = self
        textAddNew.delegate = self
        originalAddNewBarHeight = viewAddnew.bounds.size.height
        collectionView.reloadData()
        
        let iconFilter = #imageLiteral(resourceName: "filter_icon").withRenderingMode(.alwaysTemplate)
        let iconFilterView = UIImageView(image: iconFilter)
        iconFilterView.contentMode = .scaleAspectFit
        iconFilterView.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        iconFilterView.tintColor = UIColor.lightGray
        textAddNew.leftView = iconFilterView
        textAddNew.leftViewMode = .always
        
        buttonAdd.layer.cornerRadius = 5
//        let l = TagCellLayout(alignment: .center, delegate: self)
//        collectionView.collectionViewLayout = l
    }
    
    func resizeForAddNewBarChange()
    {
        if (showAddNewBar == false)
        {
            self.addNewHeight.constant = 0
            viewAddnew.isHidden = true
        }
        else
        {
            self.addNewHeight.constant = 38
            viewAddnew.isHidden = false
        }
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        resizeForAddNewBarChange()
        
        collectionView.layoutIfNeeded()
        collectionView.sizeToFit()
        
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightConstraint.constant = height
        
        collectionView.updateConstraints()
        collectionView.layoutIfNeeded()
        
        view.layoutIfNeeded()
        
        delegate?.dataSetChanged(self, newDataSet: tags)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        collectionView.reloadData()
    }
    
    func addTagComponentToContainerView(parentVC: UIViewController, containerView: UIView)
    {
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        
        parentVC.addChild(self)
            
        self.didMove(toParent: parentVC)
                
        let containerViewLeadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: containerView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        let containerViewTopConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal
            , toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        
        let containerViewBottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal
            , toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let containerViewEndConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal
            , toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([containerViewLeadingConstraint, containerViewTopConstraint,
                                     containerViewBottomConstraint,containerViewEndConstraint])
        
        view.superview?.setNeedsUpdateConstraints()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        addTagFromTextField()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 40
    }
    
    func addTagFromTextField()
    {
        guard textAddNew!.text != nil &&  textAddNew!.text != "" else {return}
        
        let tag = Tag(name:textAddNew!.text!, selected:true, optional:true)
        
        tags.addTag(tag: tag)
        
        textAddNew.text = nil
    }
    
    @IBAction func pressedAdd(_ sender: Any)
    {
        textAddNew.resignFirstResponder()
        
        addTagFromTextField()
    }
    
    func unselectAllTags()
    {
        
        tags.unselectAllTags()
        collectionView.reloadData()
        delegate?.dataSetChanged(self,newDataSet: tags)
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TagsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagsCollectionViewCell.self), for: indexPath) as! TagsCollectionViewCell
        
        cell.tagData = tags.at(indexPath.row)
        
        cell.clearMethod =
        { [weak self] tagData in
                
            self?.tags.remove(tag:tagData)
        }
        
        if allRemovableTags {
            cell.forceShowDeleteButton = true
            cell.selectMethod = cell.clearMethod
        } else {
            cell.selectMethod =
            {
                [weak self] tagData in
                self?.tags.changeSelection(tag:tagData)
            }
        }
        
        if allNonRemovableTags {
            cell.forceDoNotShowDeleteButton = true
            cell.clearMethod = nil
            cell.selectMethod =
            {
                [weak self] tagData in
                self?.tags.changeSelection(tag:tagData)
            }
        }
        
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tag = tags.at(indexPath.row)!
        let myString: String = tag.name
        var size: CGSize = myString.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
        size.width+=24 + cellInsets.left + cellInsets.right
        
        if (allRemovableTags || (tag.optional && !allNonRemovableTags) )
        {
            size.width += 30
        }
        
        return CGSize(width:(size.width), height: 35 + cellInsets.top + cellInsets.bottom);
    }
}


extension TagsViewController : TagViewModelDelegate
{
    func didChangeSelection(tag:Tag,atIndex:Int)
    {
        collectionView.reloadItems(at: [IndexPath(row: atIndex, section: 0)])
        view.setNeedsLayout()
        delegate?.dataSetChanged(self,newDataSet:tags)
    }
    
    func didAddTag(tag:Tag,atIndex:Int)
    {
        let i = IndexPath(item: atIndex, section: 0)
        collectionView.insertItems(at: [i])
        view.setNeedsLayout()
        delegate?.dataSetChanged(self,newDataSet: tags)
    }
    
    func didRemoveTag(tag:Tag,atIndex:Int)
    {
        self.collectionView.deleteItems(at: [IndexPath(row: atIndex, section: 0)])
        self.view.setNeedsLayout()
        self.delegate?.dataSetChanged(self,newDataSet: tags)
    }
    
    func dataSetChanged(_ tagController: TagViewModelProtocol)
    {
        collectionView.reloadData()
        view.setNeedsLayout()
        delegate?.dataSetChanged(self,newDataSet: tags)
    }
}
