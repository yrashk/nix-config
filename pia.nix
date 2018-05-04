{ config, pkgs, ... }:
with pkgs.lib;

let secret = "/root/secrets/pia-user-pass";
scripts = pkgs.stdenv.mkDerivation {
   name = "pia-scripts";
   src = ./pia;
   installPhase = ''
     mkdir -p $out
     mkdir -p $out/share
     mkdir -p $out/bin
     cp crl.rsa.2048.pem $out/share
     cp ca.rsa.2048.crt $out/share
     cp up $out/bin/pia-up
     cp down $out/bin/pia-down
   '';
};
default = ''
  client
  dev tun
  proto udp
  resolv-retry infinite
  nobind
  persist-key
  persist-tun
  cipher aes-128-cbc
  auth sha1
  tls-client
  remote-cert-tls server
  auth-user-pass ${secret}
  comp-lzo
  verb 1
  reneg-sec 0
  crl-verify ${scripts}/share/crl.rsa.2048.pem
  ca ${scripts}/share/ca.rsa.2048.crt
  disable-occ
  redirect-gateway autolocal
'';
server = name: {
   config = ''
   ${default}
   remote ${name}.privateinternetaccess.com 1198
   '';
   autoStart = false;
   up = ''
     echo nameserver 8.8.8.8 | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev
     echo -n ${name} > /var/run/pia
  '';
   down = ''
     rm -f /var/run/pia
     ${pkgs.openresolv}/sbin/resolvconf -d $dev"
  '';
};

in
{
  environment.systemPackages = [ scripts ];

  system.activationScripts.pia = {
    text = ''
    mkdir -p `dirname ${secret}`
    install -m 0600 ${./pia/user-pass} ${secret}
    '';
    deps = [];
  };

  services.openvpn = {
    servers = {
      ca-toronto = server "ca-toronto";
      ca-vancouver = server "ca-vancouver";
      hk = server "hk";
      japan = server "japan";
      sg = server "sg";
      us-texas = server "us-texas";
    };
  };

}
