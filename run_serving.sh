date "+%Y-%m-%d %H:%M:%S.%N"
./bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server \
    --rest_api_port=8008 \
    --model_config_file=model.config  \
    --tensorflow_session_config_file=session.config \
    --enable_model_warmup=true

