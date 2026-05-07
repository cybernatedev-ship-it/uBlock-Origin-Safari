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
        guard
            let pluginsURL = Bundle.main.builtInPlugInsURL,
            let extensionBundleURL = try? FileManager.default
                .contentsOfDirectory(at: pluginsURL, includingPropertiesForKeys: nil)
                .first(where: { $0.pathExtension == "appex" }),
            let extensionBundle = Bundle(url: extensionBundleURL)
        else {
            return nil
        }

        return extensionBundle.bundleIdentifier
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
