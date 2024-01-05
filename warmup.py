import tensorflow as tf
import requests
import numpy as np

from tensorflow.python.framework import tensor_util
from tensorflow_serving.apis import predict_pb2
from tensorflow_serving.apis import prediction_log_pb2

image_size=299
model_name='xception'
NUM_RECORDS = 1

def main():
    """Generate TFRecords for warming up."""

    with tf.io.TFRecordWriter("tf_serving_warmup_requests") as writer:
        image_np = np.random.rand(image_size, image_size, 3).astype(np.float32)
        image_np *= 256.0
        image_np=image_np.tolist()
        predict_request = predict_pb2.PredictRequest()
        predict_request.model_spec.name = model_name  # modelname
        predict_request.model_spec.signature_name = 'serving_default'
        predict_request.inputs['input_8'].CopyFrom(  # input_1 
            tensor_util.make_tensor_proto([image_np]))        
        log = prediction_log_pb2.PredictionLog(
            predict_log=prediction_log_pb2.PredictLog(request=predict_request))
        for r in range(NUM_RECORDS):
            writer.write(log.SerializeToString())   

    print("ok!") 

if __name__ == "__main__":
    main()