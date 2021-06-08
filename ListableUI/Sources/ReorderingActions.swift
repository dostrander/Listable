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
    
    public func beginMoving() -> Bool
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
        
        if delegate.beginInteractiveMovementFor(item: item) {
            self.isMoving = true
            
            return true
        } else {
            return false
        }
    }
    
    public func moved(with recognizer : UIPanGestureRecognizer)
    {
        guard self.isMoving else {
            return
        }
        
        guard let item = self.item else {
            return
        }
        
        self.delegate?.updateInteractiveMovementTargetPosition(with: recognizer, for: item)
    }
    
    public func end()
    {
        guard self.isMoving else {
            return
        }
        
        guard let item = self.item else {
            return
        }
        
        self.isMoving = false
        
        self.delegate?.endInteractiveMovement(item: item)
    }
}


protocol ReorderingActionsDelegate : AnyObject
{
    func beginInteractiveMovementFor(item : AnyPresentationItemState) -> Bool
    func updateInteractiveMovementTargetPosition(with recognizer : UIPanGestureRecognizer, for item : AnyPresentationItemState)
    func endInteractiveMovement(item : AnyPresentationItemState)
    func cancelInteractiveMovement(item : AnyPresentationItemState)
}
