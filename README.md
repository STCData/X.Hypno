
[![Build@Mac](https://github.com/STCData/Hypno/actions/workflows/xcodebuild.yml/badge.svg)](https://github.com/STCData/Hypno/actions/workflows/xcodebuild.yml)
[![Build@Linux](https://github.com/STCData/Hypno/actions/workflows/linuxbuild.yml/badge.svg)](https://github.com/STCData/Hypno/actions/workflows/linuxbuild.yml)


![appstore](https://user-images.githubusercontent.com/309302/227924760-e1741c61-63cd-4d89-94a6-1189929c0ab8.png)


# Hypno, aka STCiOSXDataCollector

STCiOSXDataCollector is an iOS/OSX application that logs detected text, human poses, window manager information, and user actions from the built-in web browser, terminal emulator, camera, and any other external application. It also has deep ChatGPT integration and in-app javascript applet development enviroment. It is part of [STCData](https://github.com/STCData) project - a full stack solution for ML data collection. See [docs](https://stcdata.github.io/STCData/), [server-side](https://github.com/STCData/STCDataServer), or silly AI generated [promo](https://tome.app/stc-9d6/shoggoth-binding-collaborative-ml-data-preprocessing-with-chat-driven-editing-clfjg4et32cgs9m422fqijwvt)

## Exciting Features

* Built-in browser with hierarchical tabs on the sidebar on the left
* Camera and system-wide/in-app broadcast
* ML recognizers for visual data (camera and screencast, as well as browser), such as human face/body/hands recognizers, OCR, objects recognizers, and any other CoreML models supplied by the user
* Realtime observation of ML data modification with on-fly code generation using the JS Applet written by integrated ChatGPT and launched in transparent overlayed browser
* VT-100 terminal emulator for logging

### ChatGPT Integration

STCiOSXDataCollector is integrated with ChatGPT, a large language model trained by OpenAI, based on the GPT-3.5 architecture. The integration allows for an interactive experience with the observed ML data.

With ChatGPT, users can create overlays with detected data by providing natural language commands. For example, a user can tell ChatGPT "Overlay stars over all detected in camera human fingers" and the ML recognizers will detect the human fingers in the camera feed and overlay stars over them. 

The JS Applet written by ChatGPT is launched in a transparent overlayed browser, allowing for the overlaid visual data to be seen on top of any open application.

This integration with ChatGPT adds a powerful new layer of interactivity to the observed ML data, allowing for on-the-fly modifications and overlays based on natural language commands.

### Deep ChatGPT Integration

STCiOSXDataCollector offers a deep integration with ChatGPT, a state-of-the-art language model that allows users to interact with the observed ML data using natural language commands. With ChatGPT, users can create complex and imaginative prompts to manipulate and overlay the observed data in real-time.

For example, users can prompt the application to overlay emojis on top of detected objects, add filters to the camera feed, or even generate 3D models of detected objects. The natural language interface provided by ChatGPT allows for easy experimentation and exploration of the observed data, making it accessible to a wider range of users.


This integration has the potential to revolutionize industries that rely on real-time data analysis, such as security and surveillance, manufacturing, and healthcare. With the ability to quickly and easily manipulate and analyze large amounts of data, users can make more informed decisions and identify patterns that may have otherwise gone unnoticed.

For example, in a manufacturing setting, STCiOSXDataCollector could be used to monitor and analyze the movements of workers on the factory floor, identifying potential safety hazards or inefficiencies in the production process. In healthcare, the application could be used to monitor patient movements and detect early signs of mobility issues or falls.


Users can customize the ML recognizers and prompts, making it a powerful tool for data analysis and exploration.

### Sample Prompts

- Overlay hearts over detected faces in the camera feed
- Generate a heatmap of user clicks in the browser
- Add a black and white filter to the camera feed
- Overlay 3D models of detected objects in the camera feed
- Generate a word cloud of detected text in the browser
- Overlay bounding boxes around detected objects in the screencast
- Play a sound effect whenever a specific object is detected in the camera feed

## License

STCiOSXDataCollector is released under the [MIT License](https://opensource.org/licenses/MIT).

## Contribution

Contributions to STCiOSXDataCollector are welcome and encouraged. If you would like to contribute, please fork the repository and submit a pull request.

## Issues

If you encounter any issues while using STCiOSXDataCollector, please report them on the [GitHub Issues](https://github.com/USERNAME/REPOSITORY/issues) page.

## Usage

To use STCiOSXDataCollector,


