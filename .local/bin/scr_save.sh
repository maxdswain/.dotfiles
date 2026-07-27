#!/bin/sh -e

selection=$(hacksaw -f "-i %i -g %g")
shotgun $selection ~/Downloads/image.png
