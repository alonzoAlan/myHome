{ pkgs, config, lib, inputs, ... }:{
  home-manager.users.vamshi.services.dunst = {
  	enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
		# settings = {
		# 	global = {
		# 		geometry = "600x6-90+50";
		# 		font = "Lucida MAC 20";
		# 		line_height = 12;
		# 	};
		# };
     settings = {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 0;
        padding = 16;
        horizontal_padding = 16;
        # font = "SF Pro Text 19";
        font = "Ubuntu 21";
        # font = "xft:Ubuntu :weight=bold:pixelsize=43:antialias=true:hinting=true"; # "SF Pro Text 19";
        line_height = 4;
        format = ''<b>%s</b>\n%b'';
      };
    };
  };
}
