/*
 * Copyright (C) 2010 Michal Hruby <michal.mhr@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA.
 *
 * Authored by Michal Hruby <michal.mhr@gmail.com>
 *
 */

namespace Synapse
{
  [DBus (name = "org.gnome.SessionManager")]
  public interface GnomeSessionManager: Object
  {
    public const string UNIQUE_NAME = "org.gnome.SessionManager";
    public const string OBJECT_PATH = "/org/gnome/SessionManager";
    public const string INTERFACE_NAME = "org.gnome.SessionManager";
    
    public abstract bool can_shutdown () throws DBus.Error;
    public abstract void shutdown () throws DBus.Error;
    public abstract void request_reboot () throws DBus.Error;
    public abstract void logout (uint32 mode = 0) throws DBus.Error;
  }
    
  public class GnomeSessionPlugin: DataPlugin
  {
    private class ShutDownAction: Object, Match
    {
      // for Match interface
      public string title { get; construct set; }
      public string description { get; set; default = ""; }
      public string icon_name { get; construct set; default = ""; }
      public bool has_thumbnail { get; construct set; default = false; }
      public string thumbnail_path { get; construct set; }
      public string uri { get; set; }
      public MatchType match_type { get; construct set; }

      public ShutDownAction ()
      {
        Object (match_type: MatchType.ACTION, title: "Shut Down",
                description: "Turn your computer off",
                icon_name: "system-shutdown", has_thumbnail: false);
      }
      
      public void execute (Match? match)
      {
        try
        {
          var connection = DBus.Bus.get (DBus.BusType.SESSION);
          var dbus_interface = (GnomeSessionManager)
            connection.get_object (GnomeSessionManager.UNIQUE_NAME,
                                   GnomeSessionManager.OBJECT_PATH,
                                   GnomeSessionManager.INTERFACE_NAME);

          dbus_interface.shutdown ();
        }
        catch (DBus.Error err)
        {
          warning ("%s", err.message);
        }
      }
    }

    private class RebootAction: Object, Match
    {
      // for Match interface
      public string title { get; construct set; }
      public string description { get; set; default = ""; }
      public string icon_name { get; construct set; default = ""; }
      public bool has_thumbnail { get; construct set; default = false; }
      public string thumbnail_path { get; construct set; }
      public string uri { get; set; }
      public MatchType match_type { get; construct set; }

      public RebootAction ()
      {
        Object (match_type: MatchType.ACTION, title: "Restart",
                description: "Restart your computer",
                icon_name: "gnome-session-reboot", has_thumbnail: false);
      }
      
      public void execute (Match? match)
      {
        try
        {
          var connection = DBus.Bus.get (DBus.BusType.SESSION);
          var dbus_interface = (GnomeSessionManager)
            connection.get_object (GnomeSessionManager.UNIQUE_NAME,
                                   GnomeSessionManager.OBJECT_PATH,
                                   GnomeSessionManager.INTERFACE_NAME);

          dbus_interface.request_reboot ();
        }
        catch (DBus.Error err)
        {
          warning ("%s", err.message);
        }
      }
    }

    private class LogOutAction: Object, Match
    {
      // for Match interface
      public string title { get; construct set; }
      public string description { get; set; default = ""; }
      public string icon_name { get; construct set; default = ""; }
      public bool has_thumbnail { get; construct set; default = false; }
      public string thumbnail_path { get; construct set; }
      public string uri { get; set; }
      public MatchType match_type { get; construct set; }

      public LogOutAction ()
      {
        Object (match_type: MatchType.ACTION, title: "Log Out",
                description: "Close your session and return to the login screen",
                icon_name: "gnome-session-logout", has_thumbnail: false);
      }
      
      public void execute (Match? match)
      {
        try
        {
          var connection = DBus.Bus.get (DBus.BusType.SESSION);
          var dbus_interface = (GnomeSessionManager)
            connection.get_object (GnomeSessionManager.UNIQUE_NAME,
                                   GnomeSessionManager.OBJECT_PATH,
                                   GnomeSessionManager.INTERFACE_NAME);

          dbus_interface.logout ();
        }
        catch (DBus.Error err)
        {
          warning ("%s", err.message);
        }
      }
    }

    static construct
    {
      DataSink.PluginRegistry.get_default ().register_plugin (
        typeof (GnomeSessionPlugin),
        "Gnome session plugin",
        "Allows you to log out from your session, restart and shutdown your computer.",
        "gnome-session-logout",
        DBusNameCache.get_default ().name_has_owner (GnomeSessionManager.UNIQUE_NAME),
        "Gnome Session Manager wan't found"
      );
    }

    private bool session_manager_available = false;
    private Gee.List<Match> actions;

    construct
    {
      var cache = DBusNameCache.get_default ();
      session_manager_available = cache.name_has_owner (GnomeSessionManager.UNIQUE_NAME);
      debug ("%s %s available", GnomeSessionManager.UNIQUE_NAME,
        session_manager_available ? "is" : "isn't");
      
      actions = new Gee.LinkedList<Match> ();
      actions.add (new LogOutAction ());
      actions.add (new RebootAction ());
      actions.add (new ShutDownAction ());
    }
    
    private DBus.Connection connection;
    
    public override async ResultSet? search (Query q) throws SearchError
    {
      if (!session_manager_available) return null;
     // we only search for actions
      if (!(QueryFlags.ACTIONS in q.query_type)) return null;

      var result = new ResultSet ();

      var matchers = Query.get_matchers_for_query (q.query_string, 0,
        RegexCompileFlags.OPTIMIZE | RegexCompileFlags.CASELESS);

      foreach (var action in actions)
      {
        foreach (var matcher in matchers)
        {
          if (matcher.key.match (action.title))
          {
            result.add (action, matcher.value - 5);
            break;
          }
        }
      }

      q.check_cancellable ();

      return result;
    }
  }
}
