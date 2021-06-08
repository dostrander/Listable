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
    
    public enum Sections : Equatable {
        
        ///
        case current
        
        ///
        case all
        
        ///
        case specific(Set<AnyIdentifier>)
    }
    
    public struct ReorderInfo {
        
        public var from : IndexPath
        public var fromSection : Section
        
        public var to : IndexPath
        public var toSection : Section
        
        public var indexPathsDescription : String {
            "(\(from) -> \(to))"
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
