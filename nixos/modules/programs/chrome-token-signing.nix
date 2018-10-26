{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface
  options = {
    programs.chrome-token-signing.enable = mkEnableOption "Chrome extension for signing with your eID on the web";
  };

  ###### implementation
  config = mkIf config.programs.chrome-token-signing.enable {
    environment.systemPackages = [ pkgs.chrome-token-signing ];
    environment.etc = {
      "chromium/native-messaging-hosts/ee.ria.esteid.json".source = "${pkgs.chrome-token-signing}/etc/chromium/native-messaging-hosts/ee.ria.esteid.json";
      "opt/chrome/native-messaging-hosts/ee.ria.esteid.json".source = "${pkgs.chrome-token-signing}/etc/opt/chrome/native-messaging-hosts/ee.ria.esteid.json";
    };
  };
}
