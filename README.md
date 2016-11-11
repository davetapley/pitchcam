
```
docker build -t pitchcam .
docker run -it --rm -e DISPLAY=$DISPLAY --env="QT_X11_NO_MITSHM=1" --privileged -v /dev/video0:/dev/video0 -v /tmp/.X11-unix:/tmp/.X11-unix:ro pitchcam ruby local.rb
```
