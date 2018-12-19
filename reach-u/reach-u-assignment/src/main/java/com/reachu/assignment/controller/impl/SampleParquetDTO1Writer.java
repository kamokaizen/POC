package com.reachu.assignment.controller.impl;

import com.reachu.assignment.controller.base.AbstractPartitionWriter;
import com.reachu.assignment.controller.base.PartitionWriter;
import com.reachu.assignment.dto.parquet.SampleParquetDTO1;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

/**
 * Created by kamili on 19/12/2018.
 */
@Configuration
public class SampleParquetDTO1Writer extends AbstractPartitionWriter<SampleParquetDTO1> implements PartitionWriter<SampleParquetDTO1> {

    @Override
    public void write(SampleParquetDTO1 rec) throws IOException {
        this.writeData(rec);
    }

    @Override
    protected Class<SampleParquetDTO1> getClassOfChild() {
        return SampleParquetDTO1.class;
    }
}
