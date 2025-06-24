FROM ubuntu:22.04

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-21-jdk wget

# set up user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# prepare android directories and system varibles
RUN mkdir -p Android/sdk/cmdline-tools
ENV ANDROID_SDK_ROOT=/home/developer/Android/sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# prepare android sdk config
RUN mkdir -p .android && touch .android/repositories.cfg

# set up android sdk
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -O cmdline-tools.zip
RUN unzip cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && rm cmdline-tools.zip
RUN mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest

# install android sdk and agree to licences
RUN yes | sdkmanager --licenses
RUN sdkmanager  "build-tools;34.0.0" "platform-tools" "platforms;android-34" "sources;android-34" 

# download flutter sdk
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# run basic check to download dart sdk
RUN flutter doctor
