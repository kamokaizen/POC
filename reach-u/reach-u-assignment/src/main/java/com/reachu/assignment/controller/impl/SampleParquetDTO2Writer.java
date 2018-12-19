package com.reachu.assignment.controller.impl;

import com.reachu.assignment.controller.base.AbstractPartitionWriter;
import com.reachu.assignment.controller.base.PartitionWriter;
import com.reachu.assignment.dto.parquet.SampleParquetDTO2;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

/**
 * Created by kamili on 19/12/2018.
 */
@Configuration
public class SampleParquetDTO2Writer extends AbstractPartitionWriter<SampleParquetDTO2> implements PartitionWriter<SampleParquetDTO2> {

    @Override
    public void write(SampleParquetDTO2 rec) throws IOException {
        this.writeData(rec);
    }

    @Override
    protected Class<SampleParquetDTO2> getClassOfChild() {
        return SampleParquetDTO2.class;
    }
}
