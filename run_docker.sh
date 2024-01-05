date "+%Y-%m-%d %H:%M:%S.%N"
docker run -p 8500:8500 \
    --mount type=bind,source=/home/kkq/models/Imagenet/ResNet50,target=/models/ResNet50 \
    --mount type=bind,source=/home/kkq/models/session.config,target=/models/session.config \
    -e MODEL_NAME=ResNet50\
    -t tensorflow/serving \
    --tensorflow_session_config_file=/models/session.config \
    --enable_model_warmup=true &
#   --cpus 0.5 \
#   --memory  1g \
#   --cpuset-cpus="0" \

