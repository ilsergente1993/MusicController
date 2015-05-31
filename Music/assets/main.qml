/*
 * Copyright (c) 2013-2015 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4
import bb.multimedia 1.2

import customtimer 1.0

Page {
    id: mainPage
    Container {
        id: mainPageCont
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        topPadding: 40
        attachedObjects: [
            // Create a NowPlayingController object
            NowPlayingController {
                id: nowPlayingController
                // handle various events sent by the NowPlayingController and update the controls
                onDurationChanged: {
                    length.text = duration;
                    progressIndicator.toValue = duration;
                }
                onNextEnabledChanged: {
                    next.enabled = nextEnabled;
                }
                onPreviousEnabledChanged: {
                    prev.enabled = previousEnabled;
                }
                onMediaStateChanged: {
                    playState.text = mediaState;
                }
                onMetaDataChanged: {
                    artist.text = metaData["artist"];
                    album.text = metaData["album"];
                    title.text = metaData["title"];
                }
                onPositionChanged: {
                    currentPosition.text = nowPlayingController.position;
                    progressIndicator.value = nowPlayingController.position;
                }
                onIconUrlChanged: {
                    albumArt.imageSource = nowPlayingController.iconUrl
                }
            }
        ]
        ImageView {
            id: albumArt
            imageSource: "asset:///images/disk_album.png"//album_cover.png"
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            preferredHeight: 300
            preferredWidth: 300
            scalingMethod: ScalingMethod.AspectFit
            filterColor: Color.create(255, 255, 255)
        }
        Container {
            layout: StackLayout {
            }
            horizontalAlignment: HorizontalAlignment.Fill
            Label {
                id: title
                text: "-"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XLarge
            }
        }
        Container {
            layout: StackLayout {
            }
            horizontalAlignment: HorizontalAlignment.Fill
            Label {
                id: album
                text: "-"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXLarge
            }
        }
        Container {
            layout: StackLayout {
            }
            horizontalAlignment: HorizontalAlignment.Fill
            Label {
                id: artist
                text: "-"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XLarge
                textStyle.fontWeight: FontWeight.Bold
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: "Duration (ms):"
            }
            Label {
                id: length
                text: ""
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: "Position (ms):"
            }
            Label {
                id: currentPosition
                text: ""
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            layout: StackLayout {
            }
            ProgressIndicator {
                id: progressIndicator
                fromValue: 0
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Button {
                id: volUp
                text: "Vol Up"
                onClicked: {
                    nowPlayingController.volumeUp();
                }
            }
            Button {
                id: volDown
                text: "Vol Down"
                onClicked: {
                    nowPlayingController.volumeDown();
                }
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Button {
                id: play
                text: "Play"
                onClicked: {
                    nowPlayingController.play();
                }
            }
            Button {
                id: pause
                text: "Pause"
                onClicked: {
                    nowPlayingController.pause();
                }
            }
            Button {
                id: playPause
                text: "PlayPause"
                onClicked: {
                    nowPlayingController.playPause();
                }
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Button {
                id: prev
                text: "Previous"
                onClicked: {
                    nowPlayingController.previous();
                }
            }
            Button {
                id: next
                text: "Next"
                onClicked: {
                    nowPlayingController.next();
                }
            }
        }
        Container {
            topPadding: 10
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: "Play State:"
            }
            Label {
                id: playState
                text: ""
            }
        }
    }
    attachedObjects: [
        Timer {
            property double inf: 0.1 //limite inferiore
            property double sup: 0.7 //limite superiore
            property double red: inf*2
            property double green: inf*2
            property double blue: inf*2
            property bool v_red: true
            property bool v_green: true
            property bool v_blue: true
            property int state: 0 //0=red, 1=green, 2=blue
            property double incr: 0.01
            id: timerCambiaColoreAlbum
            interval: 50
            onTimeout: {
                //console.debug(red + ": " + v_red + ", " + green + ", " + blue);
                switch (state % 3) {
                    case 0:
                        if (red < sup && red > inf) {
                            v_red ? red += incr : red -= incr;
                            red = red.toFixed(2);
                        } else {
                            v_red = ! v_red;
                            if (red >= sup) red = sup - incr;
                            else if (red <= inf) red = inf + incr;
                            state ++;
                        }
                        break;
                    case 1:
                        if (green < sup && green > inf) {
                            v_green ? green += incr : green -= incr;
                            green = green.toFixed(2);
                        } else {
                            v_green = ! v_green;
                            if (green >= sup) green = sup - incr;
                            else if (green <= inf) green = inf + incr;
                            state ++;
                        }
                        break;
                    case 2:
                        if (blue < sup && blue > inf) {
                            v_blue ? blue += incr : blue -= incr;
                            blue = blue.toFixed(2);
                        } else {
                            v_blue = ! v_blue;
                            if (blue >= sup) blue = sup - incr;
                            else if (blue <= inf) blue = inf + incr;
                            state ++;
                        }
                        break;
                }
                //albumArt.filterColor = Color.create(red, green, blue, 1);
                mainPageCont.background = Color.create(red, green, blue, 1);
            }
            onCreationCompleted: {
                timerCambiaColoreAlbum.start();
            }
        }
    ]
}