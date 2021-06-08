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
                
                section += Item(DemoItem(text: "0,0 Row")) { item in
                    
                    item.reordering = Reordering { result in
                        print("Moved: \(result.indexPathsDescription)")
                    }
                }
                
                section += Item(DemoItem(text: "0,1 Row")) { item in
                    
                    item.reordering = Reordering { result in
                        print("Moved: \(result.indexPathsDescription)")
                    }
                }
                
                section += Item(DemoItem(text: "0,2 Row")) { item in
                    
                    item.reordering = Reordering { result in
                        print("Moved: \(result.indexPathsDescription)")
                    }
                }
            }
            
            list += Section("second") { section in
                section.header = HeaderFooter(DemoHeader(title: "Second Section"))
                
                section += Item(DemoItem(text: "1,0  Row")) { item in
                    
                    item.reordering = Reordering { result in
                        print("Moved: \(result.indexPathsDescription)")
                    }
                    
                }
                
                section += Item(DemoItem(text: "1,1 Row")) { item in
                    
                    item.reordering = Reordering { result in
                        print("Moved: \(result.indexPathsDescription)")
                    }
                }
            }
        }
    }
}
