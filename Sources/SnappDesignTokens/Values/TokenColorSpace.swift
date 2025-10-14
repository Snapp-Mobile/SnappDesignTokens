//
//  TokenColorSpace.swift
//  SnappDesignTokens
//
//  Created by Alex on 2024-08-23.
//

import Foundation

/// Represents the color space of a color value.
///
/// Color spaces define how color values are interpreted. Different color spaces
/// have different gamuts (ranges of representable colors) and are suited for
/// different purposes.
///
/// For more details, refer to the [Design Tokens Color Spaces documentation](https://tr.designtokens.org/color/#supported-color-spaces).
public enum TokenColorSpace: String, CaseIterable, Sendable, Codable {
    /// The sRGB color space (gamma-corrected).
    ///
    /// sRGB (standard Red Green Blue) is a widely used color space, especially
    /// for web content and digital displays. It has a relatively limited gamut.
    /// Values are gamma-corrected.
    case srgb

    /// The sRGB color space (linear).
    ///
    /// Represents colors in the sRGB gamut but with linear light intensity,
    /// meaning the component values are not gamma-corrected. Useful for color
    /// calculations and blending.
    case srgbLinear = "srgb-linear"

    /// The Display P3 color space.
    ///
    /// Display P3 is a wide-gamut RGB color space developed by Apple Inc.
    /// It offers a larger range of colors than sRGB, particularly in greens and reds.
    /// Values are gamma-corrected. The identifier "display-p3" is used in CSS Color 4.
    case p3 = "display-p3"

    /// The A98 RGB color space (Adobe RGB 1998).
    ///
    /// A98 RGB is a wide-gamut RGB color space developed by Adobe. It offers a
    /// gamut wider than sRGB, particularly in cyans and greens.
    /// Values are gamma-corrected.
    case a98Rgb = "a98-rgb"

    /// The ProPhoto RGB color space.
    ///
    /// ProPhoto RGB is a very wide-gamut RGB color space developed by Kodak.
    /// It can encompass a very large range of colors, including some not visible
    /// to the human eye. Often used in photography workflows.
    /// Values are gamma-corrected.
    case prophotoRgb = "prophoto-rgb"

    /// The Rec. 2020 color space.
    ///
    /// Rec. 2020 is a wide-gamut RGB color space for ultra-high-definition television (UHDTV).
    /// It has a significantly larger gamut than sRGB and P3.
    /// Values are gamma-corrected.
    case rec2020

    /// The CIE XYZ color space (D65 white point assumed if not specified).
    ///
    /// XYZ is a device-independent color space that represents all colors visible
    /// to the average human eye. It's often used as a reference space for conversions.
    /// The spec implies D65 is a common default or that components define it.
    case xyz

    /// The CIE XYZ color space with a D50 white point.
    ///
    /// Used in print and graphic arts workflows.
    case xyzD50 = "xyz-d50"

    /// The CIE XYZ color space with a D65 white point.
    ///
    /// D65 corresponds to average daylight and is commonly used for digital displays and video.
    case xyzD65 = "xyz-d65"

    /// The CIELAB color space (Lab).
    ///
    /// CIELAB (or L*a*b*) is a color space that describes all the colors visible to the human eye.
    /// It uses three coordinates: L* for lightness, a* for the green–red axis, and b* for the blue–yellow axis.
    /// It is designed to be perceptually uniform. Assumes D50 white point as per CSS Color 4.
    case lab

    /// The LCH color space (CIELCH).
    ///
    /// LCH represents colors using Lightness, Chroma, and Hue.
    /// It's derived from the CIELAB color space and is designed to be perceptually uniform.
    /// Assumes D50 white point for Lab conversion as per CSS Color 4.
    case lch

    /// The Oklab color space.
    ///
    /// Oklab is a perceptual color space designed to be a modern alternative to CIELAB.
    /// It aims to improve upon CIELAB in areas like hue linearity.
    case oklab

    /// The Oklch color space.
    ///
    /// Oklch is a perceptual color space similar to LCH but based on the Oklab color space.
    /// It aims for even better perceptual uniformity.
    case oklch

    /// The HSL color space (Hue, Saturation, Lightness).
    ///
    /// HSL is a cylindrical-coordinate representation of points in an sRGB color model.
    /// It's often considered more intuitive for humans for certain color manipulations.
    /// Maps to sRGB.
    case hsl

    /// The HWB color space (Hue, Whiteness, Blackness).
    ///
    /// HWB is another cylindrical-coordinate representation of colors, also mapping to sRGB.
    /// It can be more intuitive for picking colors as it relates to mixing a pure hue
    /// with white and black.
    case hwb
}
