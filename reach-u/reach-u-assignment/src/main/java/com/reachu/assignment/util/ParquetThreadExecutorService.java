package com.reachu.assignment.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by kamili on 18/12/2018.
 */
@Configuration
public class ParquetThreadExecutorService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ParquetThreadExecutorService.class);

    private ExecutorService executor;

    @Autowired
    public ParquetThreadExecutorService(@Value("${workerThreadSize}") final int workerThreadSize) {
        try{
            executor = Executors.newFixedThreadPool(workerThreadSize);
            LOGGER.info("Thread executor service started with pool size: {}", workerThreadSize);
        }
        catch(Exception er){
            LOGGER.error("Thread executor service failed to start: ", er.getLocalizedMessage());
            er.printStackTrace();
        }
    }
}
