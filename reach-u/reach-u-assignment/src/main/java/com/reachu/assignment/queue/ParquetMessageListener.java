package com.reachu.assignment.queue;

import com.reachu.assignment.writer.impl.SampleParquetDTO1Writer;
import com.reachu.assignment.writer.impl.SampleParquetDTO2Writer;
import com.reachu.assignment.dto.parquet.BaseParquetDTO;
import com.reachu.assignment.dto.parquet.SampleParquetDTO1;
import com.reachu.assignment.dto.parquet.SampleParquetDTO2;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Created by kamili on 19/12/2018.
 */
@Component
public class ParquetMessageListener {
    private static final Logger LOGGER = LoggerFactory.getLogger(ParquetMessageListener.class);

    @Autowired
    private SampleParquetDTO1Writer sampleParquetDTO1Writer;

    @Autowired
    private SampleParquetDTO2Writer sampleParquetDTO2Writer;

    public ParquetMessageListener() {

    }

    @RabbitListener(queues = RabbitConfig.QUEUE_PARQUETS)
    public void processParquetData(BaseParquetDTO baseParquetDTO) {
        if(baseParquetDTO != null && baseParquetDTO instanceof SampleParquetDTO1){
            try{
                sampleParquetDTO1Writer.write((SampleParquetDTO1) baseParquetDTO);
            }
            catch(IOException e){
                LOGGER.error("Something went wrong: {}", e.getLocalizedMessage());
            }
        }
        else if(baseParquetDTO != null && baseParquetDTO instanceof SampleParquetDTO2){
            try{
                sampleParquetDTO2Writer.write((SampleParquetDTO2) baseParquetDTO);
            }
            catch(IOException e){
                LOGGER.error("Something went wrong: {}", e.getLocalizedMessage());
            }
        }
    }
}
