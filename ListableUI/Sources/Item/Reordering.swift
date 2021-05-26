//
//  Reordering.swift
//  ListableUI
//
//  Created by Kyle Van Essen on 12/14/20.
//

import Foundation


public struct Reordering
{
    public var sections : Sections
    
    public typealias CanReorder = (ReorderInfo) -> Bool
    public var canReorder : CanReorder?
    
    public typealias DidReorder = (ReorderInfo) -> ()
    public var didReorder : DidReorder
    
    public init(
        sections : Sections = .current,
        canReorder : CanReorder? = nil,
        didReorder : @escaping DidReorder
    ) {
        self.sections = sections
        self.canReorder = canReorder
        self.didReorder = didReorder
    }
    
    public enum Sections : Equatable
    {
        case current
        case all
        case specific(Set<AnyIdentifier>)
        
        func canMove(from : AnyIdentifier, to : AnyIdentifier) -> Bool {
            
            switch self {
            case .current:
                return from == to
                
            case .all:
                return true
                
            case .specific(let IDs):
                return IDs.contains(to)
            }
        }
    }
    
    public struct ReorderInfo
    {
        public var from : IndexPath
        public var fromSection : Section
        
        public var to : IndexPath
        public var toSection : Section
    }
}


extension Reordering {
    
    func destination(
        from : IndexPath,
        fromSection : Section,
        to : IndexPath,
        toSection : Section
    ) -> IndexPath
    {
        let info = ReorderInfo(
            from: from,
            fromSection: fromSection,
            to: to,
            toSection: toSection
        )
        
        if
            let canReorder = self.canReorder,
            canReorder(info) == false
        {
            return from
        }
        
        if self.sections.canMove(
            from: fromSection.identifier,
            to: toSection.identifier
        ) == false
        {
            return from
        }
        
        return to
    }
}
