{
  users.users = {
    john = {
      initialPassword = "mypassword123";
      isNormalUser = true;
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
