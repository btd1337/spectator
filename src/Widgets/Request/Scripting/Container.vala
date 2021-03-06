/*
* Copyright (c) 2019 Marvin Ahlgrimm (https://github.com/treagod)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Marvin Ahlgrimm <marv.ahlgrimm@gmail.com>
*/

namespace Spectator.Widgets.Request.Scripting {
    class Container : Gtk.Box {
        private ScriptingSourceView scripting_view;
        private Gtk.TextView console;
        private Gee.HashMap<Models.Request, Gtk.TextBuffer> request_consoles;
        private Gtk.ScrolledWindow scrolled_console;
        public Gtk.TextBuffer console_buffer {
            get {
                return console.buffer;
            }
            private set {
                console.buffer = value;
            }
        }

        public signal void console_out ();
        public signal void script_changed (string script);

        public Container () {
            request_consoles = new Gee.HashMap<Models.Request, Gtk.TextBuffer> ();
            orientation = Gtk.Orientation.VERTICAL;
            spacing = 5;
            scripting_view = new ScriptingSourceView ();

            scripting_view.changed.connect ((script) => {
                script_changed (script);
            });
            var paned = new Gtk.Paned (Gtk.Orientation.VERTICAL);
            get_style_context ().add_class ("console-box");

            var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 1);
            var js_console_button = new Gtk.Button.from_icon_name ("utilities-terminal", Gtk.IconSize.LARGE_TOOLBAR);
            js_console_button.tooltip_text = _("JavaScript Console");
            var js_info_button = new Gtk.Button.from_icon_name ("dialog-information", Gtk.IconSize.LARGE_TOOLBAR);
            js_info_button.tooltip_text = _("JavaScript Info");

            var scrolled_scripting_view = new Gtk.ScrolledWindow (null, null);
            scrolled_console = new Gtk.ScrolledWindow (null, null);
            scrolled_console.get_style_context ().add_class ("scrolled-console");
            console = new Gtk.TextView ();
            console.wrap_mode = Gtk.WrapMode.WORD;
            console.pixels_below_lines = 3;
            console.border_width = 12;
            console.editable = false;
            console.get_style_context ().add_class (Granite.STYLE_CLASS_TERMINAL);

            js_console_button.clicked.connect (() => {
                if (js_console_button.relief == Gtk.ReliefStyle.NONE) {
                    paned.remove (scrolled_console);
                    js_console_button.relief = Gtk.ReliefStyle.NORMAL;
                } else {
                    paned.pack2 (scrolled_console, true, true);
                    scrolled_console.show_all ();
                    js_console_button.relief = Gtk.ReliefStyle.NONE;
                }
            });

            js_info_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("https://treagod.github.io/spectator/#/scripting", null);
                } catch (Error e) {
                    stderr.printf ("Could not open URL\n");
                }
            });

            scrolled_console.add (console);
            scrolled_scripting_view.add (scripting_view);

            paned.pack1 (scrolled_scripting_view, true, true);
            pack_start (paned, true, true);
            button_box.pack_end (js_console_button, false, false);
            button_box.pack_end (js_info_button, false, false);
            add (button_box);
        }

        public void update_script_buffer (string buffer) {
            scripting_view.update_buffer (buffer);
        }

        public void change_console (Models.Request request) {
            if (request_consoles.has_key (request)) {
                console.buffer = request_consoles[request];
            } else {
                var buffer = new Gtk.TextBuffer (null);
                buffer.notify["text"].connect (() => {
                    scrolled_console.vadjustment.value = scrolled_console.vadjustment.upper;
                });
                request_consoles[request] = buffer;
                console.buffer = buffer;
            }
        }

        public new void grab_focus () {
            scripting_view.grab_focus ();
        }
    }
}
