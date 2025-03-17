/* See LICENSE file for copyright and license details. */

/* interval between updates (in ms) */
const unsigned int interval = 1000;

/* text to show if no value can be retrieved */
static const char unknown_str[] = "n/a";

/* maximum output string length */
#define MAXLEN 2048

/*
 * function            description                     argument (example)
 *
 * battery_perc        battery percentage              battery name (BAT0)
 *                                                     NULL on OpenBSD/FreeBSD
 * battery_remaining   battery remaining HH:MM         battery name (BAT0)
 *                                                     NULL on OpenBSD/FreeBSD
 * battery_state       battery charging state          battery name (BAT0)
 *                                                     NULL on OpenBSD/FreeBSD
 * cat                 read arbitrary file             path
 * cpu_freq            cpu frequency in MHz            NULL
 * cpu_perc            cpu usage in percent            NULL
 * datetime            date and time                   format string (%F %T)
 * disk_free           free disk space in GB           mountpoint path (/)
 * disk_perc           disk usage in percent           mountpoint path (/)
 * disk_total          total disk space in GB          mountpoint path (/)
 * disk_used           used disk space in GB           mountpoint path (/)
 * entropy             available entropy               NULL
 * gid                 GID of current user             NULL
 * hostname            hostname                        NULL
 * ipv4                IPv4 address                    interface name (eth0)
 * ipv6                IPv6 address                    interface name (eth0)
 * kernel_release      `uname -r`                      NULL
 * keyboard_indicators caps/num lock indicators        format string (c?n?)
 *                                                     see keyboard_indicators.c
 * keymap              layout (variant) of current     NULL
 *                     keymap
 * load_avg            load average                    NULL
 * netspeed_rx         receive network speed           interface name (wlan0)
 * netspeed_tx         transfer network speed          interface name (wlan0)
 * num_files           number of files in a directory  path
 *                                                     (/home/foo/Inbox/cur)
 * ram_free            free memory in GB               NULL
 * ram_perc            memory usage in percent         NULL
 * ram_total           total memory size in GB         NULL
 * ram_used            used memory in GB               NULL
 * run_command         custom shell command            command (echo foo)
 * swap_free           free swap in GB                 NULL
 * swap_perc           swap usage in percent           NULL
 * swap_total          total swap size in GB           NULL
 * swap_used           used swap in GB                 NULL
 * temp                temperature in degree celsius   sensor file
 *                                                     (/sys/class/thermal/...)
 *                                                     NULL on OpenBSD
 *                                                     thermal zone on FreeBSD
 *                                                     (tz0, tz1, etc.)
 * uid                 UID of current user             NULL
 * uptime              system uptime                   NULL
 * username            username of current user        NULL
 * vol_perc            OSS/ALSA volume in percent      mixer file (/dev/mixer)
 *                                                     NULL on OpenBSD/FreeBSD
 * wifi_essid          WiFi ESSID                      interface name (wlan0)
 * wifi_perc           WiFi signal in percent          interface name (wlan0)
 */
static const struct arg args[] = {
	/* function format          argument */
	/* Displays the temperature read from the file /sys/class/thermal/thermal_zone0/temp , you can change that file
     to any other file that displays the temperature of certain components, you can even list multiple
     temperatures by duplicating it */
	// { temp, 		"[TEMP %sC] ", 		"/sys/class/thermal/thermal_zone0/temp" },
	{ cpu_perc,		"[CPU %s%] ", 		NULL },
	{ ram_perc, 	"[RAM %s%] ", 		NULL },
   	/* If you have two sound cards (like me PCH/HDMI) then you may need to use /dev/mixer1 instead of /dev/mixer to get vol_perc working*/
	{ run_command,  "[VOL %s%] ",         "sh -c \"pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -n 1\""},
	// { vol_perc, 	"[VOL %s%] ", 		"/dev/mixer" },
   	/* Displays battery's capacity, you need to specify the battery folder's name listed in /sys/class/power_supply,
	  for me it's BAT0 and it'll automatically read the capacity file */
	{ battery_perc, "[BAT %s%] ", 		"BAT0" },
   	/* Displays IPv4 address for the given network interface (which in my case is wlp3s0) in your local network */
	// { ipv4, 		"[LAN IP %s] ", 	"enx00be434e1ba3" },
	// { ipv4, 		"[WLAN IP %s] ",	"wlp0s20f3" },
	{ datetime, 	"[%s]", 			"%F %r" 	},
};

// static const struct arg args[] = {
// 	/* function format          argument */
// 	{ cpu_perc,		"[⚡ %s%%] ", 		NULL },
// 	{ ram_perc, 	"[💻 %s%%] ", 		NULL },
// 	{ run_command,  "[🔊 %s%%] ",         "sh -c \"pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -n 1\""},
// 	{ battery_perc, "[🔋 %s%%] ", 		"BAT0" },
// 	{ datetime, 	"[%s]", 			"%F %r" 	},
// };
