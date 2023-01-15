import sys
import json

from confluent_kafka import Consumer, KafkaException, KafkaError, Message
from typing import List


def msg_process(msg: Message):
    print(f"processing message... [{msg.offset()}]", flush=True)
    msg_values = json.loads(msg.value())
    for key, value in msg_values['payload'].items():
        print(f"{key}:{value}", flush=True)


def basic_consume_loop(consumer: Consumer, topics: List[str]):
    try:
        print(f"consuming topics {topics}", flush=True)
        consumer.subscribe(topics)
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    sys.stderr.write(f'{msg.topic()} [{msg.topic()}] reached end at offset {msg.offset()}\n')
                elif msg.error():
                    raise KafkaException(msg.error())
            else:
                msg_process(msg)
                consumer.commit(msg)
    finally:
        consumer.close()


if __name__ == '__main__':
    topic = sys.argv[1]
    conf = {'bootstrap.servers': 'kafka:9092',
            'group.id': "foo",
            'enable.auto.commit': False,
            'auto.offset.reset': 'earliest'}

    consumer = Consumer(conf)
    basic_consume_loop(consumer=consumer, topics=[f'{topic}'])
