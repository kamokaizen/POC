package com.reachu.assignment.controller;

import com.reachu.assignment.dto.BaseRestResponse;
import com.reachu.assignment.dto.parquet.SampleParquetDTO1;
import com.reachu.assignment.dto.StatusDto;
import com.reachu.assignment.dto.parquet.SampleParquetDTO2;
import com.reachu.assignment.queue.ParquetMessageSender;
import com.reachu.assignment.util.PartitionUtil;
import com.reachu.assignment.writer.ParquetWriterHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class Controller {
    private static final Logger logger = LoggerFactory.getLogger(Controller.class);

    @Autowired
    private ParquetMessageSender parquetMessageSender;

    @Autowired
    private PartitionUtil partitionUtil;

    @GetMapping(value = "/queue/add")
    public ResponseEntity<BaseRestResponse> write() {
        try {
            parquetMessageSender.sendParquetData(new SampleParquetDTO1());
//            parquetMessageSender.sendParquetData(new SampleParquetDTO2());
            return new ResponseEntity<>(new StatusDto(true, 200, "Parquet data added to queue, will be processed later"), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Something went wrong while adding parquet data to queue: " + e.getLocalizedMessage());
            return new ResponseEntity<>(new StatusDto(false, 500, "Something went wrong while adding parquet data to queue"),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/parquet/read")
    public ResponseEntity<BaseRestResponse> read(@RequestParam("timestamp") long timestamp) {
        try {
            ParquetWriterHelper<SampleParquetDTO1> helper = new ParquetWriterHelper<>(SampleParquetDTO1.class);
            List<SampleParquetDTO1> parquets = helper.read(partitionUtil.getPartitionFilePath(timestamp), SampleParquetDTO1.class);
            return new ResponseEntity<>(new StatusDto(true, 200, "Parquet data read", parquets.toArray(new SampleParquetDTO1[parquets.size()])), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Something went wrong while read parquet data: " + e.getLocalizedMessage());
            return new ResponseEntity<>(new StatusDto(false, 500, "Something went wrong while read parquet data"),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
