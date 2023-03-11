#!/bin/bash

#OPTIONS AND VARIABLES


echo "Setting up the system"

while getopts "dlh" o; do 
	
	case "${o}" in
	h)
		printf "Arguments: \\n -d : Telecine \\n -h : Print this message \\n" && exit ;;
	d)
		COMPUTER=desktop 
		echo "$COMPUTER" ;;
	*)
		printf "Invalid option: -%s\\n" "$OPTARG" && exit ;;	

	esac 

done


RUNDEB="$HOME/run-deb"
BIN="$HOME/bin"
DEV="$HOME/dev"
ZIPSTARS="$HOME/zips-tars"
QT="$HOME/dev/qtcreator-4.6.1"
VICODE="$HOME/run-deb/code_*_amd64.deb"
NVIDIA="$HOME/run-deb/NVIDIA*"
ARDUINO="$HOME/dev/arduino"
INKSCAPE="$HOME/dev/inkscape"
OPENFRAMEWORKS="$HOME/dev/openframeworks"
BLACKMAGIC="$HOME/dev/blackmagic"
DECKLINK="$HOME/dev/blackmagic/decklink"
FFMPEG="$HOME/dev/FFmpeg"

if [ -d "$RUNDEB" ]; then
	echo "rundeb exists"
else
	mkdir "$RUNDEB"
	echo "run-deb created"
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

##CREATE LOG FILE

touch ~/install.log

#Dialout

sudo adduser $USER dialout
if [ $? -eq 0 ]; then
   echo OK
   echo "Added to dialout" >> ~/install.log
else
   echo FAIL
   echo "Not added to dialout"
fi
#GIT

sudo apt-get install git
if [ $? -eq 0 ]; then
   echo OK
   echo "git installed" >> ~/install.log
else
   echo FAIL
   echo "git failed to install" >> ~/install.log
fi


#EXFAT
sudo apt-get install exfat-utils
if [ $? -eq 0 ]; then
	   echo OK
	   echo "exfat-utils installed" >> ~/install.log
   else
	   echo FAIL
 	   echo "exfat-utils failed to install" >> ~/install.log
	   fi 
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
sudo apt-get install arduino
if [ $? -eq 0 ]; then
	   echo OK
	   echo "arduino installed" >> ~/install.log
   else
	      echo FAIL
	      echo "arduino failed to install" >> ~/install.log
fi


sudo apt-get install pip
if [ $? -eq 0 ]; then
	   echo OK
	   echo "pip installed" >> ~/install.log
   else
	      echo FAIL
	      echo "pip failed to install" >> ~/install.log
fi


#OPENFRAMEWORKS

if [ ! -d "$OPENFRAMEWORKS" ]; then
		
		echo "Download OpenFrameworks linux gcc 6 or later and enter 1 when ready"
		firefox --new-window https://openframeworks.cc/download/ &&
		read -n 1 -r
		if [[ $REPLY =~ [1]$ ]]; then
			echo "OpenFrameworks downloaded"
			mkdir $OPENFRAMEWORKS
			echo "OpenFrameworks folder created"
			mv $HOME/Downloads/of_v0* $OPENFRAMEWORKS
			cd $OPENFRAMEWORKS
			gunzip of_v0*
			tar xvf of_v0*
			cd $OPENFRAMEWORKS/of_v0*/scripts/linux/ubuntu
			sudo chmod +x install_codecs.sh
			sudo chmod +x install_dependencies.sh
			sudo ./install_codecs.sh
			sudo ./install_dependencies.sh
			
		fi
	else
		echo "Openframeworks downloaded and dependencies installed"

	fi




#Desktop packages (steam, resolve, blackmagic sdk, nvidia)
if [ "$COMPUTER" == desktop ]; then 
	if [ ! -d "/opt/resolve/" ]; then
		echo "Download Davinci Resolve and enter 1 when ready:"
		firefox --new-window https://www.blackmagicdesign.com/products/davinciresolve/ 
		read int
		if [ $int -eq 1 ]; then
			echo "Resolve downloaded"
			cd $ZIPSTARS
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
	
	if [ ! -d $BLACKMAGIC ]; then
		echo "Download BlackMagic Desktop Video and SDK and press 1 when ready:"
		firefox --new-window https://www.blackmagicdesign.com/developer/product/capture-and-playback
		read int 
		if [ $int -eq 1 ]; then
			echo "Desktop Video and SDK downloaded"
			cd $HOME/Downloads
			mv Blackmagic_Desktop_Video_Linux*tar.gz $ZIPSTARS
			mv Blackmagic_DeckLink_SDK* $BLACKMAGIC
			cd $ZIPSTARS
			gunzip Blackmagic_Desktop*
			tar xvf Blackmagic_Desktop_Video* 
			cd Blackmagic_Desktop_Video*
			cd deb
			cd x86_64
			dpkg -i *
			cd $BLACKMAGIC
			unzip Blackmagic_DeckLink*
			mv Blackmagic\ DeckLink\ SDK\ * decklink
			sudo ldconfig

		fi
	else
		echo "Desktop Video and SDK already donwloaded"
	
	fi


	sudo ubuntu-drivers autoinstall	
fi


#FFMPEG
	if [ ! -d $FFMPEG ]; then
		cd ~/dev
		mkdir FFmpeg
		cd ~/dev/FFmpeg
		mkdir -p ffmpeg_sources 
		cp -r $DECKLINK ffmpeg_sources/BMD_SDK
		sudo apt-get update -qq && sudo apt-get -y install \
  		autoconf \
  		automake \
 		build-essential \
  		cmake \
  		git-core \
  		libass-dev \
  		libfreetype6-dev \
  		libtool \
  		libvorbis-dev \
  		pkg-config \
  		texinfo \
  		wget \
  		zlib1g-dev
		sudo apt-get -y install \
  		nasm yasm libx264-dev libx265-dev libnuma-dev libvpx-dev \
  		libfdk-aac-dev libmp3lame-dev libopus-dev
		cd ~/dev/FFmpeg/ffmpeg_sources
		git clone https://github.com/acastles91/FFmpeg
		cd FFmpeg
		PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="~/dev/FFmpeg/ffmpeg_build/lib/pkgconfig" ./configure \
		--prefix="$FFMPEG/ffmpeg_build" \
  		--pkg-config-flags="--static" \
  		--extra-cflags="-I$FFMPEG/ffmpeg_build/include -I$FFMPEG/ffmpeg_sources/BMD_SDK/Linux/include" \
  		--extra-ldflags="-L$FFMPEG/ffmpeg_build/lib" \
  		--extra-libs="-lpthread -lm" \
  		--bindir="$HOME/bin" \
  		--enable-gpl \
  		--enable-libass \
  		--enable-libfdk-aac \
  		--enable-libfreetype \
  		--enable-libmp3lame \
  		--enable-libopus \
  		--enable-libvorbis \
  		--enable-libvpx \
  		--enable-libx264 \
 	 	--enable-libx265 \
  		--enable-nonfree \
  		--enable-decklink
		PATH="$HOME/bin:$PATH" make -j `nproc`
		make install -j `nproc`
		sudo cp ffmpeg ffprobe /usr/local/bin/
		hash -r
		source ~/.profile
		
		echo "FFmpeg installed"
		echo "FFmpeg installed" >> ~/install.log

	else
		echo "FFmpeg already installed"
	
	fi




################################

#kicad
PROG=kicad
if [ ! -x "$(command -v $PROG)" ]; then
	sudo add-apt-repository --yes ppa:js-reynaud/kicad-5.1
	sudo apt update
	sudo apt install --install-recommends kicad
else
	echo"$PROG already installed"
fi

sudo apt-get install python-pip 
if [ $? -eq 0 ]; then
	   echo OK
	echo "python-pip installed" >> ~/install.log
   else
	      echo FAIL
	echo "python-pip failed to install" >> ~/install.log
	      fi
sudo apt-get install curl
if [ $? -eq 0 ]; then
	   echo OK
	   echo "curl installed" >> install.log
   else
	      echo FAIL
	   echo "curl failed to install" >> install.log
	      fi
sudo apt-get install vim
if [ $? -eq 0 ]; then
	   echo OK
	   echo "vim installed" >> ~/install.log
   else
	      echo FAIL
	      echo "vim failed to install" >> ~/install.log
      fi
sudo apt-get install vlc
if [ $? -eq 0 ]; then
   echo OK
   echo "vlc installed" >> ~/install.log
else
   echo FAIL
   echo "vlc failed to install" >> ~/install.log
fi
sudo apt-get install libreoffice 
if [ $? -eq 0 ]; then
   echo OK
   echo "libre office installed" >> ~/install.log
else
   echo FAIL
   echo "libreoffice failed to install" >> ~/install.log
fi
sudo apt-get install youtube-dl
if [ $? -eq 0 ]; then
   echo OK
   echo "youtube-dl installed" >> ~/install.log
else
   echo FAIL
   echo "youtube-dl failed to install" >> ~/install.log
fi


