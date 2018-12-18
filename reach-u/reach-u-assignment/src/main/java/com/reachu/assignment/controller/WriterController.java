package com.reachu.assignment.controller;

import avro.shaded.com.google.common.collect.Iterables;
import com.reachu.assignment.dto.BaseRestResponse;
import com.reachu.assignment.dto.SampleParquetDTO1;
import com.reachu.assignment.dto.StatusDto;
import com.reachu.assignment.util.ParquetWriterHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/writer")
public class WriterController {
    private static final Logger logger = LoggerFactory.getLogger(WriterController.class);

    @Value("${partition.path}")
    private String partitionsPath;


    @GetMapping(value = "/write")
    public ResponseEntity<BaseRestResponse> write() {
        try {
            List<SampleParquetDTO1> records = new ArrayList<>();
            records.add(new SampleParquetDTO1(System.currentTimeMillis(), "kamokaizen", 1.2f, 134.11));
            records.add(new SampleParquetDTO1(System.currentTimeMillis(), "newuser", 1.8f, 12.15));
            ParquetWriterHelper<SampleParquetDTO1> writer = new ParquetWriterHelper<>(SampleParquetDTO1.class);
            writer.write(records, partitionsPath + "/" + "test.parquet");

            return new ResponseEntity<>(new StatusDto(true, 200, "Wrıte Successfully returned"), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("FAIL to wrıte: " + e.getLocalizedMessage() + "!");
            return new ResponseEntity<>(new StatusDto(false, 500, "Something went wrong while getting brands"),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
