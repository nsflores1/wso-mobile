//
//  SoftwareLicenseTextView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

struct SoftwareLicenseTextView: View {
    var body: some View {
        let licenseText = """
                MIT License
                
                Copyright (c) 2025 Nathaniel Flores (nsf1@williams.edu)
                
                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
                
                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
                
                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                
                Dependencies of this software use other licenses, all of which constitute free-as-in freedom software (excluding libraries included as part of the iOS SDK and Swift language, which are either source-available or proprietary software).
                
                WSO Mobile is a frontend to code written by other developers. Please speak to them as well if you wish to use this code for your own reasons (and if you do, please email me too. I would love to know why you would need to do such a thing); see the WSO GitHub for more information.
                
                In short: credit me for my work or you're a cretin. Other than that, do what you wish as long as it's within the terms of the license.
                """
        ScrollView {
            Text(licenseText)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ScrollView {
        SoftwareLicenseTextView()
    }
}
