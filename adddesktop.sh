#! /bin/bash

TEXTDOMAINDIR=/usr/share/locale 
TEXTDOMAIN=adddesktop.sh

if [[ $UID != "0" ]]; then
 gksu $0 &
 exit 1 ;
fi

export DIALOG=$(cat <<End_of_Text

<window title="`gettext $"Desktop Files"`" window-position="1">

<vbox>
  <hbox>
  <vbox>
  <frame>
    <frame `gettext $"Menu name:"`>
    <entry>
      <variable>APPNAME</variable>
    </entry>
    </frame>

    <frame `gettext $"Menu icon:"`>
    <hbox>
      <entry accept="filename">
      <label>"`gettext $"Select an icon."`"</label>
      <variable>ICONSEL</variable>
      </entry>
      <button>
      <input file stock="gtk-open"></input>
      <variable>ICON_FILENAME</variable>
      <action type="fileselect">ICONSEL</action>
      </button>
    </hbox>
    </frame>

    <frame `gettext $"Menu category:"`>
    <combobox>
      <variable>CATEGORY</variable>
      <item>AudioVideo</item>
      <item>Development</item>
      <item>Education</item>
      <item>Game</item>
      <item>Graphics</item>
      <item>Network</item>
      <item>Office</item>
      <item>Settings</item>
      <item>System</item>
      <item>Utility</item>
    </combobox>
    </frame>
  </frame>
  </vbox>

  <vbox>
  <frame>
    <frame `gettext $"Command to execute:"`>
    <hbox>
      <entry accept="filename">
      <label>"`gettext $"Select an application."`"</label>
      <variable>EXECCMD</variable>
      </entry>
      <button>
      <input file stock="gtk-open"></input>
      <variable>CMD_FILENAME</variable>
      <action type="fileselect">EXECCMD</action>
      </button>
    </hbox>
    </frame>

    <frame `gettext $"Launch in a terminal?"`>
    <combobox>
      <variable>TERMINALYN</variable>
      <default>no</default>
      <item>`gettext $"no"`</item>
      <item>`gettext $"yes"`</item>
    </combobox>
    </frame>

    <frame `gettext $"File name:"`>
    <entry>
      <variable>FILE_SAVEFILENAME</variable>
    </entry>
    </frame>
  </frame>
  </vbox>
  </hbox>
  
  <hbox>
 	<button ok></button>
 	<button cancel></button>
  </hbox>
</vbox>

</window>
End_of_Text
)

I=$IFS; IFS=""
for STATEMENTS in  $(gtkdialog --program DIALOG); do
  eval $STATEMENTS
done
IFS=$I

if [ "$EXIT" = "OK" ] ; then
  echo "[Desktop Entry]" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  echo "Encoding=UTF-8" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  echo "Name=""$APPNAME" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  echo "Exec=""$EXECCMD" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  echo "Icon=""$ICONSEL" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop

  if [ "$TERMINALYN" = "no" ] ; then
    echo "Terminal=false" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  else
    echo "Terminal=true" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  fi

  echo "Type=Application" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop
  echo "Categories=""$CATEGORY"";" >> /usr/share/applications/"$FILE_SAVEFILENAME".desktop

  yad --title="Desktop Files" --image="info" --text=$"Your .desktop file has been saved as\n /usr/share/applications/$FILE_SAVEFILENAME.desktop" --button="OK";
fi

