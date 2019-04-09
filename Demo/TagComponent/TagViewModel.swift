//
//  TagCollection.swift
//  TravelLive
//
//  Created by Walter Fettich on 08/04/2019.
//  Copyright © 2019 digitalPomelo. All rights reserved.
//

import UIKit

protocol TagViewModelDelegate: class {
    func dataSetChanged(_ tagController: TagViewModelProtocol)
    func didSelect(tag:Tag,atIndex:Int)
    func didAddTag(tag:Tag,atIndex:Int)
}

protocol TagViewModelProtocol
{
    var allRemovableTags:Bool {get set}
    var allNonRemovableTags:Bool {get set}
    var multiSelect:Bool {set get}
    var mustHaveOneSelection:Bool {set get}
    var data:[Tag] { get }
    
    func selectFromTags(tags:[Tag])
    func addTag(tag:Tag)
    func remove(tag tagData:Tag ) -> Int?
    func setDataWithoutCallingDelegate(_ data:[Tag] )
    func unselectAllTags()
}

class TagViewModel: NSObject, TagViewModelProtocol
{
    weak var delegate:TagViewModelDelegate?
    var multiSelect = true
    var mustHaveOneSelection = false
    var data:[Tag]
    {
        set
        {
            _data = newValue
            delegate?.dataSetChanged(self)
            
        }
        get
        {
            return _data
        }
    }
    
    private var _data:[Tag] = []
    
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
    
    func selectFromTags(tags:[Tag])
    {
        let selectedPrices = tags.compactMap { (tag) -> String? in
            return tag.category == self.category ? tag.value : nil
        }
        
        for i in 0..<data.count
        {
            data[i].selected = selectedPrices.contains(data[i].value)
        }
        
        if (self.mustHaveOneSelection && selectedTags().count == 0
            && data.count > 0)
        {
            didSelect(tag: data.first!)
        }
    }
    
    var category:String? = nil
    {
        didSet
        {
            guard category != nil else {return}
            
            //            for i in 0..<data.count
            //            {
            //                data[i].category = category!
            //            }
        }
    }
    
    func clearAllTags()
    {
        _data.removeAll()
        delegate?.dataSetChanged(self)
    }
    
    func setDataWithoutCallingDelegate(_ data:[Tag] )
    {
        let d = self.delegate
        self.delegate = nil
        self.data = data
        self.delegate = d
        
    }
    
    func remove(tag tagData:Tag ) -> Int?
    {
        if let index = _data.index( where: { (tag) -> Bool in
            tag.name ==  tagData.name
            })
        {
            _data.remove(at: index)
            return index
        }
        return nil
    }
    
    func addTag(tag:Tag)
    {
        var t = tag
        let pos = data.count
        //        if category != nil
        //        {
        //            t.category = category!
        //        }
        
        //does tag already exist?
        let index = data.index(where: {$0.name.lowercased() == t.name.lowercased()})
        if index  == nil
        { //no
            
            //give it a order number
            if let maxOrderNr = data.max(by: {$0.orderNumber ?? 0 < $1.orderNumber ?? 0 })?.orderNumber
            {
                t.orderNumber = maxOrderNr + 1
            }
            
            _data.insert(t, at: pos)
            delegate?.didAddTag(tag:tag,atIndex:pos)
        }
        else
        {
            //yes, then just select it
            if !data[index!].selected
            {
                didSelect(tag: data[index!])
            }
        }
    }
    
    func unselectAllTags()
    {
        for i in 0..<data.count
        {
            if mustHaveOneSelection == true && selectedTags().count == 1
            {
            break;
            }
        
            data[i].selected = false
        }
    }
    
    func selectedTags () -> [Tag]
    {
        var res:[Tag] = []
        for i in 0..<data.count
        {
            let t = data[i]
            if(t.selected)
            {
                res.append(t)
            }
        }
        return res
    }
    
    func didSelect(tag:Tag)
    {
        if let index = data.index( where: { (t) -> Bool in
            t.name ==  tag.name
        })
        {
            if !(mustHaveOneSelection && data[index].selected && selectedTags().count < 2)
            {
                if (!data[index].selected && multiSelect == false)
                {
                    for i in 0..<data.count
                    {
                        data[i].selected = false
                    }
                }
                
                let wasSelected = data[index].selected
                data[index].selected = !(data[index].selected)

            }
        }
    }

}
