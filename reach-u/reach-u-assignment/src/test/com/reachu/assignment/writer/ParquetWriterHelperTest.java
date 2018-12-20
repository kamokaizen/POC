package com.reachu.assignment.writer;

import com.reachu.assignment.dto.parquet.SampleParquetDTO1;
import com.reachu.assignment.util.PartitionUtil;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ParquetWriterHelperTest {

    private ParquetWriterHelper<SampleParquetDTO1> parquetWriterHelper = new ParquetWriterHelper<>(SampleParquetDTO1.class);

    @Autowired
    PartitionUtil partitionUtil;

    private SampleParquetDTO1 record;
    private String filePath;

    @Before
    public void initObjects() {
        record = new SampleParquetDTO1(System.currentTimeMillis(), "kamo", 10, 10f,20.0,20, true);
        filePath = partitionUtil.getPartitionsPath() + "/test/" + record.getTimestamp() + ".parquet";
    }

    @Test
    public void contextLoads() throws Exception {
        assertThat(parquetWriterHelper).isNotNull();
    }

    @Test
    public void shouldWriteParquet() throws Exception {
        List list = new ArrayList<SampleParquetDTO1>();
        list.add(record);
        parquetWriterHelper.write(list, filePath);
        assertThat(new File(filePath).exists());
    }

    @Test
    public void shouldReadParquet()  throws Exception {
        // TODO
    }
}