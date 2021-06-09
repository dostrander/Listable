//
//  Reordering.swift
//  ListableUI
//
//  Created by Kyle Van Essen on 12/14/20.
//

import Foundation


///
///
///
public struct Reordering
{
    // MARK: Controlling Reordering Behavior
    
    ///
    public var sections : Sections
    
    ///
    public var canReorder : CanReorder?
    
    ///
    public typealias CanReorder = (ReorderInfo) -> Bool
    
    // MARK: Responding To Reordering
    
    ///
    public var didReorder : DidReorder
    
    ///
    public typealias DidReorder = (ReorderInfo) -> ()
    
    // MARK: Initialization
    
    ///
    public init(
        sections : Sections = .all,
        canReorder : CanReorder? = nil,
        didReorder : @escaping DidReorder
    ) {
        self.sections = sections
        self.canReorder = canReorder
        self.didReorder = didReorder
    }
}


extension Reordering {
    
    ///
    ///
    ///
    public enum Sections : Equatable {
        
        ///
        case current
        
        ///
        case all
        
        ///
        case specific(Set<AnyIdentifier>)
    }
    
    ///
    ///
    ///
    public struct ReorderInfo {
        
        // MARK: Public Properties
        
        public var from : IndexPath
        public var fromSection : Section
        public var fromIdentifiers : [AnyIdentifier]
        
        public var to : IndexPath
        public var toSection : Section
        public var toIdentifiers : [AnyIdentifier]
        
        // MARK: Initialization
        
        public init(
            from: IndexPath,
            fromSection: Section,
            to: IndexPath,
            toSection: Section
        ) {
            self.from = from
            self.fromSection = fromSection
            self.fromIdentifiers = fromSection.items.map(\.identifier)
            self.to = to
            self.toSection = toSection
            self.toIdentifiers = toSection.items.map(\.identifier)
        }
        
        // MARK: Reading Values
        
        public var indexPathsDescription : String {
            "(\(from) -> \(to))"
        }
    }
}


extension Reordering {
    
    ///
    ///
    ///
    public final class GestureRecognizer : UIPanGestureRecognizer
    {
        public typealias OnStart = () -> Bool
        public var onStart : OnStart? = nil
        
        public typealias OnMove = (GestureRecognizer) -> ()
        public var onMove : OnMove? = nil
        
        public typealias OnEnd = (Bool) -> ()
        public var onEnd : OnEnd? = nil
        
        public override init(target: Any?, action: Selector?)
        {
            super.init(target: target, action: action)
            
            self.addTarget(self, action: #selector(updated))
            
            self.minimumNumberOfTouches = 1
            self.maximumNumberOfTouches = 1
        }
        
        public func apply(actions : ReorderingActions) {
            
            self.onStart = actions.start
            self.onMove = actions.moved(with:)
            self.onEnd = actions.end(_:)
        }
        
        public func reorderPosition(in collectionView : UIView) -> CGPoint? {
            
            guard let initial = self.initialCenter else {
                return nil
            }
            
            let translation = self.translation(in: collectionView)
            
            return CGPoint(
                x: initial.x + translation.x,
                y: initial.y + translation.y
            )
        }
        
        private var initialCenter : CGPoint? = nil
                
        @objc private func updated()
        {
            switch self.state {
            case .possible: break
            case .began:
                let canStart = self.onStart?()
                
                let center = self.view?.firstSuperview(ofType: UICollectionViewCell.self)?.center
                
                if let center = center, canStart == true {
                    self.initialCenter = center
                } else {
                    self.state = .cancelled
                }
            case .changed:
                self.onMove?(self)

            case .ended:
                self.onEnd?(true)
                self.initialCenter = nil
                
            case .cancelled, .failed:
                self.onEnd?(false)
                self.initialCenter = nil
                
            @unknown default: listableFatal()
            }
        }
    }
}


extension Reordering.Sections {
    
    func canMove(from : PresentationState.SectionState, to : PresentationState.SectionState) -> Bool {
        
        switch self {
        case .current:
            return from === to
            
        case .all:
            return true
            
        case .specific(let IDs):
            return IDs.contains(to.model.identifier)
        }
    }
}


extension Reordering {
    
    func destination(
        from : IndexPath,
        fromSection : PresentationState.SectionState,
        to : IndexPath,
        toSection : PresentationState.SectionState
    ) -> IndexPath
    {
        let info = ReorderInfo(
            from: from,
            fromSection: fromSection.model,
            to: to,
            toSection: toSection.model
        )
        
        if let canReorder = self.canReorder, canReorder(info) == false {
            return from
        }
        
        if self.sections.canMove(from: fromSection, to: toSection) == false {
            return from
        }
        
        return to
    }
}
