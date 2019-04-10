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
    func didChangeSelection(tag:Tag,atIndex:Int)
    func didAddTag(tag:Tag,atIndex:Int)
    func didRemoveTag(tag:Tag,atIndex:Int)
}

protocol TagViewModelProtocol
{
    weak var delegate:TagViewModelDelegate? {set get}
    
    var multiSelect:Bool {set get}
    var mustHaveOneSelection:Bool {set get}
    var count:Int {get}
    var data:[Tag] {get}
    var category:String? {set get}
    
    func at(_ index:Int) -> Tag?
    func setSelected(tags:[Tag])
    func addTag(tag:Tag)
    func remove(tag tagData:Tag )
    func setDataWithoutCallingDelegate(_ data:[Tag] )
    func unselectAllTags()
    func changeSelection(tag:Tag)
    func selectedTags () -> [Tag]
    func clear()
    
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
    
    func setSelected(tags:[Tag])
    {
        let selectedTags = tags.compactMap { (tag) -> String? in
            return (self.category == nil || tag.category == self.category) ? tag.value : nil
        }
        
        for i in 0..<data.count
        {
            _data[i].selected = selectedTags.contains(data[i].value)
            delegate?.didChangeSelection(tag: _data[i], atIndex: i)
        }
        delegate?.dataSetChanged(self)
        
        if (self.mustHaveOneSelection && self.selectedTags().count == 0
            && data.count > 0)
        {
            changeSelection(tag: data.first!)
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
    
    var count: Int
    {
        get
        {
            return _data.count
        }
    }
    
    func at(_ index:Int) -> Tag?
    {
        if _data.count > index
        {
            return _data[index]
        }
        else
        {
            return nil
        }
    }
    
    func clear()
    {
        _data.removeAll()
        delegate?.dataSetChanged(self)
    }
    
    func setDataWithoutCallingDelegate(_ data:[Tag] )
    {
        _data = data
        for (i,_) in _data.enumerated()
        {
            _data[i].orderNumber = i + 1
        }
  
//        self.delegate?.dataSetChanged(self)
    }
    
    func remove(tag tagData:Tag )
    {
        if let index = _data.index( where: { (tag) -> Bool in
            tag.name ==  tagData.name
            })
        {
            let t = _data[index]
            _data.remove(at: index)
            delegate?.didRemoveTag(tag: t, atIndex: index)
        }
    }
    
    func addTag(tag:Tag)
    {
        var t = tag
        let pos = _data.count
        //        if category != nil
        //        {
        //            t.category = category!
        //        }
        
        //does tag already exist?
        let index = _data.index(where: {$0.name.lowercased() == t.name.lowercased()})
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
            if !_data[index!].selected
            {
                changeSelection(tag: _data[index!])
            }
        }
    }
    
    func unselectAllTags()
    {
        for i in 0..<_data.count
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
        for i in 0..<_data.count
        {
            let t = data[i]
            if(t.selected)
            {
                res.append(t)
            }
        }
        return res
    }
    
    func changeSelection(tag:Tag)
    {
        if let index = _data.index( where: { (t) -> Bool in
            t.name ==  tag.name
        })
        {
            if !(mustHaveOneSelection && _data[index].selected && selectedTags().count < 2)
            {
                if (!_data[index].selected && multiSelect == false)
                {
                    for i in 0..<_data.count
                    {
                        _data[i].selected = false
                    }
                }
                
                let wasSelected = _data[index].selected
                _data[index].selected = !(_data[index].selected)
                delegate?.didChangeSelection(tag: data[index], atIndex: index)
                delegate?.dataSetChanged(self)

            }
        }
    }

}
