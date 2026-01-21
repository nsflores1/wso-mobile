//
//  PrivacyPolicyText.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

struct PrivacyPolicyTextView: View {
    var body: some View {
        let privacyText = """
                -- Preamble
                
                I, Nathaniel Flores (nsf1@williams.edu), built the WSO Mobile app as a Free app. This SERVICE is provided by me, Nathaniel Flores, at no cost and is intended for use as-is, with no warranty provided or implied.

                This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decides to use my Service.

                If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.

                The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at WSO's website unless otherwise defined in this Privacy Policy.
                
                This Privacy Policy is copyright of myself, Ye Shu, and Aidan Lloyd-Tucker. Copying this privacy policy for use in your own software is strictly forbidden. If you make any copies of this policy, either in full or partially, you MUST credit the authors (us).

                -- Information Collection and Use

                For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to user ID, profile photo. The information that I request will be retained on your device and is not collected by me in any way.

                The app does use third party services that may collect information used to identify you. Please read the WSO Privacy Policy for more information.
                
                This app is not GDPR compliant. WSO does not possess a Trading License within the European Union. However, all WSO data is stored within servers on the Williams College campus, and sometimes on the servers of the aforementioned third party services. Please contact those third party services as enumerated in the WSO Privacy Policy for further information on GDPR compliance with regard to their services, as their policies may be different.
                
                -- Log Data

                I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, the device make and model, and other statistics.
                
                You may optionally share log files with other users and WSO using the Debug Logs feature in WSO Mobile. I highly recommend not doing this unless requested to do so by a WSO developer, as they contain sensitive information that could be used to hack your account. Those log files are cleared on every boot of the app and are stored in an encrypted partition within your iPhone, so there is a very low risk of hackers being able to read them unless you specifically choose to share them. WSO is not responsible for any consequences of your ill-fated decision to share this data with others, or to move it outside the encrypted partition.

                -- Cookies

                Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

                This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

                -- Service Providers

                I may employ third-party companies and individuals due to the following reasons:

                - To facilitate our Service;
                - To provide the Service on our behalf;
                - To perform Service-related services; or
                - To assist us in analyzing how our Service is used.

                I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

                -- Security

                I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.

                -- Links to Other Sites

                This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

                -- Children’s Privacy

                These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.

                -- Changes to This Privacy Policy

                I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.
                
                This policy is effective as of 2026-01-18.
                
                -- Contact Us

                If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at wso-dev+app@wso.williams.edu.
                
                If you would like your data deleted (you may only do this after you graduate/transfer), please contact WSO and OIT for more information. Remember, it is up to you to be careful with your personal data; there is only so much we can do once it has been shared.
                """
        ScrollView {
            Text(privacyText)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ScrollView {
        PrivacyPolicyTextView()
    }
}
