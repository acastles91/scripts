#!/bin/bash

#OPTIONS AND VARIABLES


echo "Setting up the system"

while getopts "dlh" o; do 
	
	case "${o}" in
	h)
		printf "Arguments: \\n -d : Desktop \\n -l : Laptop \\n -h : Print this message \\n" && exit ;;
	d)
		COMPUTER=desktop 
		echo "$COMPUTER" ;;
	l)
		COMPUTER=laptop 
		echo "$COMPUTER" ;;
	*)
		printf "Invalid option: -%s\\n" "$OPTARG" && exit ;;	

	esac 

done


RUNDEB="$HOME/run-deb"
BIN="$HOME/bin"
DEV="$HOME/dev"
ZIPSTARS="$HOME/zips-tars"
QT="$HOME/dev/qt-creator-4.6.1"
VICODE="~/run-deb/code_*_amd64.deb"
NVIDIA="$HOME/run-deb/NVIDIA*"
ARDUINO="$HOME/dev/arduino"
INKSCAPE="$HOME/dev/inkscape"
TEMPORAL="$HOME/tmp"

if [ -d "$RUNDEB" ]; then
	echo "rundeb exists"
else
	mkdir "$RUNDEB"
	echo "run-deb created"
fi

if [ -d "$TEMPORAL" ]; then
	echo "tmp exists"
else
	mkdir "$TEMPORAL"
	echo "tmp created"
fi



if [ -d "$BIN" ]; then
	echo "bin exists"
else
	mkdir "$BIN"
	echo "bin created"
fi

if [ -d "$DEV" ]; then
	echo "dev exists"
else
	mkdir "$DEV"
	echo "dev created"
fi

if [ -d "$ZIPSTARS" ]; then
	echo "zips-tars exists"
else
	mkdir "$ZIPSTARS"
	echo "zips created"
fi

#Dialout

sudo adduser antonio dialout

#GIT

sudo apt-get install git

#EXFAT
sudo apt-get install exfat-utils
#QT Creator
if [ ! -d "$QT" ]; then
	cd ~/run-deb
	wget https://download.qt.io/official_releases/qtcreator/4.6/4.6.1/qt-creator-opensource-linux-x86_64-4.6.1.run
	sudo chmod +x qt-creator-opensource-linux-x86_64-4.6.1.run
	./qt-creator-opensource-linux-x86_64-4.6.1.run
else

	echo "QT Creator already installed!"

fi

#Visual Code
if [ ! -f "$VICODE" ]; then
	if [ -f "~/Downloads/code*deb" ]; then
		echo "Visual studio code found in Downloads folder"
		mv ~/Downloads/code*deb ~/run-deb
		cd ~/run-deb
		dpkg -i code*deb
		fi
	else
		echo "Download visual studio code first"
fi

#Arduino
if [ ! -d "$ARDUINO" ]; then
	if [ ! -f "~/Downloads/arduino" ]; then
		echo "Download Arduino and enter 1 when ready:"
		firefox --new-window https://www.arduino.cc/en/Main/Donate 
		read int
		if [ $int -eq 1 ]; then
			echo "Arduino downloaded"
			mkdir -p $ARDUINO
			cd $ARDUINO
			mv $HOME/Downloads/arduino* .
			tar xf arduino*
			mv arduino*xz $ZIPSTARS	
			cd arduino*
			sudo chmod +x ./arduino		
			export PATH="$PATH:$ARDUINO/arduino*"
		fi
	else
		echo "Arduino is in downloads folder"
	fi
else
	echo "Arduino already installed"
fi
if [ ! -d "$INKSCAPE" ]; then
	if [ ! -f "~/Downloads/inkscape*" ]; then
		echo "Download inkscape and enter 1 when ready:"
		firefox --new-window https://inkscape.org/release/inkscape-0.92.5/source/dl/
		read int
		if [ $int -eq 1 ]; then
			echo "Inkscape downloaded"
			mkdir -p $INKSCAPE
			cd $INKSCAPE
			mv $HOME/Downloads/inkscape* .
			tar xf inkscape*
			mv inkscape*bz2 $ZIPSTARS	
			cd inkscape
			wget -v https://gitlab.com/inkscape/inkscape-ci-docker/raw/master/install_dependencies.sh -O install_dependencies.sh
			bash install_dependencies.sh --recommended
			sudo chmod +x ./arduino		
			PATH="$PATH:$INKSCAPE/inkscape*"
			export $PATH
		fi
	else
		echo "Inkscape is in downloads folder"
	fi
else
	echo "Inkscape already installed"
fi


#VIM, youtube-dl, vlc, libreoffice, steam, pip
#Desktop packages (steam, resolve, blackmagic sdk, nvidia)
if [ "$COMPUTER" == desktop ]; then 
	if [ ! -d "/opt/resolve/" ]; then
		echo "Download Davinci Resolve and enter 1 when ready:"
		firefox --new-window https://www.blackmagicdesign.com/products/davinciresolve/ 
		read int
		if [ $int -eq 1 ]; then
			echo "Resolve downloaded"
			cd $ZIPS-TARS
			mkdir DaVinci_Resolve
			mv $HOME/Downloads/DaVinci_Resolve*.zip $ZIPSTARS/DaVinci_Resolve
			cd DaVinci_Resolve
			unzip DaVinci*
			./DaVinci_Resolve_*.run
			export PATH="$PATH:/opt/resolve/bin"
		fi
	else
		echo "DaVinci Resolve already installed"
	fi
	
	if [ ! -d "$HOME/3d/metashape" ]; then
		mkdir -p "$HOME"/3d
		echo "Download Metashape Standard and enter 1 when ready"
		firefox --new-window https://www.agisoft.com/downloads/installer/
		read int
		if [ $int -eq 1 ]; then
			echo "Metashape downloaded"
			mkdir $ZIPSTARS/metashape
			mv $HOME/Downloads/metashape*.tar.gz $ZIPSTARS/metashape
			cd $ZIPSTARS/metashape
			gunzip metashape*
			tar xvf metashape*
			mv metashape* "$HOME"/3d/
			mv "$HOME"/3d/*.tar $HOME/zips-tars/
			export PATH="$PATH:$HOME/3d/metashape"
		fi
	else
		echo "Metashape installed"
	fi
	
	if [ ! -d "$HOME/3d/blender" ]; then
		echo "Download Blender and enter 1 when ready"
		firefox --new-window https://www.blender.org/thanks/
		read int
		if [ $int -eq 1 ]; then
			echo "Blender downloaded"
			mkdir $ZIPSTARS/blender
			mv $HOME/Downloads/blender* $ZIPSTARS/blender/
			cd $ZIPSTARS/blender
			tar xf blender*xz
			mv blender*xz ..
			mv blender* $HOME/3d
			cd ..
			rm -r blender
			export PATH="$PATH:$HOME/3d/blender*/"
			
		fi
	else
		echo "Blender Installed"

	fi

	sudo ubuntu-drivers autoinstall	
fi

################################
#i3
PROG=i3

if [ ! -x "$(command -v $PROG)" ]; then

	sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake

	sudo apt-get install libxcb*

#cd $HOME
#mkdir tmp
#cd tmp
#git clone https://github.com/Airblader/xcb-util-xrm
#cd xcb-util-xrm
#git submodule update --init
#./autogen.sh --prefix=/usr
#make -j7
#sudo make install -j7

#cd $HOME/tmp

#git clone https://www.github.com/Airblader/i3 i3-gaps
#cd i3-gaps
#git checkout gaps && git pull
#autoreconf --force --install
#rm -rf build
#mkdir build
#cd build
#../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
#make -j7
#sudo make install -j7
	sudo add-apt-repository ppa:kgilmer/speed-ricer
	sudo apt-get update
	sudo apt-get install i3-gaps-wm
else
	echo"$PROG already installed"
fi

##################################################################

#pywal
PROG=wal
if [ ! -x "$(command -v $PROG)" ]; then
        sudo apt-get install imagemagick 
	sudo apt-get install pidof
	sudo apt-get install procps
	sudo apt-get install feh
	sudo apt-get install python3-pip 
        pip3 install pywal

else
        echo "Pywal already installed"
fi

#prusa slicer
PROG=prusa-slic3r
if [ ! -x "$(command -v $PROG)" ]; then
		echo "Download Prusa Slic3r and enter 1 when ready:"
		firefox --new-window https://www.prusa3d.com/drivers/
		read int
		if [ $int -eq 1 ]; then
			echo "Slicer downloaded"
			cd Downloads
			mkdir $ZIPSTARS/prusa
			mv prusa* $ZIPSTARS/prusa
			unzip $ZIPSTARS/prusa/prusa*
			sudo chmod +x PrusaSlicer*
		else
        		echo "Prusa Slicer already installed"
		fi
fi
#urxvt
PROG=urxvt
if [ ! -x "$(command -v $PROG)" ]; then
	sudo apt install rxvt-unicode
else
	echo"$PROG already installed"
fi

#rofi
PROG=rofi
if [ ! -x "$(command -v $PROG)" ]; then
	sudo apt install $PROG
else
	echo"$PROG already installed"
fi

#kicad
PROG=kicad
if [ ! -x "$(command -v $PROG)" ]; then
	sudo add-apt-repository --yes ppa:js-reynaud/kicad-5.1
	sudo apt update
	sudo apt install --install-recommends kicad
else
	echo"$PROG already installed"
fi

#rawtherapee
PROG=rawtherapee
if [ ! -x "$(command -v $PROG)" ]; then
	sudo apt install $PROG
else
	echo"$PROG already installed"
fi
  
#thunar
PROG=thunar
if [ ! -x "$(command -v $PROG)" ]; then
	sudo apt-get install thunar
else
        echo "$PROG already installed"
fi

#syncthing
PROG=syncthing
if [ ! -x "$(command -v $PROG)" ]; then
	sudo apt install curl apt-transport-https
	curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
	echo "deb https://apt.syncthing.net/ syncthing release" > /etc/apt/sources.list.d/syncthing.list
	sudo apt-get update
	sudo apt-get install syncthing
else
        echo "$PROG already installed"
fi

#nnn
PROG=nnn
if [ ! -x "$(command -v $PROG)" ]; then
	sudo apt install nnn
else
        echo "$PROG already installed"
fi



#polybar
PROG=polybar
if [ ! -x "$(command -v $PROG)" ]; then

  	sudo apt-get install \
    	cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev \
    	libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev \
    	libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen \
    	xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev \
    	libiw-dev libcurl4-openssl-dev libpulse-dev \
    	libxcb-composite0-dev xcb libxcb-ewmh2
  
  	cd $HOME/tmp
  	git clone https://github.com/jaagr/polybar.git
  	cd polybar
  	git tag # see what version do you need
  	git checkout 3.4.1
  	./build.sh
  else
	echo"$PROG already installed"
fi


sudo apt-get install steam
sudo apt-get install python-pip 
sudo apt-get install curl
sudo apt-get install vim
sudo apt-get install vlc
sudo apt-get install libreoffice 
sudo apt-get install youtube-dl
sudo pip install --upgrade youtube-dl
sudo apt-get install thunderbird
sudo apt-get install filezilla

#Wine
sudo dpkg --add-architecture i386 
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ eoan main'
sudo apt-get update

sudo apt install --install-recommends winehq-stable
sudo apt-get install winetricks
wineboot -u
wineserver -k
winetricks corefonts vcrun2010 vcrun2013 vcrun2015
winetricks win7
wineserver -k


#Discord


#sudo apt-get install libgconf


#TODO 



#Path

#export PATH="$PATH:$HOME/.local/bin"
