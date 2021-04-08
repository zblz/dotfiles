-- vim:foldmethod=marker foldmarker={{{,}}} sw=2 sts=2 ts=2 tw=0 et ai nowrap

-- IMPORTS {{{
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS
-- LAYOUT
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
-- HOOKS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import XMonad.Util.NamedScratchpad
-- PROMPT
import XMonad.Prompt
import XMonad.Util.Run(spawnPipe,safeSpawn)
import XMonad.Prompt.Ssh
import XMonad.Actions.Submap
import XMonad.Actions.Search as Search
import XMonad.Actions.GridSelect
import System.IO
import System.Exit
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
-- end of IMPORTS }}}

-- MAIN {{{

conf = def {
    terminal = "urxvt"
  , manageHook = myManageHook <+> manageHook def
  , layoutHook = myLayout
  , workspaces = myWorkspaces
  , modMask = mod4Mask
  , keys = \c -> myKeys c `M.union` keys def c
  , normalBorderColor  = myInactiveBorderColor
  , focusedBorderColor = myActiveBorderColor
  , borderWidth = myBorderWidth
  , focusFollowsMouse = True
  }

myPP = xmobarPP {
    ppOutput = putStrLn . wrap "< " " >"
  , ppCurrent = xmobarColor "#ee9a00" "" . (wrap "[" "]" )
  , ppHidden = hideScratchpad
  , ppLayout = (\_->"")
  , ppTitle = xmobarColor "#60b48a" "" . shorten 300
  }
    where
      hideScratchpad ws = if ws == "NSP" then "" else  ws

main = do
  spawn "xmobar /home/vzabalza/.xmonad/xmobar"
  xmonad $ ewmhFullscreen $ ewmh $ docks $ conf {
    logHook = dynamicLogString myPP >>= xmonadPropLog
  }

-- end of MAIN }}}

-- COLORS, FONTS, PROMPTS {{{

--- Main Colours
myFgColor = "#DCDCCC"
myBgColor = "#3f3f3f"
myHighlightedFgColor = myFgColor
myHighlightedBgColor = "#7F9F7F"

--- Borders
myActiveBorderColor = myCurrentWsBgColor
myInactiveBorderColor = "#262626"
myBorderWidth = 1

--- Ws Stuff
myCurrentWsFgColor = myHighlightedFgColor
myCurrentWsBgColor = myHighlightedBgColor
myVisibleWsFgColor = myBgColor
myVisibleWsBgColor = "#CCDC90"
myHiddenWsFgColor = myHighlightedFgColor
myHiddenEmptyWsFgColor = "#8F8F8F"
myUrgentWsBgColor = "#DCA3A3"
myTitleFgColor = myFgColor

-- <font>
-- barFont = "-misc-fixed-medium-r-semicondensed-*-12-110-75-75-c-60-koi8-r"
myFont = "xft:DejaVu Sans:size=9"

myTabFont = "xft:DejaVu Sans:size=8"
myTheme = def
      { activeColor = myHighlightedBgColor
      , activeTextColor = myFgColor
      , activeBorderColor = myActiveBorderColor
      , inactiveColor = myBgColor
      , inactiveTextColor = myHighlightedBgColor
      , inactiveBorderColor = myInactiveBorderColor
      , fontName = myTabFont
      , decoHeight = 14
      }

-- End of COLORS, FONTS, PROMPTS }}}

-- LAYOUT {{{

-- Scratchpads

scratchpads=[
       NS "term" "urxvt -name term " (resource =? "term") termFloating
     , NS "ncmpcpp" "urxvt -name ncmpcpp -e ncmpcpp" (resource =? "ncmpcpp") termFloating
     , NS "ipython" "urxvt -name ipython-scratch -e ipython3 --matplotlib=qt" (resource =? "ipython-scratch") termFloating
     , NS "pavucontrol" "pavucontrol" (resource =? "pavucontrol") paFloating
     , NS "htop" "urxvt -name htop -e htop" (title =? "htop") htFloating
        ] where
            termFloating = (customFloating $ W.RationalRect 0.1 0.1 0.8 0.8)
            paFloating = (customFloating $ W.RationalRect 0.2 0.2 0.6 0.6)
            htFloating = (customFloating $ W.RationalRect 0.2 0.05 0.6 0.9)

--- manageHook

myManageHook = (composeAll
    [ stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
    , isFullscreen                       --> doFullFloat
    , isDialog                           --> doCenterFloat
    , manageDocks
    ]) <+> namedScratchpadManageHook scratchpads

--- Urgency
myUrgencyHintFgColor = "red"
myUrgencyHintBgColor = "blue"

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

gsconfig1 = def { gs_cellheight = 60, gs_cellwidth = 300 }

myLayout = avoidStruts $ smartBorders $ (normalTiled ||| Grid ||| myTabbed )
    where
      normalTiled = Tall 1 (2/100) (1/2)
      fitTiled = Tall 1 (2/100) (1/4)
      extraFitTiled = Tall 1 (2/100) (1/5)
      myTabbed = tabbed shrinkText myTheme
      ratio = toRational (2/(1+sqrt(5)::Double))

-- End of LAYOUT }}}

-- KEYS {{{

myKeys conf@(XConfig {modMask = modm}) =
      M.fromList $
         -- Aplicacions
         [ ((modm,               xK_i), submap internetMap )
         , ((modm,               xK_y), spawn "urxvt -e ipython3 --matplotlib=qt" )
         -- Full Screen
         , ((modm,               xK_b), sendMessage ToggleStruts )
         -- Navegar entre finestres i WS
         , ((modm,               xK_Left ), prevWS )
         , ((modm,               xK_Right), nextWS )
         , ((modm .|. shiftMask, xK_Left ), shiftToPrev )
         , ((modm .|. shiftMask, xK_Right), shiftToNext )
         , ((modm,               xK_Down ), windows W.focusDown)
         , ((modm,               xK_Up   ), windows W.focusUp)
         , ((modm,               xK_Tab  ), toggleWS)
         -- GridSelect
         , ((modm, xK_g), goToSelected gsconfig1)
         -- Volum
         , ((0, xF86XK_AudioMute ), spawn "pactl set-sink-mute 0 toggle")
         , ((0, xF86XK_AudioLowerVolume ), spawn "pavol -5%")
         , ((0, xF86XK_AudioRaiseVolume ), spawn "pavol +5%")
         , ((modm, xK_Page_Up ), spawn  "pavol +5%")
         , ((modm, xK_Page_Down ), spawn  "pavol -5%")
         -- Scratchpads
         , ((modm .|. shiftMask, xK_h   ), namedScratchpadAction scratchpads "htop")
         , ((modm .|. shiftMask, xK_t   ), namedScratchpadAction scratchpads "term")
         , ((modm .|. shiftMask, xK_a   ), namedScratchpadAction scratchpads "pavucontrol")
         , ((modm .|. shiftMask, xK_y   ), namedScratchpadAction scratchpads "ipython")
         , ((modm .|. shiftMask, xK_m   ), namedScratchpadAction scratchpads "ncmpcpp")
         -- toggle display outputs
         , ((0, xF86XK_Display ), spawn "/home/vzabalza/.local/bin/thinkpad-fn-f7 toggle")
         , ((modm, xK_F7 ), spawn "/home/vzabalza/.local/bin/thinkpad-fn-f7 toggle")
         -- Xscreensaver
         , ((0, xK_Pause  ), spawn "xscreensaver-command -lock")
         , ((0, xF86XK_ScreenSaver ), spawn "xscreensaver-command -lock")
         -- Suspend
         , ((0, 0x1008ffa7), spawn "systemctl hibernate")
         , ((modm .|. shiftMask, xK_t), spawn "/home/vzabalza/.local/bin/trayer-xmonad" )
         -- TLP full charge
         , ((0, xF86XK_Launch1 ), spawn "sudo tlp fullcharge")
         -- Varis
         , ((modm .|. shiftMask, xK_space), withFocused $ \w -> hide w >> reveal w >> setFocusX w)
         ]
         ++
         [((m .|. modm, k), windows $ f i)
              | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    {-where-}
        {-shutdownHook = spawn "pkill -TERM -P `pgrep -o xmonad`"-}

internetMap = M.fromList $
               [ ((0, xK_f), spawn "firefox" )
               , ((0, xK_r), spawn "firefox --new-window http://cloud.feedly.com" )
               , ((0, xK_g), spawn "firefox --new-window http://mail.google.com/mail" )
               , ((0, xK_y), spawn "skypeforlinux" )
               , ((0, xK_b), spawn "deluge-gtk" )
               , ((0, xK_t), spawn "rambox" )
               , ((0, xK_c), spawn "google-chrome" )
               ]

-- End of KEYS }}}
