package com.reachu.assignment.controller;

import com.reachu.assignment.dto.BaseRestResponse;
import com.reachu.assignment.dto.parquet.SampleParquetDTO1;
import com.reachu.assignment.dto.StatusDto;
import com.reachu.assignment.dto.parquet.SampleParquetDTO2;
import com.reachu.assignment.queue.ParquetMessageSender;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/queue")
public class QueueController {
    private static final Logger logger = LoggerFactory.getLogger(QueueController.class);

    @Autowired
    private ParquetMessageSender parquetMessageSender;

    @GetMapping(value = "/add")
    public ResponseEntity<BaseRestResponse> write() {
        try {
            parquetMessageSender.sendParquetData(new SampleParquetDTO1());
            parquetMessageSender.sendParquetData(new SampleParquetDTO2());
            return new ResponseEntity<>(new StatusDto(true, 200, "Parquet data added to queue, will be processed later"), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Something went wrong while adding parquet data to queue: " + e.getLocalizedMessage());
            return new ResponseEntity<>(new StatusDto(false, 500, "Something went wrong while adding parquet data to queue"),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
