//
//  ReorderingActions.swift
//  ListableUI
//
//  Created by Kyle Van Essen on 11/14/19.
//


public final class ReorderingActions
{
    public private(set) var isMoving : Bool
    
    internal weak var item : AnyPresentationItemState?
    internal weak var delegate : ReorderingActionsDelegate?
    
    init()
    {
        self.isMoving = false
    }
    
    public func start() -> Bool
    {
        guard let item = self.item else {
            return false
        }
        
        guard self.isMoving == false else {
            return false
        }
        
        guard let delegate = self.delegate else {
            return false
        }
        
        if delegate.beginReorder(for: item) {
            self.isMoving = true
            
            return true
        } else {
            return false
        }
    }
    
    public func moved(with recognizer : Reordering.GestureRecognizer)
    {
        guard self.isMoving else {
            return
        }
        
        guard let item = self.item else {
            return
        }
        
        self.delegate?.updateReorderTargetPosition(with: recognizer, for: item)
    }
    
    public func end(_ cancelled : Bool)
    {
        guard self.isMoving else {
            return
        }
        
        guard let item = self.item else {
            return
        }
        
        self.isMoving = false
        
        self.delegate?.endReorder(for: item)
    }
}


protocol ReorderingActionsDelegate : AnyObject
{
    func beginReorder(for item : AnyPresentationItemState) -> Bool
    func updateReorderTargetPosition(with recognizer : Reordering.GestureRecognizer, for item : AnyPresentationItemState)
    func endReorder(for item : AnyPresentationItemState)
    func cancelReorder(for item : AnyPresentationItemState)
}
