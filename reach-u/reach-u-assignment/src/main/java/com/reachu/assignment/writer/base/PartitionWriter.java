package com.reachu.assignment.writer.base;

import com.reachu.assignment.dto.parquet.BaseParquetDTO;

import java.io.IOException;

/**
 * Created by kamili on 19/12/2018.
 */
public interface PartitionWriter<E extends BaseParquetDTO> {
    void write(E rec) throws IOException;
}
