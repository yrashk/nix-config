To proceed, few packages have to be installed: `git`, `blackbox`, `gnupg`

In order to provision, call `blackbox_decrypt_all_files` or `blackbox_postdeploy`
and to turn that ability off, run `blackbox_shred_all_files`

(PGP public and private key have to be imported into gnupg)

To set the timezone, use `timedatectl set-timezone`
