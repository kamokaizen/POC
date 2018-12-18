package com.reachu.assignment.controller;

import com.reachu.assignment.dto.BaseRestResponse;
import com.reachu.assignment.dto.StatusDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/writer")
public class WriterController {
    private static final Logger logger = LoggerFactory.getLogger(WriterController.class);

    @GetMapping(value = "/write")
    public ResponseEntity<BaseRestResponse> write() {
        try {
            return new ResponseEntity<>(new StatusDto(true, 200, "Wrıte Successfully returned"), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("FAIL to wrıte: " + e.getLocalizedMessage() + "!");
            return new ResponseEntity<>(new StatusDto(false, 500, "Something went wrong while getting brands"),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
