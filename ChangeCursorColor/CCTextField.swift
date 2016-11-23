//
//  CCTextField.swift
//  ChangeCursorColor
//
//  Created by Michael Dautermann on 11/4/15.
//  Copyright © 2015 Michael Dautermann. All rights reserved.
//

import Cocoa

class CCTextField: NSTextField {

    var myColorCursor : NSCursor?
    
    var mouseIn : Bool = false
    
    var trackingArea : NSTrackingArea?
    
    override func awakeFromNib()
    {
        myColorCursor = NSCursor.init(image: NSImage(named:"heart")!, hotSpot: NSMakePoint(0.0, 0.0))
        
        customizeCaretColor()
    }
    
    override func resetCursorRects() {
        if let colorCursor = myColorCursor {
            self.addCursorRect(self.bounds, cursor: colorCursor)
        }
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        self.mouseIn = true
        
        customizeCaretColor()
    }

    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        self.mouseIn = false
    }

    override func mouseMoved(with theEvent: NSEvent) {
        if self.mouseIn {
            myColorCursor?.set()
        }
        super.mouseMoved(with: theEvent)
    }
    
    func setArea(_ areaToSet: NSTrackingArea?)
    {
        if let formerArea = trackingArea {
            self.removeTrackingArea(formerArea)
        }
        
        if let newArea = areaToSet {
            self.addTrackingArea(newArea)
        }
        trackingArea = areaToSet
    }

    func customizeCaretColor() {
        
        // change the insertion caret to another color
        if let fieldEditor = self.superview?.window?.fieldEditor(true, for: self) as? NSTextView{//self.window?.fieldEditor(true, for: self) as! NSTextView
            fieldEditor.insertionPointColor = NSColor.red
            
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let rect = self.bounds
        let trackingArea = NSTrackingArea.init(rect: rect, options: [NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.activeAlways], owner: self, userInfo: nil)
        
        // keep track of where the mouse is within our text field
        self.setArea(trackingArea)
        
        if let ev = NSApp.currentEvent {
            if NSPointInRect(self.convert(ev.locationInWindow, from: nil), self.bounds) {
                self.mouseIn = true
                myColorCursor?.set()
            }
        }
        
        return true
    }
}
