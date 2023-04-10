#!/usr/bin/bash

echo $(curl -Ss 'https://wttr.in?0&T&Q' | cut -c 16- | head -2)
