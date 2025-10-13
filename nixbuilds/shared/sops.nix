{ pkgs, ... }:
{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/nix/sops/age/keys.txt";
    secrets = {
      "HASHED_PASSWORD" = { };
      "PASSWORD" = { };
      "EMAIL" = { };
      "PLANKA/SECRET_KEY" = { };
      "TIANJI/POSTGRES_PASSWORD" = { };
      "TIANJI/JWT_SECRET" = { };
      "DEEPINFRA_API_KEY" = { };
      "GROQ_API_KEY" = { };
    };
  };

  environment = {
    systemPackages = with pkgs; [ sops ];
  };
}