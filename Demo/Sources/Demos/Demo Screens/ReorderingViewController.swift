//
//  ReorderingViewController.swift
//  Demo
//
//  Created by Kyle Van Essen on 11/13/19.
//  Copyright © 2019 Kyle Van Essen. All rights reserved.
//

import UIKit

import ListableUI
import BlueprintUILists
import BlueprintUI
import BlueprintUICommonControls


final class ReorderingViewController : UIViewController
{
    let list = ListView()
    
    override func loadView()
    {
        self.view = self.list
        
        self.list.configure { list in
            
            list.appearance = .demoAppearance
            list.layout = .demoLayout
            
            list += Section("first") { section in
                section.header = HeaderFooter(DemoHeader(title: "First Section"))
                
                section.layouts.table.columns = .init(count: 2, spacing: 15.0)
                
                section += Item(DemoItem(text: "0,0 Row")) { item in
                    
                    item.reordering = Reordering { context in
                        print("Moved: \(context.indexPathsDescription)")
                        
                        try? context.toSection.read(identifier: String.self, content: DemoItem.self) { section in
                            print(section)
                        }
                    }
                }
                
                section += Item(DemoItem(text: "0,1 Row")) { item in
                    
                    item.reordering = Reordering { context in
                        print("Moved: \(context.indexPathsDescription)")
                    }
                }
                
                section += Item(DemoItem(text: "0,2 Row")) { item in
                    
                    item.reordering = Reordering { context in
                        print("Moved: \(context.indexPathsDescription)")
                    }
                }
                
                section += Item(DemoItem(text: "0,3 Row")) { item in
                    
                    item.reordering = Reordering { context in
                        print("Moved: \(context.indexPathsDescription)")
                    }
                }
            }
            
            list += Section("second") { section in
                section.header = HeaderFooter(DemoHeader(title: "Second Section"))
                
                section += Item(DemoItem(text: "1,0  Row")) { item in
                    
                    item.reordering = Reordering { context in
                        print("Moved: \(context.indexPathsDescription)")
                    }
                    
                }
                
                section += Item(DemoItem(text: "1,1 Row")) { item in
                    
                    item.reordering = Reordering { context in
                        print("Moved: \(context.indexPathsDescription)")
                    }
                }
            }
            
            list += Section("second") { section in
                section.header = HeaderFooter(DemoHeader(title: "Third Section"))
                
                section += Item(DemoItem(text: "2,0  Row (Can't Move)")) { item in
                    
                    item.reordering = Reordering(canReorder: { _ in
                        false
                    }, didReorder: { context in
                        print("Moved: \(context.indexPathsDescription)")
                    })
                }
                
                section += Item(DemoItem(text: "2,1 Row (Same Section Only)")) { item in
                    
                    item.reordering = Reordering(sections: .current) { context in
                        print("Moved: \(context.indexPathsDescription)")
                    }
                }
            }
        }
    }
}
