//
//  CommonColor.swift
//  CommonKit
//
//  Created by Oğuz Öztürk on 14.09.2022.
//

import SwiftUI

public extension Color {
    
    static var coachPlayBackground: Color {
        return Color(UIColor.coachPlayBackground)
    }
    
    static var appRed: Color {
        return Color(UIColor.appRed)
    }
    
    static var redNote: Color {
        return Color(UIColor.redNote)
    }
    
    static var greenNote: Color {
        return Color(UIColor.greenNote)
    }
    
    static var yellowNote: Color {
        return Color(UIColor.yellowNote)
    }
    
    static var blueNote: Color {
        return Color(UIColor.blueNote)
    }
    
    static var appBlack: Color {
        return Color(UIColor.appBlack)
    }
    
    static var tutorialPopupBackground: Color {
        return Color(UIColor.tutorialPopupBackground)
    }
    
    static var voiceSelectionSelectedTextColor: Color {
        return Color(UIColor.voiceSelectionSelectedTextColor)
    }
    
    static var appWhite: Color {
        return Color(UIColor.appWhite)
    }
    
    static var appDarkGray: Color {
        return Color(UIColor.appDarkGray)
    }
    
    static var whiteToYellow: Color {
        return Color(UIColor.whiteToYellow)
    }
    
    static var listBackground: Color {
        return Color(UIColor.listBackground)
    }
    
    static var circleBackground: Color {
        return Color(UIColor.circleBackground)
    }
    
    static var rowBackground: Color {
        return Color(UIColor.rowBackground)
    }
    
    static var searchBarBackground: Color {
        return Color(UIColor.searchBarBackground)
    }
    
    static var searchBarTint: Color {
        return Color(UIColor.searchBarTint)
    }
    
    static var listDelete: Color {
        return Color(UIColor.listDelete)
    }
    
    static var speechHighlight: Color {
        return Color(UIColor.speechHighlight)
    }
    
    static var searchHighlightActive: Color {
        return Color(UIColor.searchHighlightActive)
    }
    
    static var searchHighlightInActive: Color {
        return Color(UIColor.searchHighlightInActive)
    }
    
    static var textHighlight: Color {
        return Color(UIColor.textHighlight)
    }
    
    static var appYellow: Color {
        return Color(UIColor.appYellow)
    }
    
    static var appYellowDarker: Color {
        return Color(UIColor.appYellowDarker)
    }
    
    static var secondayYellow: Color {
        return Color(UIColor.secondaryYellow)
    }
    
    static var grayTextColor: Color {
        return Color(UIColor.grayTextColor)
    }
    
    static var appPurple: Color {
        return Color(UIColor.appPurple)
    }
    
    static var appOrange: Color {
        return Color(UIColor.appOrange)
    }
    
    static var christmasYellow:Color {
        return Color(UIColor.christmasYellow)
    }
    
    static var christmasGreen:Color {
        return Color(UIColor.christmasGreen)
    }
    
    static var christmasRed:Color {
        return Color(UIColor.christmasRed)
    }
    
    static var darkRed:Color {
        return Color(UIColor.darkRed)
    }
    
    static var backgroundDarkGradient:Color {
        return Color(UIColor.backgroundDarkGradient)
    }
    
    static var backgroundLightGradient:Color {
        return Color(UIColor.backgroundLightGradient)
    }
    
    static var backgroundMiddleGradient:Color {
        return Color(UIColor.backgroundMiddleGradient)
    }
    
    static var recentlyPlayProgress:Color {
        return Color(UIColor.recentlyPlayProgress)
    }
}

extension UIColor {
    // MARK: playbar colors
    
    static var playbarBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 0.8823529412, blue: 0.3098039216, alpha: 1)
            }
        }
    }()
    
    static var playbarProgress: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.8823529412, blue: 0.3098039216, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var coachSpeakBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .gray
            } else {
                return #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
            }
        }
    }()
    
    static var playbarProgressBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }()
    
    static var playbarDocumentNameColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var playbarPageText: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.8823529412, blue: 0.3098039216, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var playbarRemainingDuration: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.8823529412, blue: 0.3098039216, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var playbarTotalDuration: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }()
    
    static var playbarPlayPauseIconColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.8823529412, blue: 0.3098039216, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var grayDivider: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            } else {
                return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            }
        }
    }()
    
    static var recentlyPlayProgress: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.9607843137, green: 0.7960784314, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }()
    
    // C4C4C4
}

extension UIColor {
    static var primaryBlackTextColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var referralLinkBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }()
}

extension UIColor {
    static var appPurple: UIColor { #colorLiteral(red: 0.5137254902, green: 0.5647058824, blue: 0.9803921569, alpha: 1) }
    static var appOrange: UIColor { #colorLiteral(red: 1, green: 0.6274509804, blue: 0, alpha: 1) }
    static var redNote: UIColor { #colorLiteral(red: 0.9987948537, green: 0.6511336565, blue: 0.711617887, alpha: 1) }
    static var greenNote: UIColor { #colorLiteral(red: 0.6410389543, green: 0.9373239875, blue: 0.7198362947, alpha: 1) }
    static var yellowNote: UIColor { #colorLiteral(red: 1, green: 0.9227203727, blue: 0.6680979729, alpha: 1) }
    static var blueNote: UIColor { #colorLiteral(red: 0.6873415112, green: 0.8035146594, blue: 1, alpha: 1) }
    static var yellowNoteText :UIColor { #colorLiteral(red: 0.9869169593, green: 0.738994658, blue: 0.01875063404, alpha: 1) }
    static var appRed:UIColor { #colorLiteral(red: 0.9450980392, green: 0, blue: 0, alpha: 1) }
    static var urlHostColor: UIColor { #colorLiteral(red: 0, green: 0.5176470588, blue: 1, alpha: 1) }
    static var saleBlue:UIColor {#colorLiteral(red: 0.5019607843, green: 0.8549019608, blue: 1, alpha: 1) }
    static var saleBrown:UIColor {#colorLiteral(red: 1, green: 0.8705882353, blue: 0.7058823529, alpha: 1) }

    static var coachPlayBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            }
        }
    }()
    
    static var primaryBlack: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        }
    }()
    
    static var textViewerBlack: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }()
    
    static var listeningOpenDocumentBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.007843137255, green: 0.007843137255, blue: 0.007843137255, alpha: 1)
        }
    }()

    
    static var primaryWhite: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }()
    
    static var primaryWhitish: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        }
    }()
    
    static var secondaryGrey: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }
    }()
    
    static var beige: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.9411764706, green: 0.9058823529, blue: 0.8352941176, alpha: 1)
        }
    }()
    
    static var beigePage: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 1, green: 0.9803921569, blue: 0.9411764706, alpha: 1)
        }
    }()
    
    static var beigeSegment: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.8274509804, green: 0.7960784314, blue: 0.7333333333, alpha: 1)
        }
    }()
    
    static var darkRed: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.2588235294, green: 0.007843137255, blue: 0, alpha: 1)
        }
    }()
    
    static var vintageGrey: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.5529411765, green: 0.5254901961, blue: 0.4745098039, alpha: 1)
        }
    }()
    
    static var primaryBlack12opacity: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
    }()
    
    static var grayBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        }
    }()
    
    static var grayTextColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }()
    
    static var sentenceHighlightColorPink: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 1, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
    }()
    
    static var sentenceHighlightColorGray: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0.4823529412, alpha: 1)
        }
    }()
    
    static var speechRateGrayBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            return #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        }
    }()
    
    static var onboardingHighlighColor: UIColor { #colorLiteral(red: 0.9607843137, green: 0.7960784314, blue: 0, alpha: 0.42)  }
    
    static var appYellow: UIColor { #colorLiteral(red: 1, green: 0.8798628449, blue: 0.307000488, alpha: 1)  }
    
    static var appYellowDarker: UIColor { #colorLiteral(red: 0.9607843137, green: 0.7960784314, blue: 0, alpha: 1)  }
    
    static var secondaryYellow: UIColor { #colorLiteral(red: 0.9607843137, green: 0.7960784314, blue: 0, alpha: 1) }
    
    static var appBlack: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var tutorialPopupBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
            } else {
                return #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            }
        }
    }()
    
    static var voiceSelectionSelectedTextColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var appWhite: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }()
    
    static var whiteToYellow: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.9843137255, blue: 0.4745098039, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }()
    
    static var appDarkGray: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2610000074, green: 0.2610000074, blue: 0.2610000074, alpha: 1)
            }
        }
    }()
    
    static var listBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            }
        }
    }()
    
    static var backgroundDarkGradient: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 0.27)
            }
        }
    }()
    
    static var backgroundLightGradient: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            }
        }
    }()
    
    static var backgroundMiddleGradient: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 0.5)
            }
        }
    }()
    
    static var circleBackground: UIColor  = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.1824249625, green: 0.1799308062, blue: 0.1832261384, alpha: 1)
            } else {
                return #colorLiteral(red: 0.8570356369, green: 0.8508483768, blue: 0.8617733121, alpha: 1)
            }
        }
    }()
    
    static var rowBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.109999992, green: 0.109999992, blue: 0.1180000007, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }()
    
    static var searchBarBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.937254902, green: 0.9411764706, blue: 0.9607843137, alpha: 1)
            }
        }
    }()
    
    static var searchBarTint: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.3960364461, green: 0.3961077929, blue: 0.3960270882, alpha: 1)
            } else {
                return #colorLiteral(red: 0.6274509804, green: 0.6392156863, blue: 0.7411764706, alpha: 1)
            }
        }
    }()
    
    static var listDelete: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.9294117647, green: 0.1803921569, blue: 0.4941176471, alpha: 1)
            } else {
                return #colorLiteral(red: 0.9294117647, green: 0.1803921569, blue: 0.4941176471, alpha: 1)
            }
        }
    }()
    
    static var speechHighlight: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 0.5759999752, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var searchHighlightActive: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.1764705882, green: 0.6235294118, blue: 0.4705882353, alpha: 1)
            } else {
                return #colorLiteral(red: 0.1764705882, green: 0.6235294118, blue: 0.4705882353, alpha: 1)
            }
        }
    }()
    
    static var searchHighlightInActive: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.3294117647, green: 0.9843137255, blue: 0.4705882353, alpha: 1)
            } else {
                return #colorLiteral(red: 0.3294117647, green: 0.9843137255, blue: 0.4705882353, alpha: 1)
            }
        }
    }()
    
    static var librivoxBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
            } else {
                return #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            }
        }
    }()
    
    static var textHighlight: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return #colorLiteral(red: 1, green: 0.4901960784, blue: 0.4745098039, alpha: 1)
                } else {
                    return #colorLiteral(red: 1, green: 0.4901960784, blue: 0.4745098039, alpha: 1)
                }
            }
        }()
    
       
    static var christmasYellow: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 0.7568627451, blue: 0.2274509804, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 0.7568627451, blue: 0.2274509804, alpha: 1)
            }
        }
    }()
    
    static var christmasGreen: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.1843137255, green: 0.3294117647, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.1843137255, green: 0.3294117647, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var christmasRed: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.7294117647, green: 0.1450980392, blue: 0.1607843137, alpha: 1)
            } else {
                return #colorLiteral(red: 0.7294117647, green: 0.1450980392, blue: 0.1607843137, alpha: 1)
            }
        }
    }()
}
