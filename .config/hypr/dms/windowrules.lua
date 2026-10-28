-- DMS Window Rules — managed by DankMaterialShell
-- Do not edit manually; changes may be overwritten

-- DMS-RULE: id=dms_rule_0, name=
hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, rounding = 12 })

-- DMS-RULE: id=dms_rule_1, name=
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })

-- DMS-RULE: id=dms_rule_2, name=
hl.window_rule({ match = { class = "^(gnome-calculator)$" }, float = true })

-- DMS-RULE: id=dms_rule_3, name=
hl.window_rule({ match = { class = "^(galculator)$" }, float = true })

-- DMS-RULE: id=dms_rule_4, name=
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })

-- DMS-RULE: id=dms_rule_5, name=
hl.window_rule({ match = { class = "^(org\\.gnome\\.Nautilus)$" }, float = true })

-- DMS-RULE: id=dms_rule_6, name=
hl.window_rule({ match = { class = "^(xdg-desktop-portal)$" }, float = true })

-- DMS-RULE: id=dms_rule_7, name=
hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts)" }, no_focus = true, pin = true })

-- DMS-RULE: id=dms_rule_8, name=
hl.window_rule({ match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, float = true })

-- DMS-RULE: id=dms_rule_9, name=
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })

-- DMS-RULE: id=dms_rule_10, name=
hl.window_rule({ match = { class = "^(vboard)$" }, float = true, pin = true })

-- DMS-RULE: id=dms-floating-windows, name=DMS Floating Windows
hl.window_rule({ match = { class = "^com.danklinux.dms$" }, float = true })
