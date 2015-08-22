--[[
Awesome configuration
Based on standard awesome configuration
keep a copy of standard config.

I set some variable that you can easily change if you want

TO-DO:
 -> Something...
]]

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
--Widget lib
require("vicious")

-- Use this function will cause crash...--
function simpleNotify(title, text)
      os.execute("notify-send".. " "..title.. " "..text)
end

function lua_line_prompt()
		  awful.prompt.run({ prompt = "Run Lua code: " },
		  mypromptbox[mouse.screen].widget,
		  awful.util.eval, nil,
		  awful.util.getdir("cache") .. "/history_eval")
end

function os_command_prompt()
		  awful.prompt.run({ prompt = "OS command: " },
		  mypromptbox[mouse.screen].widget,
		  function(s)
					 os.execute(s)
		  end)
end

function ssh_prompt()
		  awful.prompt.run({ prompt = "SSH (user@host) or only host-> "},
		  mypromptbox[mouse.screen].widget,
		  function(s)
					 awful.util.spawn("xterm -title 'SSH: "..s.."' -e 'ssh "..s.."; read'")
		  end)
end


function do_screenshot() 
		  os.execute("scrot".." "..screenshot_path)
		  naughty.notify({
					 title = "Screenshot",
					 text = "Saved to: "..screenshot_path,
					 timeout = 5
		  })
end

function xrandr_auto_mode()
		  os.execute("xrandr --auto")
		  naughty.notify({
					 title = "XRandR",
					 text = "Auto mode activated...",
					 timeout = 5
		  })
end

--[[
Keyboard Layout:
==> it : Italy
==> en : English
==> es : Spain
==> us : United States
==> de : Germany
==> fr : France
==> ?ru : Russia
==> ?ch : China
==> ?jp : Japan
==> More...
Type string value :)
"it" 
]]--
local keyboard_layout = "it"

-- Italian keyboard layout
os.execute("setxkbmap "..keyboard_layout)

-- Awesome config 
conf_file = "/home/stefanozzz123/.config/awesome/rc.lua"
theme_conf_file = "/usr/share/awesome/themes/default/theme.lua"

if awesome.startup_error then
		  local errtitle = "ERROR!"
		  local errtext = "There was an error during startup!"
		  naughy.notify({ preset = naughty.config.presets.critical,
								title = errtitle,
								text = errtext
							})
end

-- Handle runtime errors after startup
do
    local in_error = false
	 local isDeprecated = false
	 
    awesome.add_signal("debug::error", function ()
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
								 timeout = 5})
        in_error = false
    end)

	 awesome.add_signal("debug::deprecated", function()
				
				if isDeprecated then return end
				isDeprecated = true
				-- Code...
				naughty.notify({ preset = naughty.config.presets.normal,
									  title = "Warning!",
									  text = "A deprecated Lua function was called. This is not an error... Just a warning.",
									  timeout = 5})
				-- Done.
				isDeprecated = false
	 end)
end

-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(theme_conf_file)

--Change this value to get a custom textclock format.

--dataformat should be a string
--default value is: "%a %b %c, %H:%M"
--             -->   Mon Jul 05, 10:30 (example)
--
dataformat="%a %d/%m/%Y %H:%M:%S"
--updatedata must be an integer value
--default value is: 60
--But I want that it updates every second, so I set 1 
updatedata=1

-- This is used later as the default terminal and editor to run.
-- But only as default terminal. To do other things, Xterm will be used :) 
vbox_exec_cmd = "sudo VirtualBox"
netcard = "wlp7s0"
terminal = "urxvt"
editor = "vim"
file_manager = ""
poweroff_cmd = "sudo /sbin/poweroff"
reboot_cmd = "sudo /sbin/reboot"
command_exec = "" -- Execute command without showing output
command_exec_spawn = "telegram" -- Spawn new Window 
screenshot_path = "$HOME/screenshot.png"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

--}}}
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =

{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, layouts[1])
end

screen[1]:add_signal("tag::history::update", function()
		          local tagn = awful.tag.selected(1).name
					 naughty.notify({ preset = naughty.config.presets.low,
		   	                     title = "Workspace Changed",
					                  text = "=> " .. tagn,
											timeout = 2})
	end)

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "Awesome manual", function() 
			  local term = "xterm -title 'Awesome Manual'"
			  awful.util.spawn(term .. " -e " .. "'man awesome'")
	end },
   { "Edit config file", function()
			  local term = "xterm -title 'Awesome config file'"
			  awful.util.spawn(term .. " -e " .. "'" ..editor .. " " .. conf_file .. "'") 
	end },
   { "Edit theme file", function()
			  local term = "xterm -title 'Awesome theme file'"
			  awful.util.spawn(term .. " -e " .. "'" .. " sudo "..editor .. " " .. theme_conf_file .. "'")
	end },
   { "Reload config", awesome.restart },
   { "Quit Awesome", awesome.quit }

}

otheractions = {
		  { "SSH", ssh_prompt },
		  { "OS Command", os_command_prompt },
		  { "Lua code", lua_line_prompt },
		  { "Screenshot",do_screenshot },
		  { "XRandR Auto Mode", xrandr_auto_mode }
}

mymainmenu = awful.menu({ items = { 
		  { "Awesome...", myawesomemenu, beautiful.awesome_icon },
		  { "Actions...", otheractions, beautiful.action_icon },
		  { "Terminal", terminal, beautiful.terminal_icon },
		  { "Editor: ".. editor, function() 
					 local term = "xterm -title ' "..editor.." '"
					 awful.util.spawn(terminal .. " -e " .."'".. editor .."'") end, beautiful.editor_icon },
		  { "Power off", function() os.execute(poweroff_cmd) end, beautiful.poweroff_icon },
		  { "Reboot", function() os.execute(reboot_cmd) end, beautiful.reboot_icon }
   }
})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock.new({ align = "right"}, dataformat, updatedata)
mytextclock:add_signal("mouse::enter", function()
		  naughty.notify({ title = "Date & time", text = "Today is...", timeout = 1})
end)

-- {{{ Bottom wibox widgets
-- next: replace "names" with icons and make them better
--
-- **VICIOUS**

-- CPU 
showCPU = widget({ type = "textbox"})
vicious.register(showCPU, vicious.widgets.cpu, " | CPU0: $1%, CPU1: $2%")

-- Battery
cur_battery = widget({ type = "textbox"})
vicious.register(cur_battery, vicious.widgets.bat, " | Battery: $2%",5, "BAT1")

-- Memory usage
mem_usage = widget({ type = "textbox"})
vicious.register(mem_usage, vicious.widgets.mem, " | RAM Usage: $1% [$2/$3MB]", 2)

--Disk Usage
disk_usage = widget({ type = "textbox"})
vicious.register(disk_usage, vicious.widgets.fs, " | Disk (Used) [/]: ${/ used_gb}/${/ size_gb}GB")

-- Volume
volume = widget({ type = "textbox"})
vicious.register(volume, vicious.widgets.volume, " | Volume: $1% ", 1, "Master")

-- Network Usage
network_usage = widget({ type = "textbox"})
vicious.register(network_usage, vicious.widgets.net, " ["..netcard.."]: Download: ${"..netcard.." down_kb}kB / Upload: ${"..netcard.." up_kb}kB")

-- user@hostname
-- This widget goes on the top wibox. [ONLY THIS]
user_host = widget({ type = "textbox"})
vicious.register(user_host, vicious.widgets.os, " $3@$4 ")

-- Uptime
uptime = widget({ type = "textbox"})
vicious.register(uptime, vicious.widgets.uptime, " | Uptime: $2h:$3m", 60)

-- WiFi
wifi = widget({ type = "textbox"})
vicious.register(wifi, vicious.widgets.wifi, " ${ssid}",3,netcard)

-- YourWidget
-- widgetName = widget({ type = "yourtype"})
-- vicious.register(widget, vicious.widget.module, ...)
-- 
-- then add it to wibox table
--

--}}}

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    

	 -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
			   mylauncher,
			   user_host,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
		  mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- Bottom WiBox
swibox = {}

for s = 1, screen.count() do

		  swibox[s] = awful.wibox({ position = "bottom", screen = s})
		  swibox[s].widgets = {

                { 
					    wifi
					 },
					 network_usage, 
					 showCPU,
					 mem_usage,
					 disk_usage,
					 uptime,
					 cur_battery,
					 volume,
					 layout = awful.widget.layout.horizontal.leftright
		  }
end

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x", lua_line_prompt),
	 
	 --OS Shell command
	 awful.key({modkey}, "c", os_command_prompt),

	 --SSH Connection
	 awful.key({modkey}, "s", ssh_prompt),


    --Shutdown and reboot
    --[[
    No password needed:
    add these lines to /etc/sudoers:

    stefanozzz123 ALL=(root) NOPASSWD: /sbin/poweroff
    stefanozzz123 ALL=(root) NOPASSWD: /sbin/reboot

    ... and replace 'stefanozzz123' with your $USER var
    ]]--
    awful.key({ "Mod1", "Space" }, "p", function() os.execute(poweroff_cmd) end),
    awful.key({ "Mod1", "Space" }, "r", function() os.execute(reboot_cmd) end),

	 --LibreOffice
	 awful.key({ "Mod1", "Space"}, "l", function() awful.util.spawn("libreoffice") end),

    --Firefox
    awful.key({ "Mod1", "Shift" }, "f", function() awful.util.spawn("firefox-bin") end),

    --File Manager
    awful.key({ "Mod1","Shift" }, "t", function() awful.util.spawn("dbus-launch "..file_manager) end),

    --GParted 
    awful.key({ "Mod1" ,"Shift"}, "p", function() awful.util.spawn("gksu gparted") end),

    --Codeblocks, Eclipse, Android Studio, Sublime, Mousepad
    awful.key({"Mod1", "Shift"}, "c", function() awful.util.spawn("codeblocks") end),
    awful.key({"Mod1", "Shift"}, "e", function() awful.util.spawn("eclipse") end),
    awful.key({"Mod1", "Shift"}, "a", function() awful.util.spawn("android-studio") end),
    awful.key({"Mod1", "Shift"}, "m", function() awful.util.spawn("mousepad")end),
    awful.key({"Mod1", "Shift"}, "y", function() awful.util.spawn("subl") end),

    --VLC
    awful.key({"Mod1", "Shift"}, "v", function() awful.util.spawn("vlc") end),

    --Shotwell
    awful.key({"Mod1", "Shift"}, "s", function() awful.util.spawn("shotwell") end),

    --qBittorrent
    awful.key({"Mod1", "Shift"}, "q", function() awful.util.spawn("qbittorrent") end),

    --guvcview
    awful.key({"Mod1", "Shift"}, "w", function() awful.util.spawn("guvcview") end),

    --VirtualBox
    awful.key({"Mod1", "Shift"}, "b", function() awful.util.spawn(vbox_exec_cmd) end),

    --Do Screenshots with scrot
    awful.key({"Mod1", "Shift"}, "d", do_screenshot),

    --Open WICD GTK 
    awful.key({"Mod1", "Space"}, "w", function() awful.util.spawn("wicd-gtk") end),

    --GIMP 
    awful.key({"Mod1", "Space"}, "g", function() awful.util.spawn("gimp") end),

	 --Ranger
	 awful.key({"Mod1", "Space"}, "f", function() awful.util.spawn(terminal .. " -e".. " 'ranger'") end),
	 
	 --MOCP
	 awful.key({"Mod1", "Space"}, "m", function() awful.util.spawn(terminal .. " -e".. " 'mocp'") end),

	 --AlsaMixer
	 awful.key({"Mod1", "Space"}, "z", function() awful.util.spawn(terminal .. " -e" .. " 'alsamixer'") end),

	 --HTop
	 awful.key({"Mod1", "Space"}, "x", function() awful.util.spawn(terminal .. " -e" .. " 'htop'")end),

	 --Audio Control
	 awful.key({}, "XF86AudioRaiseVolume", function() os.execute("amixer -q set Master 3dB+ unmute") end),
	 awful.key({}, "XF86AudioLowerVolume", function() os.execute("amixer -q set Master 3dB- unmute") end),
	 awful.key({}, "XF86AudioMute", function() os.execute("amixer -q set Master toggle") end),

	 -- Your program
	 awful.key({"Mod1"}, "Shift", function() os.execute(command_exec) end),
	 awful.key({"Mod1"}, "Space", function() awful.util.spawn(terminal .. " -e" .. " '"..command_exec_spawn.."' ")end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awesome.add_signal("spawn::initiated", function()
		  naughty.notify({ title = "Starting...", 
								 timeout = 3 })
end)

awesome.add_signal("spawn::canceled", function()
		  naughty.notify({ title = "Aborted",
								 text = "Application start aborted...",
								 timeout = 3 })
end)

awesome.add_signal("exit", function()
		  naughty.notify({ title = "Exiting awesome...",
								 text = "Bye bye!",
								 timeout = 1 })
end)

--[[
You can add signals like this:

what.add_signal("sign_name", function()
      {...}
end)
]]

-- }}}
