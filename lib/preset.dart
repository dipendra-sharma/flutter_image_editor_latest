import 'main.dart';

/// Preset filters that can be used directly
class PresetFilters {
  /// NoFilter: No filter
  static List<AppColorFilter> none = [];

  /// Clarendon: adds light to lighter areas and dark to darker areas
  static List<AppColorFilter> clarendon = [
    AppColorFilter.brightness(.1),
    AppColorFilter.contrast(.1),
    AppColorFilter.saturation(.15),
  ];

  /// Increase red color gradient
  static List<AppColorFilter> addictiveRed = [
    AppColorFilter.addictiveColor(50, 0, 0),
  ];

  /// Increase blue color gradient
  static List<AppColorFilter> addictiveBlue = [
    AppColorFilter.addictiveColor(0, 0, 50),
  ];

  /// Gingham: Vintage-inspired, taking some color out
  static List<AppColorFilter> gingham = [
    AppColorFilter.sepia(.04),
    AppColorFilter.contrast(-.15),
  ];

  /// Moon: B/W, increase brightness and decrease contrast
  static List<AppColorFilter> moon = [
    AppColorFilter.grayscale(),
    AppColorFilter.contrast(-.04),
    AppColorFilter.brightness(0.1),
  ];

  /// Lark: Brightens and intensifies colours but not red hues
  static List<AppColorFilter> lark = [
    AppColorFilter.brightness(0.08),
    AppColorFilter.grayscale(),
    AppColorFilter.contrast(-.04),
  ];

  /// Reyes: a vintage filter, gives your photos a “dusty” look
  static List<AppColorFilter> reyes = [
    AppColorFilter.sepia(0.4),
    AppColorFilter.brightness(0.13),
    AppColorFilter.contrast(-.05),
  ];

  /// Juno: Brightens colors, and intensifies red and yellow hues
  static List<AppColorFilter> juno = [
    AppColorFilter.rgbScale(1.01, 1.04, 1),
    AppColorFilter.saturation(0.3),
  ];

  /// Slumber: Desaturates the image as well as adds haze for a retro, dreamy look – with an emphasis on blacks and blues
  static List<AppColorFilter> slumber = [
    AppColorFilter.brightness(.1),
    AppColorFilter.saturation(-0.5),
  ];

  /// Crema: Adds a creamy look that both warms and cools the image
  static List<AppColorFilter> crema = [
    AppColorFilter.rgbScale(1.04, 1, 1.02),
    AppColorFilter.saturation(-0.05),
  ];

  /// Ludwig: A slight hint of desaturation that also enhances light
  static List<AppColorFilter> ludwig = [
    AppColorFilter.brightness(.05),
    AppColorFilter.saturation(-0.03),
  ];

  /// Aden: This filter gives a blue/pink natural look
  static List<AppColorFilter> aden = [
    AppColorFilter.colorOverlay(228, 130, 225, 0.13),
    AppColorFilter.saturation(-0.2),
  ];

  /// Perpetua: Adding a pastel look, this filter is ideal for portraits
  static List<AppColorFilter> perpetua = [
    AppColorFilter.rgbScale(1.05, 1.1, 1),
  ];

  /// Amaro: Adds light to an image, with the focus on the centre
  static List<AppColorFilter> amaro = [
    AppColorFilter.saturation(0.3),
    AppColorFilter.brightness(0.15),
  ];

  /// Mayfair: Applies a warm pink tone, subtle vignetting to brighten the photograph center and a thin black border
  static List<AppColorFilter> mayfair = [
    AppColorFilter.colorOverlay(230, 115, 108, 0.05),
    AppColorFilter.saturation(0.15),
  ];

  /// Rise: Adds a "glow" to the image, with softer lighting of the subject
  static List<AppColorFilter> rise = [
    AppColorFilter.colorOverlay(255, 170, 0, 0.1),
    AppColorFilter.brightness(0.09),
    AppColorFilter.saturation(0.1),
  ];

  /// Hudson: Creates an "icy" illusion with heightened shadows, cool tint and dodged center
  static List<AppColorFilter> hudson = [
    AppColorFilter.rgbScale(1, 1, 1.25),
    AppColorFilter.contrast(0.1),
    AppColorFilter.brightness(0.15),
  ];

  /// Valencia: Fades the image by increasing exposure and warming the colors, to give it an antique feel
  static List<AppColorFilter> valencia = [
    AppColorFilter.colorOverlay(255, 225, 80, 0.08),
    AppColorFilter.saturation(0.1),
    AppColorFilter.contrast(0.05),
  ];

  /// X-Pro II: Increases color vibrance with a golden tint, high contrast and slight vignette added to the edges
  static List<AppColorFilter> xProII = [
    AppColorFilter.colorOverlay(255, 255, 0, 0.07),
    AppColorFilter.saturation(0.2),
    AppColorFilter.contrast(0.15),
  ];

  /// Sierra: Gives a faded, softer look
  static List<AppColorFilter> sierra = [
    AppColorFilter.contrast(-0.15),
    AppColorFilter.saturation(0.1),
  ];

  /// Willow: A monochromatic filter with subtle purple tones and a translucent white border
  static List<AppColorFilter> willow = [
    AppColorFilter.grayscale(),
    AppColorFilter.colorOverlay(100, 28, 210, 0.03),
    AppColorFilter.brightness(0.1),
  ];

  /// Lo-Fi: Enriches color and adds strong shadows through the use of saturation and "warming" the temperature
  static List<AppColorFilter> loFi = [
    AppColorFilter.contrast(0.15),
    AppColorFilter.saturation(0.2),
  ];

  /// Inkwell: Direct shift to black and white
  static List<AppColorFilter> inkwell = [
    AppColorFilter.grayscale(),
  ];

  /// Hefe: Hight contrast and saturation, with a similar effect to Lo-Fi but not quite as dramatic
  static List<AppColorFilter> hefe = [
    AppColorFilter.contrast(0.1),
    AppColorFilter.saturation(0.15),
  ];

  /// Nashville: Warms the temperature, lowers contrast and increases exposure to give a light "pink" tint – making it feel "nostalgic"
  static List<AppColorFilter> nashville = [
    AppColorFilter.colorOverlay(220, 115, 188, 0.12),
    AppColorFilter.contrast(-0.05),
  ];

  /// Stinson: washing out the colors ever so slightly
  static List<AppColorFilter> stinson = [
    AppColorFilter.brightness(0.1),
    AppColorFilter.sepia(0.3),
  ];

  /// Vesper: adds a yellow tint that
  static List<AppColorFilter> vesper = [
    AppColorFilter.colorOverlay(255, 225, 0, 0.05),
    AppColorFilter.brightness(0.06),
    AppColorFilter.contrast(0.06),
  ];

  /// Earlybird: Gives an older look with a sepia tint and warm temperature
  static List<AppColorFilter> earlybird = [
    AppColorFilter.colorOverlay(255, 165, 40, 0.2),
    AppColorFilter.saturation(0.15),
  ];

  /// Brannan: Increases contrast and exposure and adds a metallic tint
  static List<AppColorFilter> brannan = [
    AppColorFilter.contrast(0.2),
    AppColorFilter.colorOverlay(140, 10, 185, 0.1),
  ];

  /// Sutro: Burns photo edges, increases highlights and shadows dramatically with a focus on purple and brown colors
  static List<AppColorFilter> sutro = [
    AppColorFilter.brightness(-0.1),
    AppColorFilter.saturation(-0.1),
  ];

  /// Toaster: Ages the image by "burning" the centre and adds a dramatic vignette
  static List<AppColorFilter> toaster = [
    AppColorFilter.sepia(0.1),
    AppColorFilter.colorOverlay(255, 145, 0, 0.2),
  ];

  /// Walden: Increases exposure and adds a yellow tint
  static List<AppColorFilter> walden = [
    AppColorFilter.brightness(0.1),
    AppColorFilter.colorOverlay(255, 255, 0, 0.2),
  ];

  /// 1977: The increased exposure with a red tint gives the photograph a rosy, brighter, faded look.
  static List<AppColorFilter> f1977 = [
    AppColorFilter.colorOverlay(255, 25, 0, 0.15),
    AppColorFilter.brightness(0.1),
  ];

  /// Kelvin: Increases saturation and temperature to give it a radiant "glow"
  static List<AppColorFilter> kelvin = [
    AppColorFilter.colorOverlay(255, 140, 0, 0.1),
    AppColorFilter.rgbScale(1.15, 1.05, 1),
    AppColorFilter.saturation(0.35),
  ];

  /// Maven: darkens images, increases shadows, and adds a slightly yellow tint overal
  static List<AppColorFilter> maven = [
    AppColorFilter.colorOverlay(225, 240, 0, 0.1),
    AppColorFilter.saturation(0.25),
    AppColorFilter.contrast(0.05),
  ];

  /// Ginza: brightens and adds a warm glow
  static List<AppColorFilter> ginza = [
    AppColorFilter.sepia(0.06),
    AppColorFilter.brightness(0.1),
  ];

  /// Skyline: brightens to the image pop
  static List<AppColorFilter> skyline = [
    AppColorFilter.saturation(0.35),
    AppColorFilter.brightness(0.1),
  ];

  /// Dogpatch: increases the contrast, while washing out the lighter colors
  static List<AppColorFilter> dogpatch = [
    AppColorFilter.contrast(0.15),
    AppColorFilter.brightness(0.1),
  ];

  /// Brooklyn
  static List<AppColorFilter> brooklyn = [
    AppColorFilter.colorOverlay(25, 240, 252, 0.05),
    AppColorFilter.sepia(0.3),
  ];

  /// Helena: adds an orange and teal vibe
  static List<AppColorFilter> helena = [
    AppColorFilter.colorOverlay(208, 208, 86, 0.2),
    AppColorFilter.contrast(0.15),
  ];

  /// Ashby: gives images a great golden glow and a subtle vintage feel
  static List<AppColorFilter> ashby = [
    AppColorFilter.colorOverlay(255, 160, 25, 0.1),
    AppColorFilter.brightness(0.1),
  ];

  /// Charmes: a high contrast filter, warming up colors in your image with a red tint
  static List<AppColorFilter> charmes = [
    AppColorFilter.colorOverlay(255, 50, 80, 0.12),
    AppColorFilter.contrast(0.05),
  ];
}

/// List of filter presets
List<List<AppColorFilter>> presetFiltersList = [
  PresetFilters.none,
  PresetFilters.addictiveBlue,
  PresetFilters.addictiveRed,
  PresetFilters.aden,
  PresetFilters.amaro,
  PresetFilters.ashby,
  PresetFilters.brannan,
  PresetFilters.brooklyn,
  PresetFilters.charmes,
  PresetFilters.clarendon,
  PresetFilters.crema,
  PresetFilters.dogpatch,
  PresetFilters.earlybird,
  PresetFilters.f1977,
  PresetFilters.gingham,
  PresetFilters.ginza,
  PresetFilters.hefe,
  PresetFilters.helena,
  PresetFilters.hudson,
  PresetFilters.inkwell,
  PresetFilters.juno,
  PresetFilters.kelvin,
  PresetFilters.lark,
  PresetFilters.loFi,
  PresetFilters.ludwig,
  PresetFilters.maven,
  PresetFilters.mayfair,
  PresetFilters.moon,
  PresetFilters.nashville,
  PresetFilters.perpetua,
  PresetFilters.reyes,
  PresetFilters.rise,
  PresetFilters.sierra,
  PresetFilters.skyline,
  PresetFilters.slumber,
  PresetFilters.stinson,
  PresetFilters.sutro,
  PresetFilters.toaster,
  PresetFilters.valencia,
  PresetFilters.vesper,
  PresetFilters.walden,
  PresetFilters.willow,
  PresetFilters.xProII,
];
