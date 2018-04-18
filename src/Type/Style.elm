module Type.Style exposing (..)

import Element.Attributes exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Background as Background
import Style.Shadow as Shadow
import Style.Border as Border
import Color exposing (rgb)


primaryColor : Color.Color
primaryColor = rgb 232 28 79

primaryDarker : Color.Color
primaryDarker = rgb 186 24 64

primaryDarkest : Color.Color
primaryDarkest = rgb 140 16 47

primaryLighter : Color.Color
primaryLighter = rgb 255 43 96

primaryLightest : Color.Color
primaryLightest = rgb 255 81 124

white : Color.Color
white = rgb 254 254 254

grey : Color.Color
grey = rgb 179 179 179 -- 233 235 238 -- #e9ebee

nearlyWhite : Color.Color
nearlyWhite = rgb 242 242 242 -- #f2f2f2


type StyleClass
  = NoStyle
  | AppStyle
  | NavBarStyle
  | HeaderStyle
  | HomeStyle
  | HomeHeaderLeftStyle
  | HomeHeaderRightStyle
  | HomeCTAStyle
  | TopFooterStyle
  | BottomFooterStyle

  -- Text
  | H1Style
  | H2Style
  | H3Style
  | H4Style
  | FadedTextStyle
  | LinkStyle
  | ErrorText

  | AuthorStyle
  | PillStyle

  -- Login
  | LoginPageStyle
  | LoginBoxStyle
  | LoginFieldStyle
  | LoginButtonStyle
  | TopbarLoginButton
  | TopbarLoginDropdown


sheet : StyleSheet StyleClass variation
sheet =
  Style.styleSheet
  [ style NoStyle []
  , style AppStyle
    [ Font.typeface [Font.font "Helvetica", Font.font "Arial" ]
    ]
  , style HeaderStyle
    [ Font.size 30
    ]
  , style NavBarStyle
    [ Color.background primaryColor
    , Color.text nearlyWhite
    ]
  , style HomeHeaderLeftStyle
    [ Background.coverImage "../../resources/story.jpg"
    , Color.text nearlyWhite
    ]
  , style HomeHeaderRightStyle
    [ Background.coverImage "../../resources/shot.jpg"
    , Color.text nearlyWhite
    ]
  , style HomeCTAStyle
    [ Color.background primaryColor
    , Color.text nearlyWhite
    , Shadow.deep
    , hover
      [ Shadow.simple ]
    ]
  , style TopFooterStyle
    [ Color.background (rgb 64 64 64)
    , Color.text nearlyWhite
    ]
  , style BottomFooterStyle
    [ Color.background (rgb 48 48 48)
    , Color.text nearlyWhite
    ]

  , style H1Style [Font.size 36]
  , style H2Style [Font.size 30]
  , style H3Style [Font.size 24]
  , style H4Style [Font.size 18]
  , style FadedTextStyle
    [ Color.text grey ]
  , style LinkStyle
    [ Color.text primaryColor ]
  , style ErrorText
    [ Color.text Color.red ]

  , style AuthorStyle
    [Font.italic]
  , style PillStyle [Border.all 2, Border.rounded 50, Border.solid]
  , style LoginBoxStyle
    [ Shadow.deep
    , Color.background white
    ]
  , style LoginPageStyle
    [ Color.background nearlyWhite
    ]
  , style LoginFieldStyle
    [ Color.background nearlyWhite
    ]
  , style LoginButtonStyle
    [ Color.background primaryColor
    , Color.text nearlyWhite
    , Shadow.deep
    , hover
      [ Shadow.simple ]
    ]
  , style TopbarLoginButton
    [ Color.background primaryLighter
    , Color.border primaryDarkest
    , Border.all 2
    , hover
      [ Color.background primaryDarker
      ]
    , focus
      [ Color.background primaryDarkest
      ]
    ]
  , style TopbarLoginDropdown
    [ Color.background white
    , Color.text grey
    ]
  ]


maxWidth : Length
maxWidth = px 1000
