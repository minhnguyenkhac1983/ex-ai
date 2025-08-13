const { Kafka } = require('kafkajs')

function createKafkaProducer({ brokers }) {
  const kafka = new Kafka({ clientId: 'market-data', brokers })
  const producer = kafka.producer()
  async function start() { await producer.connect() }
  async function publish(topic, message) {
    await producer.send({ topic, messages: [{ value: JSON.stringify(message) }] })
  }
  async function stop() { await producer.disconnect() }
  return { start, publish, stop }
}

module.exports = { createKafkaProducer }


