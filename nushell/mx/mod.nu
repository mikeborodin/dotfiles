def "mx cfg" [] {
    {
        headphones_name: ($env.MX_HEADPHONES_NAME? | default "headphones")
        wifi_iface: ($env.MX_WIFI_IFACE? | default "en0")
        tailscale_bin: ($env.MX_TAILSCALE_BIN? | default "/Applications/Tailscale.app/Contents/MacOS/Tailscale")
    }
}

def "mx _run-ts" [...args: string] {
    let cfg = (mx cfg)

    if ($cfg.tailscale_bin | path exists) {
        run-external $cfg.tailscale_bin ...$args
    } else {
        run-external tailscale ...$args
    }
}

def "mx bt status-record" [] {
    let cfg = (mx cfg)
    let power_raw = (do -i { ^blueutil --power } | default "0" | into string | str trim)
    let connected_raw = (do -i { ^blueutil --is-connected $cfg.headphones_name } | default "0" | into string | str trim)

    {
        power_on: ($power_raw == "1")
        headphones: $cfg.headphones_name
        connected: ($connected_raw == "1")
    }
}

def "mx bt paired-records" [] {
    let raw = (do -i { ^blueutil --paired --format json } | default "[]")
    (do -i { $raw | from json } | default [])
}

def "mx bt connected-records" [] {
    let devices = (mx bt paired-records)
    ($devices | where { |d| ($d.connected? | default false) })
}

def "mx bt _pick-name" [records prompt: string] {
    let names = (
        $records
        | each { |d| ($d.name? | default $d.address | into string | str trim) }
        | where { |name| $name != "" }
    )

    if ($names | is-empty) {
        ""
    } else {
        (do -i { $names | str join (char nl) | ^fzf --prompt $prompt --height 40% --layout reverse } | default "" | str trim)
    }
}

def "mx bt list" [--connected (-c), --json (-j)] {
    let devices = if $connected { (mx bt connected-records) } else { (mx bt paired-records) }

    if $json {
        print ($devices | to json)
        return
    }

    if ($devices | is-empty) {
        if $connected {
            print "BT: no connected devices"
        } else {
            print "BT: no paired devices"
        }
        return
    }

    $devices
    | each { |d|
        let name = ($d.name? | default $d.address | into string)
        let state = if ($d.connected? | default false) { "connected" } else { "paired" }
        print $"($name) [($state)]"
    }
}

def "mx bt status" [] {
    let bt = (mx bt status-record)

    if $bt.connected {
        print $"BT: on (($bt.headphones)) connected"
    } else if $bt.power_on {
        print $"BT: on (($bt.headphones)) disconnected"
    } else {
        print "BT: off"
    }
}

def "mx bt connect" [device?: string] {
    let target = if ($device | default "" | str trim) == "" {
        (mx bt _pick-name (mx bt paired-records) "bt connect > ")
    } else {
        $device
    }

    if $target == "" {
        return
    }

    do -i { ^blueutil --connect $target } | ignore
    sleep 300ms

    let connected_raw = (do -i { ^blueutil --is-connected $target } | default "0" | into string | str trim)
    if $connected_raw == "1" {
        let outputs = (do -i { ^SwitchAudioSource -a -t output } | lines | each { |line| $line | str trim })
        if ($outputs | any { |name| $name == $target }) {
            do -i { ^SwitchAudioSource -s $target } | ignore
            print $"BT: connected (($target)); audio switched"
        } else {
            print $"BT: connected (($target))"
        }
    } else {
        print $"BT: failed to connect (($target))"
    }
}

def "mx bt disconnect" [device?: string] {
    let target = if ($device | default "" | str trim) == "" {
        (mx bt _pick-name (mx bt connected-records) "bt disconnect > ")
    } else {
        $device
    }

    if $target == "" {
        return
    }

    do -i { ^blueutil --disconnect $target } | ignore
    sleep 150ms
    let connected_raw = (do -i { ^blueutil --is-connected $target } | default "0" | into string | str trim)
    if $connected_raw == "1" {
        print $"BT: still connected (($target))"
    } else {
        print $"BT: disconnected (($target))"
    }
}

def "mx bt toggle-headphones" [] {
    let bt = (mx bt status-record)
    if $bt.connected {
        mx bt disconnect $bt.headphones
    } else {
        mx bt connect $bt.headphones
    }
}

def "mx wifi status-record" [] {
    let cfg = (mx cfg)
    let power_line = (do -i { ^networksetup -getairportpower $cfg.wifi_iface } | default "" | str trim)
    let ssid_line = (do -i { ^networksetup -getairportnetwork $cfg.wifi_iface } | default "" | str trim)

    let power_on = ($power_line | str contains ": On")
    let ssid = if ($ssid_line | str contains ": ") {
        ($ssid_line | split row ": " | last)
    } else {
        ""
    }

    {
        iface: $cfg.wifi_iface
        power_on: $power_on
        ssid: $ssid
    }
}

def "mx wifi status" [] {
    let wifi = (mx wifi status-record)
    if not $wifi.power_on {
        print $"WiFi: off (($wifi.iface))"
    } else if $wifi.ssid == "" {
        print $"WiFi: on (($wifi.iface))"
    } else {
        print $"WiFi: on (($wifi.ssid))"
    }
}

def "mx wifi toggle" [] {
    let cfg = (mx cfg)
    let wifi = (mx wifi status-record)
    let next = if $wifi.power_on { "off" } else { "on" }
    do -i { ^networksetup -setairportpower $cfg.wifi_iface $next } | ignore
    sleep 150ms
    mx wifi status
}

def "mx wifi pick" [] {
    let cfg = (mx cfg)
    let networks = (
        do -i { ^networksetup -listpreferredwirelessnetworks $cfg.wifi_iface }
        | lines
        | skip 1
        | each { |line| $line | str trim }
        | where { |name| $name != "" }
    )

    if ($networks | is-empty) {
        print "WiFi: no preferred networks found"
        return
    }

    let picked = (do -i { $networks | str join (char nl) | ^fzf --prompt "wifi > " --height 40% --layout reverse } | default "" | str trim)

    if $picked == "" {
        return
    }

    do -i { ^networksetup -setairportnetwork $cfg.wifi_iface $picked } | ignore
    sleep 300ms
    mx wifi status
}

def "mx screen up" [count: int = 1] {
    for _ in 1..$count {
        do -i { ^osascript -e 'tell application "System Events" to key code 144' } | ignore
    }
    print $"Screen: brightness +(($count))"
}

def "mx screen down" [count: int = 1] {
    for _ in 1..$count {
        do -i { ^osascript -e 'tell application "System Events" to key code 145' } | ignore
    }
    print $"Screen: brightness -(($count))"
}

def "mx screen night status-record" [] {
    let raw = (do -i { ^nightlight status } | default "" | str trim)
    let lowered = ($raw | str downcase)
    let on = (($lowered | str contains "on") and (not ($lowered | str contains "off")))

    {
        available: ($raw != "")
        on: $on
        raw: $raw
    }
}

def "mx screen night status" [] {
    let ns = (mx screen night status-record)
    if not $ns.available {
        print "Night Shift: unavailable"
    } else if $ns.on {
        print "Night Shift: on"
    } else {
        print "Night Shift: off"
    }
}

def "mx screen night toggle" [] {
    let ns = (mx screen night status-record)

    if $ns.on {
        do -i { ^nightlight off } | ignore
    } else {
        do -i { ^nightlight on } | ignore
    }

    sleep 150ms
    mx screen night status
}

def "mx _tailscale_state" [] {
    let raw = (do -i { mx _run-ts status "--json" } | default "" | str trim)
    if $raw == "" {
        "Unavailable"
    } else {
        (do -i { $raw | from json | get BackendState } | default "Unknown")
    }
}

def "mx tail status-record" [] {
    let state = (mx _tailscale_state)
    {
        state: $state
        connected: ($state == "Running")
    }
}

def "mx tail status" [] {
    let tail = (mx tail status-record)
    if $tail.connected {
        print "Tailscale: connected"
    } else {
        print $"Tailscale: (($tail.state | str downcase))"
    }
}

def "mx tail toggle" [] {
    let state = (mx _tailscale_state)
    if $state == "Running" {
        do -i { mx _run-ts down } | ignore
    } else {
        do -i { mx _run-ts up } | ignore
    }

    sleep 200ms
    mx tail status
}

def "mx vpn active-record" [] {
    let connected_lines = (
        do -i { ^scutil --nc list }
        | lines
        | where { |line| $line | str starts-with "* (Connected)" }
    )

    let names = ($connected_lines | each { |line|
        let parts = ($line | split row '"')
        if (($parts | length) > 1) {
            ($parts | get 1)
        } else {
            $line
        }
    })

    {
        active: (($names | length) > 0)
        names: $names
    }
}

def "mx vpn active" [] {
    let vpn = (mx vpn active-record)
    if $vpn.active {
        let names = ($vpn.names | str join ", ")
        print $"VPN: active ($names)"
    } else {
        print "VPN: inactive"
    }
}

def "mx status-record" [] {
    let bt = (mx bt status-record)
    let audio = (do -i { ^SwitchAudioSource -c } | default "unknown" | str trim)
    let wifi = (mx wifi status-record)
    let night = (mx screen night status-record)
    let tail = (mx tail status-record)
    let vpn = (mx vpn active-record)

    {
        bt: $bt
        audio: $audio
        wifi: $wifi
        night_shift: $night
        tailscale: $tail
        vpn: $vpn
    }
}

def "mx status" [--json (-j)] {
    let s = (mx status-record)

    if $json {
        print ($s | to json)
        return
    }

    let bt_line = if $s.bt.connected {
        (["on " $s.bt.headphones " connected"] | str join "")
    } else if $s.bt.power_on {
        (["on " $s.bt.headphones " disconnected"] | str join "")
    } else {
        "off"
    }

    let wifi_line = if not $s.wifi.power_on {
        "off"
    } else if $s.wifi.ssid == "" {
        "on"
    } else {
        $"on (($s.wifi.ssid))"
    }

    let night_line = if not $s.night_shift.available {
        "unavailable"
    } else if $s.night_shift.on {
        "on"
    } else {
        "off"
    }

    let tail_line = if $s.tailscale.connected {
        "connected"
    } else {
        ($s.tailscale.state | str downcase)
    }

    let vpn_names = ($s.vpn.names | str join ", ")
    let vpn_line = if $s.vpn.active {
        $"active: ($vpn_names)"
    } else {
        "inactive"
    }

    print $"BT      ($bt_line)"
    print $"Audio   ($s.audio)"
    print $"WiFi    ($wifi_line)"
    print $"Night   ($night_line)"
    print $"Tail    ($tail_line)"
    print $"VPN     ($vpn_line)"
}

def "mx menu" [] {
    let actions = [
        "status"
        "bt: toggle headphones"
        "bt: connect device"
        "bt: disconnect device"
        "bt: list paired"
        "bt: list connected"
        "wifi: toggle"
        "wifi: pick and connect"
        "screen: brightness up"
        "screen: brightness down"
        "screen: night shift toggle"
        "tailscale: toggle"
        "vpn: active"
    ]

    let picked = (do -i { $actions | str join (char nl) | ^fzf --prompt "mx > " --height 50% --layout reverse } | default "" | str trim)

    match $picked {
        "status" => { mx status }
        "bt: toggle headphones" => { mx bt toggle-headphones }
        "bt: connect device" => { mx bt connect }
        "bt: disconnect device" => { mx bt disconnect }
        "bt: list paired" => { mx bt list }
        "bt: list connected" => { mx bt list --connected }
        "wifi: toggle" => { mx wifi toggle }
        "wifi: pick and connect" => { mx wifi pick }
        "screen: brightness up" => { mx screen up }
        "screen: brightness down" => { mx screen down }
        "screen: night shift toggle" => { mx screen night toggle }
        "tailscale: toggle" => { mx tail toggle }
        "vpn: active" => { mx vpn active }
        _ => { null }
    }
}

def "mx help" [] {
    print "mx commands"
    print "  mx"
    print "  mx status [--json]"
    print "  mx bt status|list|connect [device]|disconnect [device]|toggle-headphones"
    print "  mx wifi status|toggle|pick"
    print "  mx screen up [count]"
    print "  mx screen down [count]"
    print "  mx screen night status|toggle"
    print "  mx tail status|toggle"
    print "  mx vpn active"
}

def mx [] {
    mx menu
}
