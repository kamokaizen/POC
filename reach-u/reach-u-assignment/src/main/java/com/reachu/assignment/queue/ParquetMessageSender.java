package com.reachu.assignment.queue;

import com.reachu.assignment.dto.parquet.BaseParquetDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by kamili on 19/12/2018.
 */
@Service
public class ParquetMessageSender {
    private static final Logger LOGGER = LoggerFactory.getLogger(ParquetMessageListener.class);

    private final RabbitTemplate rabbitTemplate;

    @Autowired
    public ParquetMessageSender(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void sendParquetData(BaseParquetDTO baseParquetDTO) {
        this.rabbitTemplate.convertAndSend(RabbitConfig.QUEUE_PARQUETS, baseParquetDTO);
        LOGGER.debug("A message send to queue on date", System.currentTimeMillis());
    }
}
