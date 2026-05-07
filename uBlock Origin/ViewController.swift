//
//  ViewController.swift
//  uBlock Origin
//
//  Created by Jasper Swallen on 6/3/19.
//  Copyright © 2019 Jasper Swallen. All rights reserved.
//

import Cocoa
import SafariServices.SFSafariApplication

class ViewController: NSViewController {

    @IBOutlet var appNameLabel: NSTextField!

    private var safariExtensionIdentifier: String? {
        guard let pluginsURL = Bundle.main.builtInPlugInsURL,
              let pluginURLs = try? FileManager.default.contentsOfDirectory(at: pluginsURL, includingPropertiesForKeys: nil)
        else {
            return nil
        }

        for pluginURL in pluginURLs where pluginURL.pathExtension == "appex" {
            guard let extensionBundle = Bundle(url: pluginURL),
                  let extensionDictionary = extensionBundle.infoDictionary?["NSExtension"] as? [String: Any],
                  let extensionPointIdentifier = extensionDictionary["NSExtensionPointIdentifier"] as? String,
                  extensionPointIdentifier == "com.apple.Safari.extension"
            else {
                continue
            }

            return extensionBundle.bundleIdentifier
        }

        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.stringValue = "uBlock Origin"
    }

    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        guard let extensionIdentifier = self.safariExtensionIdentifier else {
            NSLog("Unable to locate Safari extension bundle identifier")
            return
        }

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionIdentifier) { error in
            if let error = error {
                NSLog("Unable to open Safari extension preferences: \(error.localizedDescription)")
            }
        }
    }

}
