{ pkgs, ... }:
{
  users.users = {
    john = {
      initialPassword = "mypassword123";
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "John";
      openssh.authorizedKeys.keys = [ ];
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
    john-kv = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "John KV";
      openssh.authorizedKeys.keys = [ ];
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };
}
