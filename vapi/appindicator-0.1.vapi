/* appindicator-0.1.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "", lower_case_cprefix = "")]
namespace AppIndicator {
	[CCode (cname = "AppIndicator", cprefix="app_indicator_", cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
  public class Indicator : GLib.Object {
    [CCode (has_construct_function = false)]
    public Indicator (string id, string icon_name, AppIndicator.Category category);
		[NoWrapper]
		public virtual unowned Gtk.StatusIcon fallback ();
		[CCode (cname = "app_indicator_get_attention_icon")]
		public string get_attention_icon ();
		[CCode (cname = "app_indicator_get_category")]
		public AppIndicator.Category get_category ();
		[CCode (cname = "app_indicator_get_icon")]
		public string get_icon ();
		[CCode (cname = "app_indicator_get_id")]
		public string get_id ();
		[CCode (cname = "app_indicator_get_menu")]
		public unowned Gtk.Menu get_menu ();
		[CCode (cname = "app_indicator_get_status")]
		public AppIndicator.Status get_status ();
		[CCode (cname = "app_indicator_set_attention_icon")]
		public void set_attention_icon (string icon_name);
		[CCode (cname = "app_indicator_set_icon")]
		public void set_icon (string icon_name);
		[CCode (cname = "app_indicator_set_menu")]
		public void set_menu (Gtk.Menu menu);
		[CCode (cname = "app_indicator_set_status")]
		public void set_status (AppIndicator.Status status);
		[NoWrapper]
		public virtual void unfallback (Gtk.StatusIcon status_icon);
    [CCode (has_construct_function = false)]
		public Indicator.with_path (string id, string icon_name, AppIndicator.Category category, string icon_path);
		[NoAccessorMethod]
		public string attention_icon_name { owned get; set; }
		public string category { get; construct; }
		[NoAccessorMethod]
		public bool connected { get; }
		[NoAccessorMethod]
		public string icon_name { owned get; set; }
		[NoAccessorMethod]
		public string icon_theme_path { owned get; construct; }
		public string id { get; construct; }
		public string status { get; set; }
		public virtual signal void connection_changed (bool connected);
		public virtual signal void new_attention_icon ();
		public virtual signal void new_icon ();
		public virtual signal void new_status (string status);
	}
	[CCode (cprefix = "APP_INDICATOR_CATEGORY_", cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
	public enum Category {
		APPLICATION_STATUS,
		COMMUNICATIONS,
		SYSTEM_SERVICES,
		HARDWARE,
		OTHER
	}
	[CCode (cprefix = "APP_INDICATOR_STATUS_", cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
	public enum Status {
		PASSIVE,
		ACTIVE,
		ATTENTION
	}
	[CCode (cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
	public const string SIGNAL_CONNECTION_CHANGED;
	[CCode (cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
	public const string SIGNAL_NEW_ATTENTION_ICON;
	[CCode (cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
	public const string SIGNAL_NEW_ICON;
	[CCode (cheader_filename = "libappindicator/app-indicator-enum-types.h,libappindicator/app-indicator.h")]
	public const string SIGNAL_NEW_STATUS;
}