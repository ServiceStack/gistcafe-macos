//
//  AppDelegate.swift
//  gist
//
//  Created by Demis Bellot on 1/6/21.
//

import Foundation
import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

//    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
//        let contentView = ContentView()
//
//        // Create the window and set the content view.
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.isReleasedWhenClosed = false
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func proc(_ file: String, _ arguments: [String]) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = arguments
        task.launchPath = file
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        if !FileManager().fileExists(atPath: "/usr/local/share/dotnet/dotnet") {
            let answer = dialogOKCancel(question: "Install .NET 5 SDK?", text: "")
            if answer {
                _ = shell("open 'https://dotnet.microsoft.com/download/dotnet/5.0'")
                return
            }
        }
        
        let HOME = FileManager.default.homeDirectoryForCurrentUser
        let xPath = HOME.appendingPathComponent(".dotnet").appendingPathComponent("tools").appendingPathComponent("x")
        if !FileManager().fileExists(atPath: xPath.relativePath) {
            let answer = dialogOKCancel(question: "Install gist.cafe's x tool?", text: "")
            if answer {
                _ = shell("/usr/local/share/dotnet/dotnet tool install -g x")
            }
        }

        _ = shell("\(xPath.relativePath) \"\(urls[0])\"")
    }

}

