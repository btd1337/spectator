/*
* Copyright (c) 2018 Marvin Ahlgrimm (https://github.com/treagod)
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

namespace HTTPInspector {
    public class Settings : Granite.Services.Settings {
        private static Settings? instance = null;

        public signal void theme_changed ();

        public bool dark_theme { get; set; }
        public int pos_x { get; set; }
        public int pos_y { get; set; }
        public int window_width { get; set; }
        public int window_height { get; set; }
        public bool maximized { get; set; }
        public bool use_proxy { get; set; }
        public string http_proxy { get; set; }
        public string https_proxy { get; set; }
        public string no_proxy { get; set; }
        public string proxy_uri { get; set; }
        public bool follow_redirects { get; set; }
        public string maximum_redirects { get; set; }
        public string timeout { get; set; }


        public static Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }

            return instance;
        }

        private Settings () {
            base ("com.github.treagod.httpinspector");
        }
    }
}
