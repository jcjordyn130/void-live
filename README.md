## The Void Linux live image maker and installer

This repository contains utilities for Void Linux:
 * mkimg     (The Void Linux live image maker for x86)
 * mklive    (Ran by the above utility)
 * installer (The installer for Void Linux)

#### Dependencies

 * xbps>=0.45

#### Usage

Type

    $ make

and then to make the image

    $ ./mkimg.sh 

#### Configuration

In order to configure ./mkimg.sh just edit it and change the line with 'exec ./mklive.sh'.

Build a native live image with runit and keyboard set to 'fr':

    # ./mklive.sh -k fr

Build an i686 (on x86\_64) live image with some additional packages:

    # ./mklive.sh -a i686 -p 'vim rtorrent'

Build an x86\_64 musl live image with packages stored in a local repository:

    # ./mklive.sh -a x86_64-musl -r /path/to/host/binpkgs

See the usage output of mklive.sh for more information :D
