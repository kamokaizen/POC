package com.reachu.assignment.queue;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.amqp.core.*;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by kamili on 19/12/2018.
 */
@Configuration
public class RabbitConfig {
    public static final String QUEUE_PARQUETS = "parquet-queue";
    public static final String QUEUE_DEAD_PARQUETS = "parquet-dead-queue";
    public static final String EXCHANGE_PARQUETS = "parquet-exchange";

    private Map<String,Object> queueParameters = new HashMap<>();

    public RabbitConfig(@Value("${rabbitmq.queue.maxlengthinbytes}") final int maxLengthInBytes) {
        queueParameters = new HashMap<>();
        queueParameters.put("x-max-length-bytes", maxLengthInBytes); // Total body size for ready messages a queue can contain before it starts to drop them from its head.(Sets the "x-max-length-bytes" argument.)
//        queueParameters.put("x-max-length", setIsMaxLength); // How many (ready) messages a queue can contain before it starts to drop them from its head.(Sets the "x-max-length" argument.)
    }

    @Bean
    Queue ordersQueue() {
        return QueueBuilder.durable(QUEUE_PARQUETS).withArguments(queueParameters).build();
    }

    @Bean
    Queue deadLetterQueue() {
        return QueueBuilder.durable(QUEUE_DEAD_PARQUETS).build();
    }

    @Bean
    Exchange ordersExchange() {
        return ExchangeBuilder.topicExchange(EXCHANGE_PARQUETS).build();
    }

    @Bean
    Binding binding(Queue ordersQueue, TopicExchange ordersExchange) {
        return BindingBuilder.bind(ordersQueue).to(ordersExchange).with(QUEUE_PARQUETS);
    }
}
