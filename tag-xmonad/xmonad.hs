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
import XMonad.Prompt.Window (windowPromptBring,windowPromptGoto)
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

conf = defaultConfig
             { terminal = "urxvt"
             , handleEventHook = fullscreenEventHook
             , manageHook = myManageHook <+> manageHook defaultConfig
             , layoutHook = myLayout
             , workspaces = myWorkspaces
             , modMask = mod4Mask
             , keys = \c -> myKeys c `M.union` keys defaultConfig c
             , normalBorderColor  = myInactiveBorderColor
             , focusedBorderColor = myActiveBorderColor
             , borderWidth = myBorderWidth
             , focusFollowsMouse = True
             }


main = do
  xmproc <- spawnPipe "xmobar /home/vzabalza/.xmonad/xmobar"
  xmonad $ ewmh conf
            { 
            logHook = myLogHook xmproc
            }
-- end of MAIN }}}

-- LogHook
myLogHook h =  dynamicLogWithPP xmobarPP
      { 
            ppOutput = hPutStrLn h . wrap "< "      " >"
          , ppCurrent = xmobarColor "#ee9a00" "" . (wrap "["        "]" ) 
          , ppVisible = (wrap "("        ")" ) 
          , ppHidden = hideScratchpad
          {-, ppHiddenNoWindows =  (take 1) . hideScratchpad-}
          , ppLayout = (\_->"")
          {-, ppUrgent = (\_->"")-}
          {-, ppSep = " >-< "-}
          , ppTitle = xmobarColor "#60b48a" "" .           shorten 300
      }
      where 
        hideScratchpad ws = if ws == "NSP" then "" else  ws

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

-- <prompts>
myXPConfig :: XPConfig
myXPConfig =
    defaultXPConfig { font                  = myFont
                    , bgColor               = myBgColor
                    , fgColor               = myFgColor
                    , bgHLight              = myHighlightedBgColor
                    , fgHLight              = myHighlightedFgColor
                    , borderColor           = myActiveBorderColor
                    , promptBorderWidth     = 1
                    , height                = 18
                    , position              = Bottom
                    , historySize           = 100
                    , historyFilter         = deleteConsecutive
                    }

myTabFont = "xft:DejaVu Sans:size=8"
myTheme = defaultTheme 
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


-- Scratchpads

scratchpads=[
       NS "term" "urxvt -name term " (resource =? "term") termFloating
     , NS "ncmpcpp" "urxvt -name ncmpcpp -e ncmpcpp" (resource =? "ncmpcpp") termFloating 
     , NS "ipython" "urxvt -name ipython-scratch -e ipython3 --matplotlib=qt4" (resource =? "ipython-scratch") termFloating
     , NS "pavucontrol" "pavucontrol" (resource =? "pavucontrol") paFloating
     , NS "htop" "urxvt -name htop -e htop" (title =? "htop") htFloating
        ] where 
            termFloating = (customFloating $ W.RationalRect 0.1 0.1 0.8 0.8)
            paFloating = (customFloating $ W.RationalRect 0.2 0.2 0.6 0.6)
            htFloating = (customFloating $ W.RationalRect 0.2 0.05 0.6 0.9)
 
--- manageHook

myManageHook = (composeAll
    [ className =? "com-sun-javaws-Main" --> doFloat
    , resource =? "sun-awt-X11-XFramePeer" --> doFloat
    , className =? "ROOT" --> doFloat
    , className =? "SeeVoghRN" --> doFloat
    , resource =? "fv*" --> doFloat
    , stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
    , isFullscreen                       --> doFullFloat
    , isDialog                           --> doCenterFloat
    , manageDocks
    ]) <+> namedScratchpadManageHook scratchpads
 
--- Urgency
myUrgencyHintFgColor = "red"
myUrgencyHintBgColor = "blue"

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

gsconfig1 = defaultGSConfig { gs_cellheight = 60, gs_cellwidth = 300 }

myKeys conf@(XConfig {modMask = modm}) = 
      M.fromList $
         -- Aplicacions
         [ 
           ((modm .|. shiftMask, xK_x), spawn "urxvt -e vim /home/vzabalza/.xmonad/xmonad.hs" )
         , ((modm,               xK_i), submap internetMap )
         , ((modm .|.controlMask,xK_c), spawn "/home/vzabalza/bin/conky-init stop" ) 
         , ((modm,               xK_c), spawn "/home/vzabalza/bin/conky-init start" ) 
         , ((modm,               xK_y), spawn "urxvt -e ipython3 --matplotlib=qt4" ) 
         , ((modm,               xK_k), spawn "kodi" ) 
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
         , ((modm,               xK_F1   ), windowPromptGoto myXPConfig)
         , ((modm,               xK_F2   ), windowPromptBring myXPConfig)
         -- GridSelect
         , ((modm, xK_g), goToSelected gsconfig1)
         {-, ((modm, xK_comma), toggleWS)-}
         {-, ((modm, xK_f), spawnSelected defaultGSConfig ["urxvt","zathura","libreoffice","gimp"])-}
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
         , ((0, xF86XK_Display ), spawn "/home/vzabalza/bin/thinkpad-fn-f7 toggle")
         , ((modm, xK_F7 ), spawn "/home/vzabalza/bin/thinkpad-fn-f7 toggle")
         -- Xscreensaver
         , ((0, xK_Pause  ), spawn "xscreensaver-command -lock")
         , ((0, xF86XK_ScreenSaver ), spawn "xscreensaver-command -lock")
         -- Suspend
         , ((0, 0x1008ffa7), spawn "systemctl hibernate")
         , ((modm .|. shiftMask, xK_t), spawn "/home/vzabalza/bin/trayer-xmonad" )
         -- TLP full charge
         , ((0, xF86XK_Launch1 ), spawn "sudo tlp fullcharge")
         -- Varis
         , ((modm .|. shiftMask, xK_space), withFocused $ \w -> hide w >> reveal w >> setFocusX w) 
         -- %! force the window to redraw itself
         
         -- Cerques
         , ((modm,               xK_s), submap $ searchMap $ Search.promptSearch myXPConfig)
         , ((modm .|. shiftMask, xK_s), submap $ searchMap $ Search.selectSearch)
         ]
         ++
         [((m .|. modm, k), windows $ f i) 
              | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    {-where-}
        {-shutdownHook = spawn "pkill -TERM -P `pgrep -o xmonad`"-}

internetMap = M.fromList $
               [ 
                 ((0, xK_f), spawn "google-chrome --profile-directory='Default'" )
               , ((0, xK_r), spawn "google-chrome --profile-directory='Default' --new-window http://cloud.feedly.com" )
               , ((0, xK_g), spawn "google-chrome --profile-directory='Default' --new-window http://mail.google.com/mail" )
               , ((0, xK_d), spawn "google-chrome --profile-directory='Default' --app=https://www.todoist.com" )
               , ((0, xK_t), spawn "/home/vzabalza/bin/Telegram-dist/Telegram" )
               , ((0, xK_a), spawn "google-chrome --profile-directory='Profile 1'" )
               {-, ((0, xK_w), spawn "google-chrome --app=https://web.whatsapp.com" )-}
               , ((0, xK_y), spawn "skypeforlinux" )
               , ((0, xK_b), spawn "deluge-gtk" )
               {-, ((0, xK_s), sshPrompt myXPConfig ) -}
               , ((0, xK_s), spawn "slack" ) 
               ]

myNasaADS = searchEngine "ads" "http://adsabs.harvard.edu/cgi-bin/basic_connect?qsearch="

searchMap method = M.fromList $
                   [ ((0, xK_g),  method Search.google )
                   , ((0, xK_w),  method Search.wikipedia )
                   , ((0, xK_a),  method myNasaADS )
                   , ((0, xK_i),  method Search.imdb ) 
                   , ((0, xK_m),  method Search.maps ) 
                   , ((0, xK_d),  method Search.mathworld )
                   , ((0, xK_y),  method Search.youtube ) ]

myLayout = avoidStruts $ smartBorders $ (normalTiled ||| Grid ||| myTabbed )
    where
      normalTiled = Tall 1 (2/100) (1/2)
      fitTiled = Tall 1 (2/100) (1/4)
      extraFitTiled = Tall 1 (2/100) (1/5)
      myTabbed = tabbed shrinkText myTheme
      ratio = toRational (2/(1+sqrt(5)::Double))
