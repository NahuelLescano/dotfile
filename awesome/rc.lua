---@diagnostic disable: undefined-global, lowercase-global
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- Use correct status icon size
awesome.set_preferred_icon_size(33)

-- This is used later as the default terminal and editor to run.
local terminal = "ghostty"
local browser = "app.zen_browser.zen"
local rofi = "rofi -modi drun -show drun -display-drun 'Run:' "

local home = os.getenv("HOME")

-- dmscripts location.
local dmbookman = home .. "/Documentos/repos/dmscript/dm-bookman"
local dmconfedit = home .. "/Documentos/repos/dmscript/dm-confedit"
local dmdocuments = home .. "/Documentos/repos/dmscript/dm-documents"
local dmkill = home .. "/Documentos/repos/dmscript/dm-kill"
local dmlogout = home .. "/Documentos/repos/dmscript/dm-logout"
local dmmaim = home .. "/Documentos/repos/dmscript/dm-maim"
local dmman = home .. "/Documentos/repos/dmscript/dm-man"
local dmradio = home .. "/Documentos/repos/dmscript/dm-radio"
local dmwebsearch = home .. "/Documentos/repos/dmscript/dm-websearch"
local dmwiki = home .. "/Documentos/repos/dmscript/dm-wiki"
local dmyoutube = home .. "/Documentos/repos/dmscript/dm-youtube"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
-- local alt = "Mod1"
local ctrlkey = "Control"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
}
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- attach it as popup to your text clock widget:
--calendar({}):attach(mytextclock)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Create systray
    s.systray = wibox.widget.systray()

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {       -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            s.systray,
            mytextclock,
            s.mylayoutbox,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
    awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, ctrlkey }, "j", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),

    awful.key({ modkey, ctrlkey }, "k", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, ctrlkey }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),

    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, ctrlkey }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, ctrlkey }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),

    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),

    awful.key({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    -- Costum key bindings
    -- Zen browser
    awful.key({ modkey }, "b", function()
        awful.util.spawn(browser)
    end, { description = "run zen browser", group = "applications" }),

    -- Pcmanfm
    awful.key({ modkey }, "p", function()
        awful.util.spawn("pcmanfm")
    end, { description = "run pcmanfm file manager", group = "applications" }),

    -- Rofi
    awful.key({ modkey, "Shift" }, "Return", function()
        awful.util.spawn(rofi)
    end, { description = "run rofi", group = "applications" }),

    -- dmscripts
    -- dm-radio
    awful.key({ modkey, "Shift" }, "r", function()
        awful.util.spawn(dmradio)
    end, { description = "run dm-radio", group = "dmscripts" }),

    -- dm-wiki
    awful.key({ modkey, "Shift" }, "w", function()
        awful.util.spawn(dmwiki)
    end, { description = "run dm-wiki", group = "dmscripts" }),

    -- dm-bookman
    awful.key({ modkey, "Shift" }, "b", function()
        awful.util.spawn(dmbookman)
    end, { description = "run dm-bookman", group = "dmscripts" }),

    -- dm-confedit
    awful.key({ modkey, "Shift" }, "o", function()
        awful.util.spawn(dmconfedit)
    end, { description = "run dm-confedit", group = "dmscripts" }),

    -- dm-documents
    awful.key({ modkey, "Shift" }, "d", function()
        awful.util.spawn(dmdocuments)
    end, { description = "run dm-documents", group = "dmscripts" }),

    -- dm-kill
    awful.key({ modkey, ctrlkey }, "k", function()
        awful.util.spawn(dmkill)
    end, { description = "run dm-kill", group = "dmscripts" }),

    -- dm-logout
    awful.key({ modkey, "Shift" }, "l", function()
        awful.util.spawn(dmlogout)
    end, { description = "run dm-logout", group = "dmscripts" }),

    -- dm-man
    awful.key({ modkey, "Shift" }, "m", function()
        awful.util.spawn(dmman)
    end, { description = "run dm-man", group = "dmscripts" }),

    -- dm-websearch
    awful.key({ modkey, "Shift" }, "s", function()
        awful.util.spawn(dmwebsearch)
    end, { description = "run dm-websearch", group = "dmscripts" }),

    -- dm-maim
    awful.key({ modkey, "Shift" }, "n", function()
        awful.util.spawn(dmmaim)
    end, { description = "run dm-maim", group = "dmscripts" }),

    -- dm-youtube
    awful.key({ modkey, "Shift" }, "y", function()
        awful.util.spawn(dmyoutube)
    end, { description = "run dm-youtube", group = "dmscripts" })
)

local clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),

    awful.key({ modkey, "Shift" }, "c", function(c)
        c:kill()
    end, { description = "close", group = "client" }),

    awful.key(
        { modkey, ctrlkey },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),

    awful.key({ modkey, ctrlkey }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),

    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),

    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),

    -- Resize windows
    awful.key({ modkey, ctrlkey }, "Up", function(c)
        if c.floating then
            c:relative_move(0, 0, 0, -10)
        else
            awful.client.incwfact(0.025)
        end
    end, { description = "Floating Resize Vertical -", group = "client" }),
    awful.key({ modkey, ctrlkey }, "Down", function(c)
        if c.floating then
            c:relative_move(0, 0, 0, 10)
        else
            awful.client.incwfact(-0.025)
        end
    end, { description = "Floating Resize Vertical +", group = "client" }),
    awful.key({ modkey, ctrlkey }, "Left", function(c)
        if c.floating then
            c:relative_move(0, 0, -10, 0)
        else
            awful.tag.incmwfact(-0.025)
        end
    end, { description = "Floating Resize Horizontal -", group = "client" }),
    awful.key({ modkey, ctrlkey }, "Right", function(c)
        if c.floating then
            c:relative_move(0, 0, 10, 0)
        else
            awful.tag.incmwfact(0.025)
        end
    end, { description = "Floating Resize Horizontal +", group = "client" }),

    -- Moving floating windows
    awful.key({ modkey, "Shift" }, "Down", function(c)
        c:relative_move(0, 10, 0, 0)
    end, { description = "Floating Move Down", group = "client" }),

    awful.key({ modkey, "Shift" }, "Up", function(c)
        c:relative_move(0, -10, 0, 0)
    end, { description = "Floating Move Up", group = "client" }),

    awful.key({ modkey, "Shift" }, "Left", function(c)
        c:relative_move(-10, 0, 0, 0)
    end, { description = "Floating Move Left", group = "client" }),

    awful.key({ modkey, "Shift" }, "Right", function(c)
        c:relative_move(10, 0, 0, 0)
    end, { description = "Floating Move Right", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = { description = "view tag #", group = "tag" }
        descr_toggle = { description = "toggle tag #", group = "tag" }
        descr_move = { description = "move focused client to tag #", group = "tag" }
        descr_toggle_focus = { description = "toggle focused client on tag #", group = "tag" }
    end

    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, descr_view),

        -- Toggle tag display.
        awful.key({ modkey, ctrlkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, descr_toggle),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, ctrlkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "zoom",
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Galculator",
                "pcsx2-qt",
                "feh",
                "steam",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Set applications to be maximized at startup.
    -- find class or role via xprop command
    -- { rule = { class = "Brave-browser" }, properties = { screen = 1, tag = "1" } },

    -- { rule = { class = "Code" },          properties = { screen = 1, tag = "2" } },

    -- { rule = { class = "Pcmanfm" },       properties = { screen = 1, tag = "3" } },

    -- { rule = { class = "Zathura" },       properties = { screen = 1, tag = "4" } },

    -- { rule = { class = "Slack" },         properties = { screen = 1, tag = "6" } },

    -- { rule = { class = "discord" },       properties = { screen = 1, tag = "7" } },

    -- { rule = { class = "zoom" },          properties = { screen = 1, tag = "9" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- Autostart Applications
awful.spawn.with_shell("nitrogen --restore &")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("volumeicon &")
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
