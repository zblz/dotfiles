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
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
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
-- end of IMPORTS }}}

-- MAIN {{{

myXmobarPP = xmobarPP {
    ppOutput = putStrLn . wrap "< " " >"
  , ppCurrent = xmobarColor "#ee9a00" "" . (wrap "[" "]" )
  , ppLayout = (\_->"")
  , ppTitle = xmobarColor "#60b48a" "" . shorten 84
  }

myConfig = def {
    terminal = "kitty -1"
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

main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     . withEasySB (statusBarProp "xmobar ~/.xmonad/xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

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
myBorderWidth = 2

--- Ws Stuff
myCurrentWsFgColor = myHighlightedFgColor
myCurrentWsBgColor = myHighlightedBgColor
myVisibleWsFgColor = myBgColor
myVisibleWsBgColor = "#CCDC90"
myHiddenWsFgColor = myHighlightedFgColor
myHiddenEmptyWsFgColor = "#8F8F8F"
myUrgentWsBgColor = "#DCA3A3"
myTitleFgColor = myFgColor

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
      , decoHeight = 28
      }

-- End of COLORS, FONTS, PROMPTS }}}

-- LAYOUT {{{

--- manageHook

myManageHook = (composeAll
    [ stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
    , isFullscreen                       --> doFullFloat
    , isDialog                           --> doCenterFloat
    , manageDocks
    ])

myWorkspaces = ["1","2","3","4"]

myLayout = avoidStruts $ smartBorders $ (normalTiled ||| Grid ||| myTabbed )
    where
      normalTiled = Tall 1 (2/100) (1/2)
      myTabbed = tabbed shrinkText myTheme

-- End of LAYOUT }}}

-- KEYS {{{

myKeys conf@(XConfig {modMask = modm}) =
      M.fromList $ [
         -- Aplicacions
           ((modm,               xK_i), submap internetMap )
         , ((modm,               xK_f), spawn "firefox -P personal" )
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
         -- -- Volum
         , ((0, xF86XK_AudioMute ), spawn "pactl set-sink-mute 0 toggle")
         -- , ((0, xF86XK_AudioMicMute ), spawn "pactl set-source-mute 1 toggle")
         , ((0, xF86XK_AudioLowerVolume ), spawn "pavol -5%")
         , ((0, xF86XK_AudioRaiseVolume ), spawn "pavol +5%")
         -- , ((modm, xK_Page_Up ), spawn  "pavol +5%")
         -- , ((modm, xK_Page_Down ), spawn  "pavol -5%")
         -- screensaver
         , ((0, xK_Pause  ), spawn "xfce4-screensaver-command --lock")
         , ((0, xF86XK_ScreenSaver ), spawn "xfce4-screensaver-command --lock")
         -- Suspend
         , ((0, 0x1008ffa7), spawn "systemctl hibernate")
         , ((modm .|. shiftMask, xK_t), spawn "/home/victor/.local/bin/trayer-xmonad" )
         -- TLP full charge
         , ((0, xF86XK_Launch1 ), spawn "sudo tlp fullcharge")
         -- Varis
         , ((modm .|. shiftMask, xK_space), withFocused $ \w -> hide w >> reveal w >> setFocusX w)
         ]
         ++
         [((m .|. modm, k), windows $ f i)
              | (i, k) <- zip myWorkspaces [xK_1 .. xK_4]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
        gsconfig1 = def { gs_cellheight = 60, gs_cellwidth = 300 }
        internetMap = M.fromList $ [
               ((0, xK_f), spawn "firefox -P personal" )
             , ((0, xK_r), spawn "firefox -P personal --new-window http://cloud.feedly.com" )
             , ((0, xK_g), spawn "firefox -P personal --new-window http://mail.google.com/mail" )
             , ((0, xK_p), spawn "firefox -P personal --private-window" )
             , ((0, xK_w), spawn "firefox -P work" )
             , ((0, xK_y), spawn "skypeforlinux" )
             , ((0, xK_b), spawn "deluge-gtk" )
             , ((0, xK_t), spawn "ferdium" )
             , ((0, xK_c), spawn "chromium" )
         ]

-- End of KEYS }}}
